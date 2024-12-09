import SwiftUI

struct SearchBarView: View {
    @Binding var inputText: String
    var updateInputText: () -> Void
    var loadURL: () -> Void
    var currentTabTitle: String
    var currentTabURL: String
    @Binding var isFocused: Bool

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            // Centered text when unfocused
            if !isFocused && !isTextFieldFocused {
                Text(currentTabTitle)
                    .font(Design.primaryFont)
                    .foregroundColor(Color.gray.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Design.topBarBackground)
                    )
                    .onTapGesture {
                        // Focus on the invisible TextField when tapped
                        isTextFieldFocused = true
                        isFocused = true
                    }
            }

            // Invisible TextField that contains the full URL
            TextField("", text: $inputText)
                .font(Design.primaryFont)
                .foregroundColor(Design.textColor)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color.clear) // Fully transparent background
                .focused($isTextFieldFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .opacity(isFocused || isTextFieldFocused ? 1 : 0)
                .onAppear {
                    setInputTextForUnfocusedState()
                }
                .onChange(of: isTextFieldFocused) { focused in
                    isFocused = focused
                    if focused {
                        setInputTextForFocusedState()
                    }
                }
                .onSubmit {
                    loadURL()
                    isFocused = false
                    isTextFieldFocused = false
                }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }

    // MARK: - Helper Functions

    private func setInputTextForFocusedState() {
        // Set the full URL when focused
        inputText = currentTabURL
    }

    private func setInputTextForUnfocusedState() {
        // Only update the title if not editing
        if !isFocused && !isTextFieldFocused {
            inputText = currentTabTitle
        }
    }
}
