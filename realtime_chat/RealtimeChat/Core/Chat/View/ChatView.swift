import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    @State var isFirstScroll = true

    @State private var showImagePicker = false
    @State private var isImageLoaded = false
    @State private var selectedImage: UIImage?
    @State private var sendImage: Image?

    let user: User

    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }

    var body: some View {
        VStack(alignment: .leading) {
            ChatMessagesView(
                viewModel: viewModel,
                isFirstScroll: $isFirstScroll,
                user: user
            )
            Spacer()
            ChatInputBar(
                viewModel: viewModel,
                showImagePicker: $showImagePicker,
                selectedImage: $selectedImage,
                sendImage: $sendImage,
                loadImage: loadImage
            )
            .padding(14)
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color.theme.backgroundColor)
        .navigationTitle(user.fullname)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar) // 讓ToolBar一直顯示
    }

    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        isImageLoaded = true
        sendImage = Image(uiImage: selectedImage)
    }
}

// struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
// }
