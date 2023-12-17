import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()

    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var avatarImage: Image?

    @AppStorage("isDarkMode") private var isDark = false

    let user: User

    var body: some View {
        VStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            Button {
                                showImagePicker.toggle()
                            } label: {
                                if let avatarImage = avatarImage {
                                    avatarImage
                                        .resizable()
                                        .frame(width: 82, height: 82)
                                        .clipShape(Circle())
                                } else {
                                    AvatarImageView(user: user, size: .extraLarge)
                                }
                            }
                            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                                ImagePicker(selectedImage: $selectedImage)
                            }
                            Image(systemName: "camera.circle.fill")
                                .foregroundStyle(Color(.darkText), Color.theme.secondaryBackgroundColor)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text(user.fullname)
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(verbatim: user.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .alignmentWidthLeading()
                    .padding()

                    // Save Button
                    if let selectedImage = selectedImage {
                        Button {
                            viewModel.uploadAvatarImage(selectedImage)
                            self.selectedImage = nil
                        } label: {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }

                Section {
                    HStack {
                        Image(systemName: "gearshape.fill")
                        Text("Version")
                        Text("1.0.0")
                            .alignmentWidthTrailing()
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Image(systemName: "moon.circle.fill")
                        Text("Dark Mode")
                        Toggle("", isOn: $isDark)
                            .alignmentWidthTrailing()
                            .foregroundColor(.gray)
                    }
                }

                Section {
                    Button("Log Out") {
                        AuthService.shared.logOut()
                    }
                }
            }
        }
        .background(Color.theme.backgroundColor)
        .preferredColorScheme(isDark ? .dark : .light)
    }

    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        avatarImage = Image(uiImage: selectedImage)
    }
}

// struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
// }
