import SwiftUI

struct ChatMessageBox: View {
    let message: Message
    let user: User

    private var isFromCurrentUser: Bool {
        return message.isFromCurrentUser
    }

    var body: some View {
        HStack(
            alignment: .top,
            spacing: isFromCurrentUser ? 0 : 16
        ) {
            if !isFromCurrentUser {
                AvatarImageView(user: user, size: .extraSmall)
            }
            ChatBubble(
                message: message,
                isCurrentUser: isFromCurrentUser
            )
        }
        .padding(.vertical, 3)
        .padding(.horizontal, isFromCurrentUser ? 20 : 10)
    }
}

// struct ChatMessageBox_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatMessageBox(isCurrentUser: true)
//    }
// }
