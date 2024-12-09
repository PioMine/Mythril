// BookmarkListView.swift

import SwiftUI

struct BookmarkListView: View {
    @Binding var bookmarks: [String]
    var onBookmarkSelected: (String) -> Void
    var onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Bookmarks")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)

            Divider()
                .background(Color.gray.opacity(0.5))

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(bookmarks, id: \.self) { bookmark in
                        Button(action: {
                            onBookmarkSelected(bookmark)
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(.yellow)
                                Text(bookmark)
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                            .padding(5)
                            .background(Design.hoverGlowColor)
                            .cornerRadius(5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .padding(20)
        .frame(width: 250, height: 400)
        .background(Design.topBarBackground)
        .cornerRadius(20)
        .shadow(color: Design.shadowDeep, radius: 10, x: 0, y: 0)
    }
}
