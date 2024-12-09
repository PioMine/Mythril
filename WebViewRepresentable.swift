// WebViewRepresentable.swift

import SwiftUI
import WebKit

struct WebViewRepresentable: NSViewRepresentable {
    let webView: WKWebView
    @ObservedObject var webViewStateModel: WebViewStateModel
    var updateTabTitle: (String?) -> Void
    var updateTabURL: (String?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> WKWebView {
        if webView.navigationDelegate == nil {
            webView.navigationDelegate = context.coordinator
            webView.uiDelegate = context.coordinator
        }
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // Do nothing to prevent reloading
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebViewRepresentable

        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.webViewStateModel.canGoBack = webView.canGoBack
            parent.webViewStateModel.canGoForward = webView.canGoForward
            parent.updateTabTitle(webView.title)
            parent.updateTabURL(webView.url?.absoluteString)
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
        }
    }
}
