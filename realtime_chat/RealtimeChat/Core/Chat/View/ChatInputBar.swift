import SwiftUI

struct ChatInputBar: View {
    @ObservedObject var viewModel: ChatViewModel
    @Binding var showImagePicker: Bool
    @Binding var selectedImage: UIImage?
    @Binding var sendImage: Image?

    var loadImage: () -> Void

    var body: some View {
        HStack(alignment: .bottom) {
            PhotoButton(
                showImagePicker: $showImagePicker,
                selectedImage: $selectedImage,
                loadImage: loadImage
            )

            // TextField or Image
            MessageInputContent(
                sendImage: $sendImage,
                selectedImage: $selectedImage,
                messageText: $viewModel.messageText
            )

            SendButton(
                viewModel: viewModel,
                sendImage: $sendImage,
                selectedImage: $selectedImage,
                sendMessage: { viewModel.sendMessage() }
            )
        }
    }
}

private struct PhotoButton: View {
    @Binding var showImagePicker: Bool
    @Binding var selectedImage: UIImage?
    var loadImage: () -> Void

    var body: some View {
        Button {
            showImagePicker.toggle()
        } label: {
            Image(systemName: "photo.fill.on.rectangle.fill")
                .font(.title2)
                .foregroundColor(Color.primary.opacity(0.8))
        }
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

private struct MessageInputContent: View {
    @Binding var sendImage: Image?
    @Binding var selectedImage: UIImage?
    @Binding var messageText: String

    var body: some View {
        if let sendImage = sendImage {
            ZStack(alignment: .topTrailing) {
                sendImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 3,
                           height: UIScreen.main.bounds.width / 3)
                    .aspectRatio(contentMode: .fit)

                Button {
                    self.sendImage = nil
                    self.selectedImage = nil
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundStyle(.black, Color(.systemGray))
                }
            }
            .frame(maxWidth: .infinity)
        } else {
            TextField("Aa", text: $messageText, axis: .vertical)
                .font(.callout)
                .fontWeight(.semibold)
        }
    }
}

private struct SendButton: View {
    @ObservedObject var viewModel: ChatViewModel
    @Binding var sendImage: Image?
    @Binding var selectedImage: UIImage?
    var sendMessage: () -> Void

    var body: some View {
        Button {
            let messageType = sendImage == nil ? MessageType.text.rawValue : MessageType.image.rawValue
            viewModel.type = messageType

            if let selectedImage = selectedImage {
                viewModel.uploadMessageImage(selectedImage)
            } else {
                sendMessage()
            }
            viewModel.messageText = ""
            self.sendImage = nil
            self.selectedImage = nil
        } label: {
            Image(systemName: "paperplane.fill")
                .font(.title2)
        }
    }
}

// struct ChatInputBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatInputBar()
//    }
// }
