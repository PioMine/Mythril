import SwiftUI
import WebKit

struct WebContentView: View {
    @ObservedObject var tabsModel: TabsModel
    var generateThumbnail: (BrowserTab) -> Void
    @Binding var webViews: [UUID: WKWebView]
    @State private var isAnimating: Bool = false

    var body: some View {
        ZStack {
            ForEach(tabsModel.tabs) { tab in
                WebViewContainer(
                    tab: tab,
                    generateThumbnail: generateThumbnail,
                    webViewDidLoad: { webView in
                        webViews[tab.id] = webView
                    }
                )
                .opacity(tabsModel.selectedTab == tab.id ? 1 : 0)
                .allowsHitTesting(tabsModel.selectedTab == tab.id)
                .ignoresSafeArea()
            }

            if isAnimating {
                Color.white
                    .opacity(0.0)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .onChange(of: tabsModel.selectedTab) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        }
    }
}
