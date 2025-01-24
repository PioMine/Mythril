import SwiftUI

struct StepTwoView: View {
    var goToNextStep: () -> Void

    // Placeholder states for toggles
    @State private var placeholderOption1: Bool = false
    @State private var placeholderOption2: Bool = false

    // Animation state
    @State private var animateElements = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Customize Your Experience")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : -20)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: animateElements)

            VStack(spacing: 20) {
                // Placeholder Toggle 1
                Toggle("Enable Placeholder Option 1", isOn: $placeholderOption1)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .foregroundColor(.white)
                    .opacity(animateElements ? 1 : 0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: animateElements)

                // Placeholder Toggle 2
                Toggle("Enable Placeholder Option 2", isOn: $placeholderOption2)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .foregroundColor(.white)
                    .opacity(animateElements ? 1 : 0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.5), value: animateElements)
            }

            
        }
        .padding()
        .onAppear {
            animateElements = true
        }
    }
}

