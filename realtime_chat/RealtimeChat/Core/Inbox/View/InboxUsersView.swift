
import SwiftUI

struct InboxUsersView: View {
    @ObservedObject var viewModel: InboxViewModel
    @Binding var selectedUser: User?

    var body: some View {
        List {
            SearchBar(text: $viewModel.searchText, hintText: "Search ")
                .listRowBackground(Color.clear)
            ForEach(viewModel.searchableUsers) { message in
                NavigationLink(value: message) {
                    InboxRowView(message: message)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }

        .listStyle(PlainListStyle())
        .frame(height: UIScreen.main.bounds.height - 120)
    }
}

// struct InboxUsersView_Previews: PreviewProvider {
//    static var previews: some View {
//        InboxUsersView()
//    }
// }
