// FloatingShapeView.swift

import SwiftUI

struct FloatingShapeView: View {
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacityValue: Double = 0.5

    var body: some View {
        Circle()
            .fill(Design.iconColor.opacity(0.3))
            .frame(width: 40, height: 40)
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .opacity(opacityValue)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    offset = CGSize(width: 50, height: 50)
                }
                withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
                withAnimation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    scale = 1.2
                }
                withAnimation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    opacityValue = 1.0
                }
            }
    }
}
