import Firebase
import FirebaseFirestoreSwift
struct Message: Identifiable, Codable, Hashable {
    @DocumentID var messageId: String?
    let fromId: String
    let toId: String
    let messageText: String
    let type: String
    let timestamp: Timestamp

    var user: User?

    var id: String {
        return messageId ?? NSUUID().uuidString
    }

    var chatPartnerId: String {
        return fromId == FirebaseManager.shared.currentUid ? toId : fromId
    }

    var isFromCurrentUser: Bool {
        return fromId == FirebaseManager.shared.currentUid
    }

    var timestampFormatter: String {
        return timestamp.dateValue().timestampString()
    }

    var timestampChatFormatter: String {
        return timestamp.dateValue().timestampChatString()
    }
}

struct RecentMessage: Codable, Hashable {
    @DocumentID var messageId: String?
    let conversationId: [String]
    let fromId: String
    let toId: String
    let messageText: String
    let type: String
    let timestamp: Timestamp

    var user: User?
}
