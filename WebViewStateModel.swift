// WebViewStateModel.swift

import SwiftUI

class WebViewStateModel: ObservableObject {
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var pageURL: String?
    @Published var pageTitle: String?
}
