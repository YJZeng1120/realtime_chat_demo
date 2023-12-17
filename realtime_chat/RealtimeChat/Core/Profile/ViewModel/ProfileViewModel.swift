import Firebase
import SwiftUI

class ProfileViewModel: ObservableObject {
    func uploadAvatarImage(_ image: UIImage) {
        guard let currentUid = FirebaseManager.shared.currentUid else {
            return
        }

        ProfileService.uploadImage(image: image) { avatarImageUrl in
            ProfileService.updateAvatarImage(
                userId: currentUid,
                avatarImageUrl: avatarImageUrl
            )
        }
    }
}
