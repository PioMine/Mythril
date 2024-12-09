// CloseButton.swift

import SwiftUI

struct CloseButton: View {
    var closeAction: () -> Void

    var body: some View {
        Button(action: closeAction) {
            Image(systemName: "xmark")
                .font(.system(size: 12))
                .foregroundColor(Design.iconColor)
                .padding(4)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
        .transition(.opacity)
        .onHover { hovering in
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}
