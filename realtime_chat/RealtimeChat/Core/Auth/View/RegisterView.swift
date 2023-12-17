import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    @FocusState var isFocus: Bool

    var body: some View {
        ZStack {
            VStack {
                AuthTitle(title: "Create Account")

                Group {
                    HStack {
                        Image(systemName: "mail")
                            .frame(width: 20)
                        TextField("Enter your email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .focused($isFocus)
                    }
                    HStack {
                        Image(systemName: "person")
                            .frame(width: 20)
                        TextField("Enter your fullname", text: $viewModel.fullname)
                            .focused($isFocus)
                    }
                    HStack {
                        Image(systemName: "key")
                            .frame(width: 20)
                        SecureField("Password must be 6-16 characters", text: $viewModel.password)
                            .focused($isFocus)
                    }
                }
                .authTextFieldModifier()

                AuthButton(
                    action: {
                        Task { try await viewModel.createUser() }
                    }, labelText: "Sign Up"
                )
                .disabled(viewModel.email.isEmpty || !(6 ... 16).contains(viewModel.password.count) || viewModel.fullname.isEmpty)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    AuthFooter(
                        description: "Already have an account ?",
                        pageName: "Log in"
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
