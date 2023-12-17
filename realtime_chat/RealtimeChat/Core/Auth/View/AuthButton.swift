import SwiftUI

struct AuthButton: View {
    let action: () -> Void
    let labelText: String

    var body: some View {
        Button(action: action) {
            Text(labelText)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .padding()
        .padding(.vertical)
    }
}
