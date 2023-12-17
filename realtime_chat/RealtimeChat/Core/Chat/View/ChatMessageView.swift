import SwiftUI

struct ChatMessagesView: View {
    @ObservedObject var viewModel: ChatViewModel
    @Binding var isFirstScroll: Bool

    let user: User

    var body: some View {
        // 設定對話自動滾動到最下面
        ScrollViewReader { proxy in
            ScrollView {
                MessageListView(
                    viewModel: viewModel,
                    isFirstScroll: $isFirstScroll,
                    proxy: proxy,
                    user: user
                )

                if viewModel.loading {
                    LoadingIndicatorView(viewModel: viewModel)
                        .id("imageLoading")
                }
            }
        }
    }
}

private struct MessageListView: View {
    @ObservedObject var viewModel: ChatViewModel
    @Binding var isFirstScroll: Bool

    let proxy: ScrollViewProxy
    let user: User

    var body: some View {
        LazyVStack {
            ForEach(viewModel.messages) { message in
                ChatMessageBox(message: message, user: user)
                    .id(message)
            }
            .onChange(of: viewModel.messages) { _ in
                withAnimation(.easeIn(duration: 0.1)) {
                    proxy.scrollTo(viewModel.messages.last, anchor: .bottom)
                }
            }

            // 載入圖片
            .onChange(of: viewModel.loading) { _ in
                withAnimation(.easeIn(duration: 0.1)) {
                    if viewModel.loading {
                        proxy.scrollTo("imageLoading", anchor: .bottom)
                    }
                }
            }

            // 開始進畫面時不要有動畫
            .onAppear {
                if isFirstScroll {
                    proxy.scrollTo(viewModel.messages.last, anchor: .bottom)
                    isFirstScroll = false
                }
            }
        }
        .padding(.top)
    }
}

private struct LoadingIndicatorView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        ProgressView()
            .scaleEffect(2)
            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
            .alignmentWidthTrailing()
    }
}
