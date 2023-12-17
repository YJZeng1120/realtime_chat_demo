import SwiftUI

struct NewChatView: View {
    @StateObject private var viewModel = NewChatViewModel()
    @Binding var selectedUser: User?

    @FocusState var isFocus: Bool

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                SearchBar(text: $viewModel.searchText, hintText: "To: ")
                    .focused($isFocus)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                Text("Contacts")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .alignmentWidthLeading()
                    .padding()

                if viewModel.status == LoadStatus.inProgress {
                    ProgressView()
                        .scaleEffect(3)
                        .frame(height: UIScreen.main.bounds.height / 2, alignment: .center)
                } else {
                    NewChatUserList(
                        viewModel: viewModel,
                        selectedUser: $selectedUser
                    )
                }
            }
            .onTapGesture { isFocus = false }
            .background(Color.theme.backgroundColor)
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
