import SwiftUI

enum AvatarImageSize {
    case extraSmall
    case small
    case medium
    case large
    case extraLarge

    var dimension: CGFloat {
        switch self {
        case .extraSmall: return 30
        case .small: return 36
        case .medium: return 56
        case .large: return 64
        case .extraLarge: return 82
        }
    }
}
