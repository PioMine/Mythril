// TabsModel.swift

import SwiftUI

class TabsModel: ObservableObject {
    @Published var tabs: [BrowserTab]
    @Published var selectedTab: UUID?

    init() {
        // Attempt to load saved tabs from UserDefaults
        if let savedTabsData = UserDefaults.standard.data(forKey: "Tabs"),
           let savedTabs = try? JSONDecoder().decode([BrowserTab].self, from: savedTabsData) {
            self.tabs = savedTabs
            self.selectedTab = savedTabs.first?.id
        } else {
            let initialTab = BrowserTab(id: UUID(), title: "Home", url: "https://www.apple.com", history: [])
            self.tabs = [initialTab]
            self.selectedTab = initialTab.id
        }
    }
}
