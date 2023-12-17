import Firebase
import FirebaseStorage
import UIKit

struct ChatService {
    let chatPartner: User

    func sendMessage(_ messageText: String, type: String) {
        guard let currentUid = FirebaseManager.shared.currentUid else {
            return
        }
        let chatPartnerId = chatPartner.id

        let sortedIds = [currentUid, chatPartnerId].sorted()
        let conversationId: String = sortedIds.joined()

        let conversationRef = FirestoreConstants.MessagesCollection.document(conversationId).collection("conversation").document()
        let recentConversationRef = FirestoreConstants.MessagesCollection.document(conversationId)

        let messageId = conversationRef.documentID

        let message = Message(
            messageId: messageId,
            fromId: currentUid,
            toId: chatPartnerId,
            messageText: messageText,
            type: type,
            timestamp: Timestamp()
        )

        let recentMessage = RecentMessage(
            messageId: messageId,
            conversationId: sortedIds,
            fromId: currentUid,
            toId: chatPartnerId,
            messageText: messageText,
            type: type,
            timestamp: Timestamp()
        )

        guard let messageData = try? Firestore.Encoder().encode(message) else {
            return
        }

        guard let recentMessageData = try? Firestore.Encoder().encode(recentMessage) else {
            return
        }

        conversationRef.setData(messageData)
        recentConversationRef.setData(recentMessageData)
    }

    func fetchMessages(completion: @escaping ([Message]) -> Void) {
        guard let currentUid = FirebaseManager.shared.currentUid else {
            return
        }

        let chatPartnerId = chatPartner.id

        let sortedIds = [currentUid, chatPartnerId].sorted()
        let conversationId = sortedIds.joined()

        let query =
            FirestoreConstants.MessagesCollection
                .document(conversationId)
                .collection("conversation")
                .order(by: "timestamp", descending: false)

        query.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error to fetch messages: \(error)")
                return
            }
            // filter只保留新增的變化
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added })
            else {
                return
            }

            var messages = changes.compactMap { try? $0.document.data(as: Message.self) }
            for (index, message) in messages.enumerated() where message.fromId != currentUid {
                messages[index].user = chatPartner
            }

            completion(messages)
        }
    }

    static func uploadImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }

        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/message_image/\(filename)")

        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Failed to upload image with error: \(error.localizedDescription)")
                return
            }

            ref.downloadURL { imageUrl, _ in
                guard let imageUrl = imageUrl?.absoluteString else {
                    return
                }
                completion(imageUrl)
            }
        }
    }
}
