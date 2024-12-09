// RippleButton.swift

import SwiftUI

struct RippleButton<Content: View>: View {
    var action: () -> Void
    var content: () -> Content

    @State private var rippleScale: CGFloat = 0
    @State private var rippleOpacity: Double = 0

    var body: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.6)) {
                rippleScale = 4
                rippleOpacity = 0
            }
            action()
        }) {
            ZStack {
                content()
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 20, height: 20)
                    .scaleEffect(rippleScale)
                    .opacity(rippleOpacity)
                    .onAppear {
                        rippleScale = 0
                        rippleOpacity = 0
                    }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            Circle()
                .fill(Color.white.opacity(0.3))
                .scaleEffect(rippleScale)
                .opacity(rippleOpacity)
                .animation(.easeOut(duration: 0.6), value: rippleScale)
        )
    }
}
