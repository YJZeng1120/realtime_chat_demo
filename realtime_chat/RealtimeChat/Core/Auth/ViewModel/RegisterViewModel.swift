import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var email=""
    @Published var password=""
    @Published var fullname=""

    @Published var showAlert=false
    @Published var errorMessage=""

    @Published var status: LoadStatus = .initial

    @MainActor
    func createUser() async throws {
        do {
            status=LoadStatus.inProgress
            try await AuthService.shared.createUser(email: email, password: password, fullname: fullname)
            status=LoadStatus.succeed

        } catch let error as AuthError {
            status=LoadStatus.failed
            showAlert=true
            errorMessage="\(error.errorDescription)"

            print("Register error: \(error.localizedDescription)")
        }
    }
}
