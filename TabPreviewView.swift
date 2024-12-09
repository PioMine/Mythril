import SwiftUI
import WebKit

struct TabPreviewView: View {
    @ObservedObject var tab: BrowserTab

    @StateObject private var webViewWrapper = WebViewWrapper()

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            WebViewRepresentable(
                webView: webViewWrapper.webView,
                webViewStateModel: tab.webViewStateModel,
                updateTabTitle: { title in
                    tab.title = title ?? "New Tab"
                },
                updateTabURL: { url in
                    tab.url = url ?? "about:blank"
                }
            )
            .frame(width: 300, height: 200)
            .cornerRadius(8)
            .onAppear {
                if let url = URL(string: tab.url) {
                    webViewWrapper.webView.load(URLRequest(url: url))
                }
            }

            Text(tab.title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Design.textColor)
                .padding(.top, 5)
        }
        .padding()
        .background(Design.topBarBackground)
        .cornerRadius(10)
    }
}
