import SwiftUI

private struct AuthTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .foregroundColor(.gray)
            )
            .padding(.bottom, -20)
            .padding()
    }
}

extension View {
    func authTextFieldModifier() -> some View {
        modifier(AuthTextFieldModifier())
    }
}
