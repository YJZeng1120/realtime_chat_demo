import FirebaseFirestoreSwift
import Foundation

struct User: Codable, Identifiable, Hashable {
    @DocumentID var uid: String?
    let fullname: String
    let email: String
    var avatarImageUrl: String?

    var id: String {
        return uid ?? NSUUID().uuidString
    }
}
