import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email=""
    @Published var password=""

    @Published var showAlert=false
    @Published var errorMessage=""

    @Published var status: LoadStatus = .initial

    @MainActor
    func login() async throws {
        do {
            status=LoadStatus.inProgress
            try await AuthService.shared.login(email: email, password: password)
            status=LoadStatus.succeed

        } catch let error as AuthError {
            status=LoadStatus.failed
            showAlert=true
            errorMessage="\(error.errorDescription)"

            print("Login error: \(error.localizedDescription)")
        }
    }
}
