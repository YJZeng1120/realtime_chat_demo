import Firebase
import FirebaseStorage

class InboxService {
    @Published var documentChanges = [DocumentChange]()

    func fetchRecentMessage() {
        guard let currentUid = FirebaseManager.shared.currentUid else {
            return
        }

        // 比對MessagesCollection中有哪些文件的conversationId有currentUid
        let query =
            FirestoreConstants.MessagesCollection
                .whereField("conversationId", arrayContains: currentUid)

        query.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error to fetch recent messages: \(error)")
                return
            }

            // 只保留新增或修改的變化
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added || $0.type == .modified }) else {
                return
            }

            self.documentChanges = changes
        }
    }
}
