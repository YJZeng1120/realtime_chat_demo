import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @FocusState var isFocus: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    AuthTitle(title: "Hello \nWelcome Back !")
                        .lineSpacing(10)

                    Group {
                        HStack {
                            Image(systemName: "mail")
                                .frame(width: 20)
                            TextField("Please enter your email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .focused($isFocus)
                        }
                        HStack {
                            Image(systemName: "key")
                                .frame(width: 20)
                            SecureField("Please enter your password", text: $viewModel.password)
                                .focused($isFocus)
                        }
                    }
                    .authTextFieldModifier()

                    AuthButton(
                        action: {
                            Task { try await viewModel.login() }
                        }, labelText: "Log In"
                    )
                    .disabled(viewModel.email.isEmpty || !(6 ... 16).contains(viewModel.password.count))

                    Spacer()

                    NavigationLink {
                        RegisterView()
                    } label: {
                        AuthFooter(
                            description: "Don't have an account ?",
                            pageName: "Sign Up"
                        )
                    }
                    .padding()
                }
                .onTapGesture { isFocus = false }
                .background(Color.theme.backgroundColor)
                .alert("Oops", isPresented: $viewModel.showAlert) {
                    Button {
                        viewModel.showAlert = false
                    } label: { Text("OK") }
                } message: { Text(viewModel.errorMessage) }

                // LoadStatus
                if viewModel.status == LoadStatus.inProgress {
                    ProgressView()
                        .scaleEffect(3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.primary.opacity(0.4))
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
