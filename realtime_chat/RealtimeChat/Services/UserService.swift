import Firebase
import FirebaseFirestoreSwift

class UserService {
    @Published var currentUser: User?

    static let shared = UserService()

    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = FirebaseManager.shared.currentUid else {
            return
        }
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        currentUser = user
    }

    static func fetchAllUsers() async throws -> [User] {
        let snapshot = try await FirestoreConstants.UserCollection.getDocuments()
        let users = snapshot.documents.compactMap { try? $0.data(as: User.self) }
        return users
    }

    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        FirestoreConstants.UserCollection.document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else {
                return
            }
            completion(user)
        }
    }
}
