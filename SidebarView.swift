// SidebarView.swift

import SwiftUI

struct SidebarView: View {
    @ObservedObject var tabsModel: TabsModel
    var addTab: () -> Void
    var closeTab: (BrowserTab) -> Void
    var updateInputText: () -> Void
    var loadCurrentTab: () -> Void
    @Binding var sidebarWidth: CGFloat
    @Binding var bookmarks: [String]
    @Binding var showBookmarkList: Bool
    var isSearchBarFocused: () -> Bool

    @State private var clearText: String = "Clear"
    @State private var showClearIcon: Bool = false
    @State private var arrowPressed: Bool = false
    @State private var hoverShadow: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            if sidebarWidth > 0 {
                VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Design.gradientStart, Design.gradientEnd]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.2)
                    )
                    .cornerRadius(10)
                    .shadow(color: Design.shadowDeep, radius: 10, x: 0, y: 0)
            }

            VStack(spacing: 0) {
                Spacer().frame(height: 10)

                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray.opacity(0.5))
                        .padding(.leading, 0)

                    Spacer()

                    // 'Clear' Button with Animated Appearance
                    if showClearIcon && !tabsModel.tabs.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.down")
                                .foregroundColor(Color.gray.opacity(0.8))
                                .offset(y: arrowPressed ? 3 : 0)
                                .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: arrowPressed)

                            Text(clearText)
                                .foregroundColor(Color.gray.opacity(0.8))
                                .font(.system(size: 12, weight: .medium))
                        }
                        .padding(.trailing, 10)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                tabsModel.tabs.removeAll()
                                showClearIcon = false
                            }
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in arrowPressed = true }
                                .onEnded { _ in arrowPressed = false }
                        )
                        .transition(.opacity) // Define the transition
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 6)

                if sidebarWidth > 0 {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(tabsModel.tabs) { tab in
                                TabItemView(
                                    tab: tab,
                                    isSelected: tabsModel.selectedTab == tab.id,
                                    closeTab: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            closeTab(tab)
                                        }
                                    }
                                )
                                .transition(.move(edge: .trailing))
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        tabsModel.selectedTab = tab.id
                                        if isSearchBarFocused() {
                                            updateInputText()
                                        }
                                        loadCurrentTab()
                                    }
                                }
                                .onDrag {
                                    NSItemProvider(object: tab.id.uuidString as NSString)
                                }
                                .onDrop(of: [.text], delegate: TabDropDelegate(currentTab: tab, tabsModel: tabsModel))
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }

                Spacer()

                if sidebarWidth > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(hoverShadow ? 0.15 : 0))
                            .scaleEffect(hoverShadow ? 1.05 : 1)
                            .frame(width: 40, height: 40)
                            .animation(.easeInOut(duration: 0.2), value: hoverShadow)

                        AddTabFloatingButton(addTab: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                addTab()
                            }
                        })
                        .frame(width: 36, height: 36)
                        .scaleEffect(hoverShadow ? 1.1 : 1)
                        .animation(.easeInOut(duration: 0.2), value: hoverShadow)
                        .onHover { isHovering in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                hoverShadow = isHovering
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    .padding(.leading, 10)
                }
            }
        }
        .frame(width: sidebarWidth)
        .overlay(
            ResizableBorder(sidebarWidth: $sidebarWidth)
                .frame(width: 5)
                .offset(x: sidebarWidth - 5)
        )
        // Manage showClearIcon with animation
        .onChange(of: tabsModel.tabs) { newTabs in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2)) {
                showClearIcon = !newTabs.isEmpty
            }
        }
        .onAppear {
            // Set showClearIcon based on existing tabs when the view appears
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2)) {
                showClearIcon = !tabsModel.tabs.isEmpty
            }
        }
    }
}
