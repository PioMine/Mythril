import SwiftUI

struct StepThreeView: View {
    var goToNextStep: () -> Void

    @State private var animateElements = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Almost Done!")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : -20)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: animateElements)

            Text("You're all set to explore Mythril. Click below to start your journey.")
                .font(.body)
                .foregroundColor(Color.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.4), value: animateElements)

            
        }
        .padding()
        .onAppear {
            animateElements = true
        }
    }
}

