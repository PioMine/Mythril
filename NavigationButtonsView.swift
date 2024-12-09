// NavigationButtonsView.swift

import SwiftUI
import WebKit

struct NavigationButtonsView: View {
    var webView: WKWebView? // Accept the webView
    var goBack: () -> Void
    var goForward: () -> Void
    var reloadPage: () -> Void

    @State private var isHovering: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            RippleButton(action: goBack) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 14))
                    .foregroundColor((webView?.canGoBack ?? false) ? Design.accentColor : Design.iconColor.opacity(0.5))
            }
            .disabled(!(webView?.canGoBack ?? false))
            .scaleEffect((webView?.canGoBack ?? false) ? 1.0 : 0.95)
            .animation(.easeInOut(duration: 0.2), value: webView?.canGoBack)

            RippleButton(action: goForward) {
                Image(systemName: "chevron.forward")
                    .font(.system(size: 14))
                    .foregroundColor((webView?.canGoForward ?? false) ? Design.accentColor : Design.iconColor.opacity(0.5))
            }
            .disabled(!(webView?.canGoForward ?? false))
            .scaleEffect((webView?.canGoForward ?? false) ? 1.0 : 0.95)
            .animation(.easeInOut(duration: 0.2), value: webView?.canGoForward)

            RippleButton(action: reloadPage) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 14))
                    .foregroundColor(Design.iconColor)
            }
            .scaleEffect(1.0)
        }
        .padding(6)
        .background(isHovering ? Design.hoverGlowColor : Color.clear)
        .cornerRadius(8)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
        .shadow(color: isHovering ? Design.shadowLight : Color.clear, radius: isHovering ? 4 : 0, x: 0, y: 0)
    }
}
