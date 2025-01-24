import SwiftUI

struct StepOneView: View {
    var goToNextStep: () -> Void
    
    // Access and modify the selected theme
    @AppStorage("selectedTheme") private var selectedTheme: String = "system" // "light", "dark", or "system"

    @State private var animateButtons = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Choose Your Theme")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                .opacity(animateButtons ? 1 : 0)
                .offset(y: animateButtons ? 0 : -20)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: animateButtons)

            HStack(spacing: 20) {
                // Light Mode Button
                ThemeButton(title: "Light Mode", theme: "light", isSelected: selectedTheme == "light") {
                    selectedTheme = "light"
                    goToNextStep()
                }
                .opacity(animateButtons ? 1 : 0)
                .offset(y: animateButtons ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.4), value: animateButtons)

                // Dark Mode Button
                ThemeButton(title: "Dark Mode", theme: "dark", isSelected: selectedTheme == "dark") {
                    selectedTheme = "dark"
                    goToNextStep()
                }
                .opacity(animateButtons ? 1 : 0)
                .offset(y: animateButtons ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.5), value: animateButtons)
            }
        }
        .padding()
        .onAppear {
            animateButtons = true
        }
    }
}

struct ThemeButton: View {
    var title: String
    var theme: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .black)
                .padding()
                .frame(width: 140, height: 50)
                .background(isSelected ? Color.blue : Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .accessibilityLabel("\(title)")
    }
}

