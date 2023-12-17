import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI

class AuthService {
    @Published var userSession: FirebaseAuth.User?

    static let shared = AuthService()

    init() {
        self.userSession = FirebaseManager.shared.auth.currentUser
        loadCurrentUserData()
        print("Current user id : \(String(describing: userSession?.uid))")
    }

    @MainActor
    func login(email: String, password: String) async throws {
        do {
            let result = try await FirebaseManager.shared.auth.signIn(withEmail: email, password: password)

            userSession = result.user
            loadCurrentUserData()
        } catch {
            let error = error as NSError
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw AuthError.emailAlreadyInUse
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthError.invalidEmail
            case AuthErrorCode.wrongPassword.rawValue:
                throw AuthError.wrongPassword
            case AuthErrorCode.invalidCredential.rawValue:
                throw AuthError.wrongPassword
            case AuthErrorCode.tooManyRequests.rawValue:
                throw AuthError.tooManyRequests
            case AuthErrorCode.networkError.rawValue:
                throw AuthError.networkError

            default:
                throw AuthError.unknownError
            }
        }
    }

    @MainActor
    func createUser(email: String, password: String, fullname: String) async throws {
        do {
            let result = try await FirebaseManager.shared.auth.createUser(withEmail: email, password: password)

            userSession = result.user
            loadCurrentUserData()

            // 上傳User到Firestore
            try await uploadUserData(email: email, fullname: fullname, id: result.user.uid)

            print("Create User uid: \(result.user.uid)")
        } catch {
            let error = error as NSError
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw AuthError.emailAlreadyInUse
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthError.invalidEmail
            case AuthErrorCode.wrongPassword.rawValue:
                throw AuthError.wrongPassword
            case AuthErrorCode.invalidCredential.rawValue:
                throw AuthError.wrongPassword
            case AuthErrorCode.tooManyRequests.rawValue:
                throw AuthError.tooManyRequests
            case AuthErrorCode.networkError.rawValue:
                throw AuthError.networkError

            default:
                throw AuthError.unknownError
            }
        }
    }

    func logOut() {
        do {
            try FirebaseManager.shared.auth.signOut()
            userSession = nil
            UserService.shared.currentUser = nil
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }

    private func uploadUserData(email: String, fullname: String, id: String) async throws {
        let user = User(fullname: fullname, email: email, avatarImageUrl: nil)

        guard let
            encodedUser = try? Firestore.Encoder().encode(user)
        else {
            return
        }

        try await
            FirestoreConstants.UserCollection.document(id).setData(encodedUser)
    }

    private func loadCurrentUserData() {
        Task {
            try await UserService.shared.fetchCurrentUser()
        }
    }
}
