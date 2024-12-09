import SwiftUI

struct BackgroundView: View {
    var useGradient: Bool = false

    var body: some View {
        Group {
            if useGradient {
                LinearGradient(
                    gradient: Gradient(colors: [Design.backgroundColor, .black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                Design.backgroundColor
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
