import SwiftUI

struct AuthTitle: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding()
            .alignmentWidthLeading()
    }
}

struct AuthTitle_Previews: PreviewProvider {
    static var previews: some View {
        AuthTitle(title: "Hello \nWelcome Back !")
    }
}
