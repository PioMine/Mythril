import SwiftUI
import WebKit

struct TopBarView: View {
    @Binding var inputText: String
    @ObservedObject var tab: BrowserTab
    var webView: WKWebView?
    var goBack: () -> Void
    var goForward: () -> Void
    var reloadPage: () -> Void
    var addTab: () -> Void
    var updateInputText: () -> Void
    var loadURL: () -> Void
    var toggleSidebar: () -> Void
    @Binding var bookmarks: [String]
    var windowWidth: CGFloat
    @Binding var showBookmarkList: Bool
    @Binding var isSidebarVisible: Bool

    @State private var isSearchFocused: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Unified Background for Top Bar and Sidebar
            Design.topBarBackground
                .edgesIgnoringSafeArea(.all) // Extend background to cover both top bar and sidebar

            HStack(spacing: 10) {
                // Sidebar Toggle Button
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        toggleSidebar()
                    }
                }) {
                    Image(systemName: "sidebar.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .rotationEffect(rotationEffect)
                        .scaleEffect(isSidebarVisible ? 1 : 1.05)
                        .opacity(isSidebarVisible ? 1 : 0.9)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isSidebarVisible)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, isSidebarVisible ? 10 : 60)

                Spacer()

                // Search Bar
                SearchBarView(
                    inputText: $inputText,
                    updateInputText: updateInputText,
                    loadURL: loadURL,
                    currentTabTitle: tab.title,
                    currentTabURL: tab.url,
                    isFocused: $isSearchFocused
                )
                .frame(width: windowWidth / 2)
                .padding(.vertical, 6)

                Spacer()

                // Navigation Buttons
                NavigationButtonsView(
                    webView: webView,
                    goBack: goBack,
                    goForward: goForward,
                    reloadPage: reloadPage
                )
                .padding(.trailing, 10)

                // Bookmark Button with Popover
                BookmarkButton(
                    bookmarks: $bookmarks,
                    showBookmarkList: $showBookmarkList,
                    currentTabURL: tab.url,
                    inputText: $inputText,
                    loadURL: loadURL
                )
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 40)
        .shadow(color: Design.shadowLight, radius: 4, x: 0, y: 2)
    }

    // Computed Property for Sidebar Rotation Effect
    private var rotationEffect: Angle {
        isSidebarVisible ? .degrees(0) : .degrees(180)
    }
}
