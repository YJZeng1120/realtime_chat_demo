import SwiftUI

struct InboxRowView: View {
    let message: Message

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AvatarImageView(user: message.user, size: .large)
            VStack(alignment: .leading, spacing: 4) {
                Text(message.user?.fullname ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if message.type == MessageType.text.rawValue {
                    Text(message.messageText)
                        .messageModifier()
                } else {
                    HStack {
                        Image(systemName: "photo")
                        Text("Send a photo")
                    }
                    .messageModifier()
                }
            }
            Spacer()
            Text(message.timestampFormatter)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

private struct MessageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.gray)
            .lineLimit(2)
    }
}

extension View {
    func messageModifier() -> some View {
        modifier(MessageModifier())
    }
}

// struct InboxRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        InboxRowView()
//    }
// }
