import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var currentStep: Int = 0 // Start with Step 0 (OnboardingView)
    
    var totalSteps = 4 // Steps 0 to 4 (OnboardingView + StepOneView to StepThreeView)

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue, Color.pink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            // Decorative Background Elements
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .blur(radius: 80)
                    .offset(x: -120, y: -250)

                Circle()
                    .fill(Color.pink.opacity(0.2))
                    .frame(width: 180, height: 180)
                    .blur(radius: 90)
                    .offset(x: 150, y: 200)

                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 150, height: 150)
                    .blur(radius: 70)
                    .offset(x: -180, y: 150)
            }

            VStack() {
                Spacer()

                // Show the current step based on the value of currentStep
                ZStack {
                    if currentStep == 0 {
                        OnboardingView(goToNextStep: goToNextStep)
                            .transition(.customMorph)
                    } else if currentStep == 1 {
                        StepOneView(goToNextStep: goToNextStep)
                            .transition(.customMorph)
                    } else if currentStep == 2 {
                        StepTwoView(goToNextStep: goToNextStep)
                            .transition(.customMorph)
                    } else if currentStep == 3 {
                        StepThreeView(goToNextStep: goToNextStep)
                            .transition(.customMorph)
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: currentStep)

                

                // Progress Indicators
                HStack(spacing: 10) {
                    ForEach(0..<totalSteps, id: \.self) { step in
                        Circle()
                            .fill(step <= currentStep ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding()

                

                // Next/Finish Button
                Button(action: {
                    if currentStep < 3 {
                        currentStep += 1
                    } else {
                        hasCompletedOnboarding = true
                    }
                }) {
                    Text(currentStep < 3 ? "Next" : "Finish")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.purple))
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                
                Button(action: {
                    if currentStep > 0 {
                        currentStep -= 1
                    }
                }) {
                    Text(currentStep > 0 ? "Previous" : "" )
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 100)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.purple))
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                        .opacity(currentStep > 0 ? 1 : 0)
                }
            }
            .padding(.bottom, 10)
            .buttonStyle(PlainButtonStyle())
            
        }
        // Apply the selected color scheme
        .preferredColorScheme(colorScheme)
        .onAppear {
            applyTheme()
        }
    }

    // Computed property for color scheme
    private var colorScheme: ColorScheme? {
        switch selectedTheme {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil // System default
        }
    }

    // Manage theme selection
    @AppStorage("selectedTheme") private var selectedTheme: String = "system" // "light", "dark", or "system"

    // Function to apply theme (if needed)
    private func applyTheme() {
        // Additional theme-related setup can be done here
    }

    // Function to move to the next step
    private func goToNextStep() {
        withAnimation {
            if currentStep < totalSteps - 1 {
                currentStep += 1
            } else {
                hasCompletedOnboarding = true
            }
        }
    }
}


// MARK: - Custom Transition Extension
extension AnyTransition {
    static var customMorph: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
}
