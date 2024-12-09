// BookmarkModalView.swift

import SwiftUI

struct BookmarkModalView: View {
    @Binding var bookmarkName: String
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Add Bookmark")
                    .font(.headline)
                    .foregroundColor(.white)

                TextField("Bookmark Name", text: $bookmarkName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)

                HStack(spacing: 20) {
                    Button(action: onSave) {
                        Text("Save")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    Button(action: onCancel) {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(30)
            .background(Design.topBarBackground)
            .cornerRadius(20)
            .shadow(color: Design.shadowDeep, radius: 10, x: 0, y: 0)
            .frame(width: 300)
        }
    }
}
