import SwiftUI

struct OnboardingView: View {
    var goToNextStep: () -> Void

    var body: some View {
        VStack(spacing: 30) {
                        Spacer()

                        // Welcome Title
                        Text("Welcome to Mythril")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)

                        // Subtitle
                        Text("Your sleek, material-inspired browser interface.")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(Color.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        // Separate Line for "Let's get you started!"
                        Text("Let's get you started!")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(Color.white.opacity(0.9))
                            .multilineTextAlignment(.center)


            Spacer()

            
        }
        .padding()
        
        .edgesIgnoringSafeArea(.all)
    }
}

