import Kingfisher
import SwiftUI

struct ChatBubble: View {
    let message: Message
    let isCurrentUser: Bool

    var body: some View {
        if message.type == MessageType.text.rawValue {
            VStack(alignment: isCurrentUser ? .trailing : .leading) {
                Text(message.messageText)
                    .font(.callout)
                    .chatBubbleStyle(isCurrentUser: isCurrentUser)
                Text(message.timestampChatFormatter)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .alignmentChatModifier(isCurrentUser: isCurrentUser)

        } else {
            VStack(alignment: isCurrentUser ? .trailing : .leading) {
                KFImage(URL(string: message.messageText))
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .frame(width: UIScreen.main.bounds.width / 2.4)
                    .aspectRatio(contentMode: .fit) // 保持原始寬高比例
                Text(message.timestampChatFormatter)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .alignmentChatModifier(isCurrentUser: isCurrentUser)
        }
    }
}

private struct ChatBubbleModifier: ViewModifier {
    let isCurrentUser: Bool
    let arrowOffset: CGFloat = 13
    let arrowRotation: Double = 115

    func body(content: Content) -> some View {
        content
            .padding()
            .background(isCurrentUser ? Color.accentColor : Color.theme.secondaryBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(alignment: isCurrentUser ? .topTrailing : .topLeading) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title2)
                    .rotationEffect(.degrees(isCurrentUser ? -arrowRotation : arrowRotation))
                    .offset(x: isCurrentUser ? arrowOffset : -arrowOffset, y: 5)
                    .foregroundColor(
                        isCurrentUser ? Color.accentColor : Color.theme.secondaryBackgroundColor)
            }
            .frame(
                maxWidth: UIScreen.main.bounds.width / (isCurrentUser ? 1.55 : 1.7),
                alignment: isCurrentUser ? .trailing : .leading
            ) // 設定對話框最大寬度
    }
}

extension View {
    func chatBubbleStyle(isCurrentUser: Bool) -> some View {
        modifier(ChatBubbleModifier(isCurrentUser: isCurrentUser))
    }
}

private struct AlignmentChatModifier: ViewModifier {
    let isCurrentUser: Bool

    func body(content: Content) -> some View {
        content
            .frame(
                maxWidth: .infinity,
                alignment: isCurrentUser ? .trailing : .leading
            ) // 設定對話框對齊位置與方向
    }
}

extension View {
    func alignmentChatModifier(isCurrentUser: Bool) -> some View {
        modifier(AlignmentChatModifier(isCurrentUser: isCurrentUser))
    }
}

// struct ChatBubble_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatBubble(message: "This is a test message", isCurrentUser: true)
//    }
// }
