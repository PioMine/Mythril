import SwiftUI

struct ResizableBorder: View {
    @Binding var sidebarWidth: CGFloat
    @GestureState private var dragOffset: CGFloat = 0

    private let minSidebarWidth: CGFloat = 150 // Minimum width limit
    private let maxSidebarWidth: CGFloat = 400 // Maximum width limit

    var body: some View {
        Rectangle()
            .fill(dragOffset == 0 ? Color.clear : Color.gray.opacity(0.3)) // Feedback during drag
            .frame(width: 5)
            .contentShape(Rectangle()) // Restrict gesture area to the visible border
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onChanged { value in
                        let proposedWidth = sidebarWidth + value.translation.width
                        sidebarWidth = proposedWidth.clamped(to: minSidebarWidth...maxSidebarWidth)
                    }
                    .onEnded { _ in
                        sidebarWidth = sidebarWidth.clamped(to: minSidebarWidth...maxSidebarWidth)
                    }
            )
            .highPriorityGesture(DragGesture()) // Ensure this takes precedence over parent gestures
            .allowsHitTesting(true) // Ensure gestures are limited to this area
            .cursor(.resizeLeftRight)
    }
}

// MARK: - Local Extension for Clamping
extension Comparable {
    /// Clamp a value within a given range.
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}
