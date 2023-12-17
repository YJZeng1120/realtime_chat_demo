import Firebase
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messageText = ""

    @Published var type = ""
    @Published var messages = [Message]()

    @Published var loading = false

    let service: ChatService
    var shouldExecuteOtherActions = false

    @Published var messageImageUrl = "" {
        didSet {
            // 當 messageImageUrl 的值發生變化時執行
            if !messageImageUrl.isEmpty && shouldExecuteOtherActions {
                executeOtherActions()
                shouldExecuteOtherActions = false
            }
        }
    }

    init(user: User) {
        self.service = ChatService(chatPartner: user)
        fetchMessages()
    }

    func fetchMessages() {
        service.fetchMessages { messages in
            self.messages.append(contentsOf: messages)
        }
    }

    func sendMessage() {
        service.sendMessage(messageText, type: type)
    }

    func sendImageMessage() {
        service.sendMessage(messageImageUrl, type: type)
    }

    func uploadMessageImage(_ image: UIImage) {
        loading = true
        ChatService.uploadImage(image: image) { messageImageUrl in
            self.shouldExecuteOtherActions = true
            // 更新 messageImageUrl 的值，觸發 didSet
            self.messageImageUrl = messageImageUrl
        }
    }

    private func executeOtherActions() {
        loading = false
        sendImageMessage()
        print("Other actions executed. Message Text: \(messageImageUrl)")
    }
}
