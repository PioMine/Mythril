import SwiftUI

struct DownloadListView: View {
    @ObservedObject var manager = DownloadManager.shared
    
    var body: some View {
        NavigationView {
            List(manager.downloads) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.fileName)
                            .font(.headline)
                        if item.status == .inProgress {
                            ProgressView(value: item.progress, total: 1.0)
                                .progressViewStyle(LinearProgressViewStyle())
                        } else {
                            Text(item.status == .completed ? "Completed" : "Failed")
                                .foregroundColor(item.status == .completed ? .green : .red)
                        }
                    }
                    Spacer()
                    if item.status == .inProgress {
                        Button(action: {
                            manager.cancelDownload(id: item.id)
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Downloads")
        }
    }
}
