import SwiftUI

struct BookmarkButton: View {
    @Binding var bookmarks: [String]
    @Binding var showBookmarkList: Bool
    var currentTabURL: String
    @Binding var inputText: String
    var loadURL: () -> Void

    var body: some View {
        Button(action: {
            toggleBookmark()
        }) {
            Image(systemName: bookmarks.contains(currentTabURL) ? "bookmark.fill" : "bookmark")
                .font(.system(size: 14))
                .foregroundColor(bookmarks.contains(currentTabURL) ? Design.accentColor : Design.iconColor)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: {
                showBookmarkList = true
            }) {
                Text("Show Bookmarks")
            }
        }
        .popover(isPresented: $showBookmarkList) {
            BookmarkListView(
                bookmarks: $bookmarks,
                onBookmarkSelected: { selectedURL in
                    self.inputText = selectedURL
                    showBookmarkList = false
                    loadURL()
                },
                onClose: {
                    showBookmarkList = false
                }
            )
        }
    }

    private func toggleBookmark() {
        if let index = bookmarks.firstIndex(of: currentTabURL) {
            // Remove bookmark
            bookmarks.remove(at: index)
        } else {
            // Add bookmark
            bookmarks.append(currentTabURL)
        }
    }
}
