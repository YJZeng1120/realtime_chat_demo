enum MessageType: String, Equatable {
    case text
    case image

    var type: String {
        switch self {
        case .text: return "text"
        case .image: return "image"
        }
    }
}
