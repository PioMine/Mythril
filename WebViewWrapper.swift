// WebViewWrapper.swift

import SwiftUI
import WebKit

class WebViewWrapper: ObservableObject {
    let webView: WKWebView

    init() {
        let webConfiguration = WKWebViewConfiguration()

        if #available(macOS 11.0, *) {
            let preferences = WKWebpagePreferences()
            preferences.allowsContentJavaScript = true
            webConfiguration.defaultWebpagePreferences = preferences
        } else {
            webConfiguration.preferences.javaScriptEnabled = true
        }

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        
        // Set custom user agent
        let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " +
                        "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15"
        webView.customUserAgent = userAgent
    }
}
