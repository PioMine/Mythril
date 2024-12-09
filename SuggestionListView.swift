// SuggestionListView.swift

import SwiftUI

struct SuggestionListView: View {
    var suggestions: [String]
    var selectSuggestion: (String) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Text(suggestion)
                        .foregroundColor(Design.textColor)
                        .padding(5)
                        .background(Design.topBarBackground)
                        .onTapGesture {
                            selectSuggestion(suggestion)
                        }
                }
            }
        }
        .frame(height: min(150, CGFloat(suggestions.count) * 30))
        .background(Design.topBarBackground)
        .cornerRadius(10)
        .padding(.horizontal, 10)
    }
}
