import Firebase

@MainActor
class NewChatViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var searchText = ""

    @Published var status: LoadStatus = .initial

    var searchableUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            let lowercasedQuery = searchText.lowercased()
            return users.filter { $0.fullname.lowercased().contains(lowercasedQuery) }
        }
    }

    init() {
        Task {
            try await self.fetchUsers()
        }
    }

    func fetchUsers() async throws {
        status = LoadStatus.inProgress

        guard let currentUid = FirebaseManager.shared.currentUid else {
            return
        }
        let users = try await UserService.fetchAllUsers()
        self.users = users.filter { $0.id != currentUid }.sorted { $0.fullname < $1.fullname }

        status = LoadStatus.succeed
    }
}
