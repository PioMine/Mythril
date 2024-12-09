// MainHStackView.swift

import SwiftUI
import WebKit

struct MainHStackView: View {
    var geometry: GeometryProxy
    @Binding var showSidebar: Bool
    @Binding var sidebarWidth: CGFloat
    @ObservedObject var tabsModel: TabsModel
    @Binding var inputText: String
    @Binding var bookmarks: [String]
    @Binding var showBookmarkList: Bool
    @Binding var isFocused: Bool
    
    var generateThumbnail: (BrowserTab) -> Void
    var addTab: () -> Void
    var closeTab: (BrowserTab) -> Void
    var updateInputText: () -> Void
    var loadCurrentTab: () -> Void
    var goBack: () -> Void // Use passed-in functions
    var goForward: () -> Void
    var reloadPage: () -> Void
    var loadURL: () -> Void
    var toggleSidebar: () -> Void
    @Binding var webViews: [UUID: WKWebView] // Receive webViews binding
    
    
    
    var body: some View {
        HStack(spacing: 0) {
            if showSidebar {
                SidebarView(
                    tabsModel: tabsModel,
                    addTab: addTab,
                    closeTab: closeTab,
                    updateInputText: updateInputText,
                    loadCurrentTab: loadCurrentTab,
                    sidebarWidth: $sidebarWidth,
                    bookmarks: $bookmarks,
                    showBookmarkList: $showBookmarkList,
                    isSearchBarFocused: { isFocused }
                    
                )
                .frame(width: sidebarWidth)
                .transition(.move(edge: .leading).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: showSidebar)
            }

            VStack(spacing: 0) {
                if let currentTab = currentTab() {
                    TopBarView(
                        inputText: $inputText,
                        tab: currentTab,
                        webView: webViews[currentTab.id],
                        goBack: goBack,
                        goForward: goForward,
                        reloadPage: reloadPage,
                        addTab: addTab,
                        updateInputText: updateInputText,
                        loadURL: loadURL,
                        toggleSidebar: toggleSidebar,
                        bookmarks: $bookmarks,
                        windowWidth: geometry.size.width,
                        showBookmarkList: $showBookmarkList,
                        isSidebarVisible: $showSidebar // Add this line
                    )
                    
                    .frame(height: 40)
                    .background(Design.topBarBackground)
                    .shadow(color: Design.shadowLight, radius: 4, x: 0, y: 2)

                    WebContentView(
                        tabsModel: tabsModel,
                        generateThumbnail: generateThumbnail,
                        webViews: $webViews // Pass webViews binding
                    )
                    .frame(width: geometry.size.width - (showSidebar ? sidebarWidth : 0))
                    .background(Design.backgroundColor)
                } else {
                    HomeView()
                }
            }
        }
    }

    private func currentTab() -> BrowserTab? {
        guard let selectedTab = tabsModel.selectedTab else { return nil }
        return tabsModel.tabs.first { $0.id == selectedTab }
    }
}
