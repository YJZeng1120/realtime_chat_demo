import SwiftUI

struct InboxView: View {
    @State private var showNewMessageView = false
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var isChat = false

    private var user: User? {
        return
            viewModel.currentUser
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                Divider()
                if viewModel.status == LoadStatus.inProgress {
                    ProgressView()
                        .scaleEffect(3)
                        .frame(height: UIScreen.main.bounds.height / 2, alignment: .center)
                } else {
                    InboxUsersView(
                        viewModel: viewModel,
                        selectedUser: $selectedUser
                    )
                }
            }

            .background(Color.theme.backgroundColor)
            .onChange(of: selectedUser, perform: { newValue in
                isChat = newValue != nil
            })
            .navigationDestination(for: Message.self, destination: { message in
                if let user = message.user {
                    ChatView(user: user)
                }
            })
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .navigationDestination(isPresented: $isChat, destination: {
                if let user = selectedUser {
                    ChatView(user: user)
                }
            })
            .fullScreenCover(isPresented: $showNewMessageView, content: {
                NewChatView(selectedUser: $selectedUser)
            })

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationLink(value: user) {
                            ZStack(alignment: .bottomTrailing) {
                                AvatarImageView(user: user, size: .small)

                                Image(systemName: "gearshape.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.black, Color.theme.secondaryBackgroundColor)
                            }
                        }

                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewMessageView.toggle()
                        selectedUser = nil
                    } label: {
                        ZStack(alignment: .bottom) {
                            Image(systemName: "person.2.fill")
                                .resizable()
                                .foregroundColor(Color.primary.opacity(0.9))
                            Image(systemName: "ellipsis.rectangle.fill")
                                .font(.system(size: 11))
                                .foregroundStyle(.black, Color.theme.secondaryBackgroundColor)
                        }
                    }
                }
            }
        }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
