// TabDropDelegate.swift

import SwiftUI

struct TabDropDelegate: DropDelegate {
    let currentTab: BrowserTab
    @ObservedObject var tabsModel: TabsModel
    
    func performDrop(info: DropInfo) -> Bool {
        guard let item = info.itemProviders(for: [.text]).first else { return false }
        item.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
            if let data = data as? Data,
               let idString = String(data: data, encoding: .utf8),
               let draggedID = UUID(uuidString: idString) {
                DispatchQueue.main.async {
                    if let fromIndex = tabsModel.tabs.firstIndex(where: { $0.id == draggedID }),
                       let toIndex = tabsModel.tabs.firstIndex(where: { $0.id == currentTab.id }),
                       fromIndex != toIndex {
                        withAnimation(.easeInOut) {
                            let movedTab = tabsModel.tabs.remove(at: fromIndex)
                            tabsModel.tabs.insert(movedTab, at: toIndex)
                            tabsModel.selectedTab = movedTab.id
                        }
                    }
                }
            }
        }
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let item = info.itemProviders(for: [.text]).first else { return }
        item.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
            if let data = data as? Data,
               let idString = String(data: data, encoding: .utf8),
               let draggedID = UUID(uuidString: idString),
               let fromIndex = tabsModel.tabs.firstIndex(where: { $0.id == draggedID }),
               let toIndex = tabsModel.tabs.firstIndex(where: { $0.id == currentTab.id }),
               fromIndex != toIndex {
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        let movedTab = tabsModel.tabs.remove(at: fromIndex)
                        tabsModel.tabs.insert(movedTab, at: toIndex)
                        tabsModel.selectedTab = movedTab.id
                    }
                }
            }
        }
    }
}
