import Combine
import Firebase

class InboxViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var recentMessages = [Message]()
    @Published var searchText = ""

    @Published var status: LoadStatus = .initial

    private var cancellables = Set<AnyCancellable>()
    private let service = InboxService()

    init() {
        userInfoListener()
        service.fetchRecentMessage()
    }

    var searchableUsers: [Message] {
        if searchText.isEmpty {
            return recentMessages
        } else {
            let lowercasedQuery = searchText.lowercased()
            return recentMessages.filter {
                if let user = $0.user, user.fullname.lowercased().contains(lowercasedQuery) {
                    return true
                }
                return false
            }
        }
    }

    private func userInfoListener() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)

        service.$documentChanges.sink { [weak self] changes in
            self?.loadInitialMessages(fromChanges: changes)
        }.store(in: &cancellables)
    }

    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        status = LoadStatus.inProgress

        var latestMessages = changes.compactMap { try? $0.document.data(as: Message.self) }
        // 創建 DispatchGroup 來協調異步操作
        let dispatchGroup = DispatchGroup()

        for (index, latestMessage) in latestMessages.enumerated() {
            // 進入 DispatchGroup，表示異步操作開始
            dispatchGroup.enter()

            UserService.fetchUser(withUid: latestMessage.chatPartnerId) { user in
                latestMessages[index].user = user

                if let existingIndex = self.recentMessages.firstIndex(where: { $0.chatPartnerId == latestMessage.chatPartnerId }) {
                    self.recentMessages[existingIndex] = latestMessages[index]
                } else {
                    self.recentMessages.append(latestMessages[index])
                }

                // 離開 DispatchGroup，表示異步操作完成
                dispatchGroup.leave()
            }
        }

        // 等待所有異步操作完成
        dispatchGroup.notify(queue: .main) {
            //  排序recentMessages根據timestamp
            self.recentMessages.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            self.status = LoadStatus.succeed
        }
    }
}
