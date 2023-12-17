import SwiftUI

struct AuthFooter: View {
    let description: String
    let pageName: String
    var body: some View {
        HStack {
            Text(description)
            Text(pageName)
                .fontWeight(.semibold)
        }
        .font(.footnote)
    }
}

struct AuthFooter_Previews: PreviewProvider {
    static var previews: some View {
        AuthFooter(description: "Don't have an account ?", pageName: "Sign Up")
    }
}
