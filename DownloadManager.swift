class DownloadManager: NSObject, ObservableObject, URLSessionDownloadDelegate {
    static let shared = DownloadManager() // Singleton for easy access
    
    @Published var downloads: [DownloadItem] = [] // Tracks ongoing downloads
    
    private var tasks: [UUID: URLSessionDownloadTask] = [:] // Maps task IDs to download tasks
    
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    // Start a new download
    func startDownload(from url: URL) {
        let downloadItem = DownloadItem(url: url, progress: 0.0, fileName: url.lastPathComponent, status: .inProgress)
        downloads.append(downloadItem)
        
        let task = urlSession.downloadTask(with: url)
        tasks[downloadItem.id] = task
        task.resume()
    }
    
    // Cancel a download
    func cancelDownload(id: UUID) {
        tasks[id]?.cancel()
        tasks[id] = nil
        updateDownloadStatus(for: id, to: .failed)
    }
    
    // Save the downloaded file to the user's Downloads folder
    private func saveFile(from localURL: URL, fileName: String) {
        let destinationURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        do {
            try FileManager.default.moveItem(at: localURL, to: destinationURL)
            print("File saved to \(destinationURL.path)")
        } catch {
            print("Error saving file: \(error)")
        }
    }
    
    // Update the status of a download item
    private func updateDownloadStatus(for id: UUID, to status: DownloadStatus) {
        if let index = downloads.firstIndex(where: { $0.id == id }) {
            downloads[index].status = status
        }
    }
    
    // MARK: - URLSessionDownloadDelegate Methods
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            if let id = tasks.first(where: { $1 == downloadTask })?.key {
                if let index = self.downloads.firstIndex(where: { $0.id == id }) {
                    self.downloads[index].progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            if let id = self.tasks.first(where: { $1 == downloadTask })?.key {
                if let index = self.downloads.firstIndex(where: { $0.id == id }) {
                    let fileName = self.downloads[index].fileName
                    self.saveFile(from: location, fileName: fileName)
                    self.updateDownloadStatus(for: id, to: .completed)
                }
            }
        }
    }
}
