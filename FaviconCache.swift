// FaviconCache.swift

import Foundation
import AppKit

class FaviconCache {
    static let shared = FaviconCache()
    private var cache: NSCache<NSURL, NSImage>

    private init() {
        cache = NSCache<NSURL, NSImage>()
    }

    func image(for url: URL) -> NSImage? {
        return cache.object(forKey: url as NSURL)
    }

    func cache(image: NSImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
