import SwiftUI

struct NewChatUserList: View {
    @ObservedObject var viewModel: NewChatViewModel
    @Binding var selectedUser: User?

    @Environment(\.dismiss) var dismiss

    var body: some View {
        LazyVStack {
            ForEach(viewModel.searchableUsers, id: \.self) {
                user in VStack {
                    HStack {
                        AvatarImageView(user: user, size: .medium)
                        Text(user.fullname)
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    .padding(.horizontal)
                    Divider()
                }.onTapGesture {
                    selectedUser = user
                    dismiss()
                }
            }
        }
    }
}

// struct NewChatUserList_Previews: PreviewProvider {
//    static var previews: some View {
//        NewChatUserList()
//    }
// }
