// ContentView.swift

import SwiftUI
import WebKit
import AppKit

struct ContentView: View {
    @StateObject private var tabsModel = TabsModel()
    @State private var inputText: String = ""
    @State private var showSidebar: Bool = true
    @State private var sidebarWidth: CGFloat = 220
    @State private var bookmarks: [String] = UserDefaults.standard.stringArray(forKey: "Bookmarks") ?? []
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showBookmarkList: Bool = false
    @State private var showBookmarkModal: Bool = false
    @State private var bookmarkName: String = ""
    @State private var isFocused: Bool = false
    
    
    // Move webViews dictionary here
    @State private var webViews: [UUID: WKWebView] = [:] // Dictionary to hold webViews
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                    .edgesIgnoringSafeArea(.all)
                MainHStackView(
                    geometry: geometry,
                    showSidebar: $showSidebar,
                    sidebarWidth: $sidebarWidth,
                    tabsModel: tabsModel,
                    inputText: $inputText,
                    bookmarks: $bookmarks,
                    showBookmarkList: $showBookmarkList,
                    isFocused: $isFocused, generateThumbnail: generateThumbnail,
                    addTab: addTab,
                    closeTab: closeTab,
                    updateInputText: updateInputText,
                    loadCurrentTab: loadCurrentTab,
                    goBack: goBack,
                    goForward: goForward,
                    reloadPage: reloadPage,
                    loadURL: loadURL,
                    toggleSidebar: toggleSidebar,
                    webViews: $webViews // Pass the binding here
                )
                .edgesIgnoringSafeArea(.top)
                
                // Bookmark Modal
                if showBookmarkModal {
                    BookmarkModalView(
                        bookmarkName: $bookmarkName,
                        onSave: {
                            addBookmark(name: bookmarkName, url: urlString)
                            bookmarkName = ""
                            showBookmarkModal = false
                        },
                        onCancel: {
                            bookmarkName = ""
                            showBookmarkModal = false
                        }
                    )
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .onAppear {
                loadCurrentTab()
            }
            .onChange(of: tabsModel.tabs) { newTabs in
                if let encoded = try? JSONEncoder().encode(newTabs) {
                    UserDefaults.standard.set(encoded, forKey: "Tabs")
                }
            }
            .onChange(of: bookmarks) { newBookmarks in
                UserDefaults.standard.set(newBookmarks, forKey: "Bookmarks")
            }
        }
    }
    
    // MARK: - Helper Variables and Functions
    
    private var urlString: String {
        return self.currentTab()?.url ?? "about:blank"
    }
    
    private func addTab() {
        let newTab = BrowserTab(id: UUID(), title: "New Tab", url: "https://www.google.com", history: [])
        tabsModel.tabs.append(newTab)
        tabsModel.selectedTab = newTab.id
        inputText = ""
        loadCurrentTab()
    }
    
    private func closeTab(_ tabToClose: BrowserTab) {
        if let index = tabsModel.tabs.firstIndex(where: { $0.id == tabToClose.id }) {
            tabsModel.tabs.remove(at: index)
            if tabsModel.tabs.isEmpty {
                tabsModel.selectedTab = nil
                inputText = ""
            } else {
                if index < tabsModel.tabs.count {
                    tabsModel.selectedTab = tabsModel.tabs[index].id
                } else {
                    tabsModel.selectedTab = tabsModel.tabs.last?.id
                }
                updateInputText()
                loadCurrentTab()
            }
        }
    }
    
    private func loadCurrentTab() {
        // No need to load the webView here since it's managed in the view
        // Fetch favicon
        if let currentTab = currentTab() {
            fetchFavicon(for: currentTab.url) { image in
                DispatchQueue.main.async {
                    currentTab.favicon = image
                }
            }
            
            // Save to history
            if !currentTab.history.contains(currentTab.url) && currentTab.url != "about:blank" {
                currentTab.history.append(currentTab.url)
            }
        }
    }
    
    private func generateThumbnail(for tab: BrowserTab) {
        // Implement thumbnail generation if needed
    }
    
    private func currentTab() -> BrowserTab? {
        guard let selectedTab = tabsModel.selectedTab else { return nil }
        return tabsModel.tabs.first { $0.id == selectedTab }
    }
    
    private func updateInputText() {
        if let currentTab = currentTab(), currentTab.url != "about:blank" {
            inputText = currentTab.title
        } else {
            inputText = ""
        }
    }
    
    // MARK: - Fetch Favicon
    
    private func fetchFavicon(for urlString: String, completion: @escaping (NSImage?) -> Void) {
        guard let url = URL(string: urlString),
              let host = url.host else {
            completion(nil)
            return
        }
        let faviconURLString = "https://www.google.com/s2/favicons?domain=\(host)&sz=64"
        guard let faviconURL = URL(string: faviconURLString) else {
            completion(nil)
            return
        }
        
        // Check if favicon is already cached
        if let cachedImage = FaviconCache.shared.image(for: faviconURL) {
            completion(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: faviconURL) { data, response, error in
            if let data = data, let image = NSImage(data: data) {
                FaviconCache.shared.cache(image: image, for: faviconURL)
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - Sidebar Toggle
    
    private func toggleSidebar() {
        withAnimation {
            showSidebar.toggle()
        }
    }
    
    // MARK: - Bookmark Functions
    
    private func addBookmark(name: String, url: String) {
        let newBookmark = name.isEmpty ? url : name
        if !bookmarks.contains(newBookmark) && url != "about:blank" {
            bookmarks.append(newBookmark)
        }
    }
    
    // MARK: - Navigation Functions
    
    private func goBack() {
        if let currentTab = currentTab(), let webView = webViews[currentTab.id], webView.canGoBack {
            webView.goBack()
        }
    }
    
    private func goForward() {
        if let currentTab = currentTab(), let webView = webViews[currentTab.id], webView.canGoForward {
            webView.goForward()
        }
    }
    
    private func reloadPage() {
        if let currentTab = currentTab(), let webView = webViews[currentTab.id] {
            webView.reload()
        }
    }
    
    private func loadURL() {
        guard !inputText.isEmpty else { return }
        
        if tabsModel.selectedTab == nil {
            addTab()
        }
        
        guard let currentTab = currentTab(), let webView = webViews[currentTab.id] else { return }
        
        var formattedURLString = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !formattedURLString.hasPrefix("http://") && !formattedURLString.hasPrefix("https://") {
            if formattedURLString.contains(" ") || !formattedURLString.contains(".") {
                formattedURLString = "https://www.google.com/search?q=\(formattedURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            } else {
                formattedURLString = "https://" + formattedURLString
            }
        }
        
        if let validURL = URL(string: formattedURLString) {
            currentTab.url = validURL.absoluteString
            // webView.load(URLRequest(url: validURL)) // Remove this line
            // The WebViewContainer observes tab.url and will load the URL immediately
        } else {
            alertMessage = "The URL you entered is invalid. Please check and try again."
            showAlert = true
        }
    }
}
