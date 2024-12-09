import SwiftUI
import WebKit

struct WebViewContainer: View {
    @ObservedObject var tab: BrowserTab
    var generateThumbnail: (BrowserTab) -> Void
    var webViewDidLoad: (WKWebView) -> Void // Closure to pass back the WKWebView

    @StateObject private var webViewWrapper = WebViewWrapper()

    var body: some View {
        WebViewRepresentable(
            webView: webViewWrapper.webView,
            webViewStateModel: tab.webViewStateModel,
            updateTabTitle: { title in
                tab.title = title ?? "New Tab"
                generateThumbnail(tab)
            },
            updateTabURL: { url in
                tab.url = url ?? "about:blank"
            }
        )
        .onAppear {
            webViewDidLoad(webViewWrapper.webView)
            loadURL()
        }
        .onChange(of: tab.url) { newURL in
            loadURL()
        }
    }

    private func loadURL() {
        guard let url = URL(string: tab.url) else { return }
        webViewWrapper.webView.load(URLRequest(url: url))
    }
}
