// BrowserTab.swift

import SwiftUI
import WebKit
import AppKit

class BrowserTab: Identifiable, ObservableObject, Codable, Equatable {
    static func == (lhs: BrowserTab, rhs: BrowserTab) -> Bool {
        return lhs.id == rhs.id
    }

    let id: UUID
    @Published var title: String
    @Published var url: String
    @Published var history: [String]

    // Non-Codable properties
    @Published var thumbnail: NSImage?
    @Published var favicon: NSImage?

    // Remove webViewWrapper from here
    @Published var webViewStateModel: WebViewStateModel

    enum CodingKeys: String, CodingKey {
        case id, title, url, history
    }

    init(id: UUID = UUID(), title: String, url: String, history: [String]) {
        self.id = id
        self.title = title
        self.url = url
        self.history = history
        // webViewWrapper is no longer initialized here
        self.webViewStateModel = WebViewStateModel()
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let url = try container.decode(String.self, forKey: .url)
        let history = try container.decode([String].self, forKey: .history)
        self.init(id: id, title: title, url: url, history: history)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encode(history, forKey: .history)
    }
}
