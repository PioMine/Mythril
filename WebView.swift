// WebView.swift

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let webView: WKWebView
    @ObservedObject var webViewStateModel: WebViewStateModel
    var updateTabTitle: (String?) -> Void
    var updateTabURL: (String?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // Update the webView's content if needed
        // Since we're passing the webView instance, this may not be necessary
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.webViewStateModel.canGoBack = webView.canGoBack
            parent.webViewStateModel.canGoForward = webView.canGoForward
            parent.updateTabTitle(webView.title)
            parent.updateTabURL(webView.url?.absoluteString)
            parent.webViewStateModel.pageURL = webView.url?.absoluteString
            parent.webViewStateModel.pageTitle = webView.title
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.webViewStateModel.canGoBack = webView.canGoBack
            parent.webViewStateModel.canGoForward = webView.canGoForward
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.webViewStateModel.canGoBack = webView.canGoBack
            parent.webViewStateModel.canGoForward = webView.canGoForward
            parent.updateTabTitle(webView.title)
            parent.updateTabURL(webView.url?.absoluteString)
            parent.webViewStateModel.pageURL = webView.url?.absoluteString
            parent.webViewStateModel.pageTitle = webView.title
        }
    }
}
