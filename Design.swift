// Design.swift

import SwiftUI

struct Design {
    // Colors - Pastel Shades for Dark Mode with Muted Gradients
    static let gradientStart = Color(red: 0.65, green: 0.58, blue: 0.85) // Muted Lavender
    static let gradientEnd = Color(red: 0.80, green: 0.65, blue: 0.72)   // Pastel Blush
    static let backgroundColor = Color(red: 30/255, green: 30/255, blue: 40/255) // Deep Charcoal
    static let sidebarColor = Color(red: 35/255, green: 35/255, blue: 45/255)    // Slightly darker for distinction
    static let textColor = Color(red: 245/255, green: 245/255, blue: 235/255)    // Warm Off-White
    static let hoverGlowColor = Color(red: 230/255, green: 230/255, blue: 255/255).opacity(0.15) // Soft Lavender Tint Glow
    static let topBarBackground = Color(red: 25/255, green: 25/255, blue: 35/255).opacity(0.85)  // Matte Glass-Like
    static let topBarBorder = Color.clear // Border removed in favor of texture
    static let iconColor = Color(red: 240/255, green: 240/255, blue: 255/255) // Slightly lighter for clarity
    
    // Shadows - Colored and Dynamic
    static let shadowLight = Color(red: 80/255, green: 70/255, blue: 100/255).opacity(0.4) // Light Lavender Shadow
    static let shadowDeep = Color(red: 50/255, green: 30/255, blue: 70/255).opacity(0.8)  // Deep Purple Shadow
    
    // Accent Color - Subtle yet Warm
    static let accentColor = Color(red: 130/255, green: 90/255, blue: 140/255) // Orchid Tint for Accent

    // Fonts
    static let primaryFont = Font.custom("Helvetica Neue", size: 14)
    static let titleFont = Font.custom("Helvetica Neue", size: 18).weight(.bold)
    static let primaryFontName = "Helvetica Neue"
    static let primaryFontSize: CGFloat = 14.0
    
    // Special Effects
    static let rippleEffectColor = Color(red: 150/255, green: 140/255, blue: 190/255).opacity(0.6) // Ripple Accent
    static let matteGlassOverlay = LinearGradient(
        gradient: Gradient(colors: [
            Color.white.opacity(0.02),
            Color.black.opacity(0.4)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
