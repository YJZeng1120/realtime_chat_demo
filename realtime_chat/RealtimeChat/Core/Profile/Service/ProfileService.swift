import Firebase
import FirebaseStorage
import UIKit

// swiftformat:disable all
struct ProfileService {
    static func uploadImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }

        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/avatar_image/\(filename)")

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
    
    static func updateAvatarImage(userId: String, avatarImageUrl: String) {
            FirestoreConstants.UserCollection
                .document(userId)
                .updateData(["avatarImageUrl": avatarImageUrl])
            loadCurrentUserData()
        }
    

    private static func loadCurrentUserData() {
        Task {
            try await UserService.shared.fetchCurrentUser()
        }
    }
}
// swiftformat:enable all
