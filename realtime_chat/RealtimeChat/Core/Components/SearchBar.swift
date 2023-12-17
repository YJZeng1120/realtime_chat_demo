import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    let hintText: String

    var body: some View {
        HStack {
            TextField(hintText, text: $text)
                .padding(.vertical, 12)
                .padding(.horizontal, 40)
                .background(Color(.systemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(.systemGray2))
                            .alignmentWidthLeading()
                            .padding()
                    }
                )
        }
    }
}

// struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(text: .constant(""))
//    }
// }
