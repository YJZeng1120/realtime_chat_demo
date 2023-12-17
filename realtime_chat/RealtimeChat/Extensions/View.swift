import SwiftUI

extension View {
    func alignmentWidthLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }

    func alignmentWidthTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
}
