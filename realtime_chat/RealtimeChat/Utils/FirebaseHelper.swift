import Firebase

enum FirestoreConstants {
    static let UserCollection = FirebaseManager.shared.firestore.collection("users")
    static let MessagesCollection = FirebaseManager.shared.firestore.collection("messages")
}

class FirebaseManager: NSObject {
    let auth: Auth
    let firestore: Firestore

    static let shared = FirebaseManager()

    override init() {
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()

        super.init()
    }
}

extension FirebaseManager {
    var currentUid: String? {
        return auth.currentUser?.uid
    }
}
