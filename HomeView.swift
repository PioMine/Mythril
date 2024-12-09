import SwiftUI

struct HomeView: View {
    @State private var animateCircles = false
    @State private var underlineVisible = false
    @State private var showSparkles = false

    var body: some View {
        ZStack {
            // Unified Dark Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.black.opacity(0.95)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Subtle Background Accents with Animation
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(x: animateCircles ? -120 : -80, y: animateCircles ? -220 : -180)
                    .animation(
                        Animation.easeInOut(duration: 3).repeatForever(autoreverses: true),
                        value: animateCircles
                    )
                
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 250, height: 250)
                    .blur(radius: 90)
                    .offset(x: animateCircles ? 130 : 170, y: animateCircles ? 270 : 230)
                    .animation(
                        Animation.easeInOut(duration: 3).repeatForever(autoreverses: true),
                        value: animateCircles
                    )
            }
            .onAppear {
                animateCircles.toggle()
            }
            
            VStack(spacing: 20) {
                Spacer()
                
                // Playful Title with Bounce and Hover Effect
                Text("Welcome Home")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                    .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 4)
                    .scaleEffect(underlineVisible ? 1.1 : 1.0)
                    .onHover { hovering in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                            underlineVisible = hovering
                            showSparkles = hovering
                        }
                    }

                // Interactive Subtitle with Animated Underline
                Text("This space is yours. Ready to explore?")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(Color.gray.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .overlay(
                        Rectangle()
                            .fill(Color.purple.opacity(0.3))
                            .frame(height: 2)
                            .offset(y: 15)
                            .scaleEffect(x: underlineVisible ? 1.0 : 0, y: 1, anchor: .center)
                            .animation(.easeInOut(duration: 0.5), value: underlineVisible),
                        alignment: .bottom
                    )

                Spacer()
            }
            .padding()
            
            // Sparkle Effect on Hover
            if showSparkles {
                ForEach(0..<10, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: 5, height: 5)
                        .position(
                            x: CGFloat.random(in: 100...300),
                            y: CGFloat.random(in: 200...400)
                        )
                        .animation(
                            Animation.easeOut(duration: 1).repeatCount(1, autoreverses: false),
                            value: showSparkles
                        )
                        .opacity(0)
                }
            }
        }
    }
}

