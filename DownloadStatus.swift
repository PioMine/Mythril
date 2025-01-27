import Foundation

struct DownloadItem: Identifiable {
    let id = UUID()
    var url: URL
    var progress: Double
    var fileName: String
    var status: DownloadStatus
}

enum DownloadStatus {
    case inProgress, completed, failed
}
