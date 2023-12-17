import Kingfisher
import SwiftUI

struct AvatarImageView: View {
    var user: User?
    let size: AvatarImageSize

    var body: some View {
        if let imageUrl = user?.avatarImageUrl {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .foregroundColor(Color(.systemGray4))
                .overlay(
                    RoundedRectangle(cornerRadius: 60)
                        .stroke(Color.primary.opacity(0.6), lineWidth: 1))
        }
    }
}

// struct AvatarImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        AvatarImageView()
//    }
// }
