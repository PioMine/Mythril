// TabItemView.swift

import SwiftUI

struct TabItemView: View {
    @ObservedObject var tab: BrowserTab
    let isSelected: Bool
    var closeTab: () -> Void

    @State private var isHovering = false
    @State private var showPreview = false
    @State private var hoverTimer: Timer?
    
    var body: some View {
        ZStack {
            // Background with subtle hover glow
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Design.accentColor.opacity(0.2) : Color.clear)
                .shadow(color: isHovering ? Design.hoverGlowColor.opacity(0.3) : Design.shadowLight,
                        radius: isHovering ? 8 : 4,
                        x: 0, y: 0)
                .animation(.easeInOut(duration: 0.2), value: isHovering)

            HStack(spacing: 8) {
                // Favicon or Default Icon
                Image(nsImage: tab.favicon ?? NSImage(systemSymbolName: "globe", accessibilityDescription: nil)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Design.iconColor)

                VStack(alignment: .leading, spacing: 2) {
                    Text(tab.title)
                        .font(Design.primaryFont)
                        .foregroundColor(Design.textColor)
                        .lineLimit(1)
                        
                    Text(getDomainName(from: tab.url))
                        .font(.system(size: 10))
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                    
                }
                .edgesIgnoringSafeArea(.top)

                Spacer()

                // Close Button appears only on hover
                if isHovering {
                    CloseButton(closeAction: closeTab)
                        .transition(.opacity)
                }
            }
            .padding(8)
            .background(
                // Subtle background overlay on hover using existing Design.accentColor
                RoundedRectangle(cornerRadius: 8)
                    .fill(isHovering ? Design.accentColor.opacity(0.1) : Color.clear)
                    .animation(.easeInOut(duration: 0.2), value: isHovering)
            )
        }
        .cornerRadius(8)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0)) {
                isHovering = hovering
            }

            if hovering && !showPreview {
                hoverTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                    withAnimation {
                        showPreview = true
                    }
                }
            } else {
                hoverTimer?.invalidate()
                withAnimation {
                    showPreview = false
                }
            }
        }
        .popover(isPresented: $showPreview, arrowEdge: .trailing) {
            TabPreviewView(tab: tab)
        }
        .onDisappear {
            // Invalidate timer and hide preview
            hoverTimer?.invalidate()
            hoverTimer = nil
            showPreview = false
        }
        .transition(.slide)
    }

    // Helper function to extract domain name
    func getDomainName(from urlString: String) -> String {
        guard let url = URL(string: urlString) else { return urlString }
        return url.host ?? urlString
    }
}
