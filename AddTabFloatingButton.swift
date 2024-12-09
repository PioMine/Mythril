// AddTabFloatingButton.swift

import SwiftUI

struct AddTabFloatingButton: View {
    var addTab: () -> Void

    var body: some View {
        Button(action: {
            addTab()
        }) {
            Image(systemName: "widget.small.badge.plus")
                .font(.system(size: 20))
                
        }
        .buttonStyle(PlainButtonStyle())
        .padding(5)
    }
}
