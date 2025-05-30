//
//  ImageCache.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import CryptoKit
import Foundation

// MARK: - ImageCache
public actor ImageCache {
    private let cacheDirectory: URL

    public init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = caches.appendingPathComponent("ImageCache")
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    public func image(for url: URL) -> Data? {
        let key = cacheKey(for: url)
        let fileURL = cacheDirectory.appendingPathComponent(key)
        do {
            return try Data(contentsOf: fileURL)
        } catch {
            debugPrint(error)
            return nil
        }
    }

    public func setImage(_ data: Data, for url: URL) {
        let key = cacheKey(for: url)
        let fileURL = cacheDirectory.appendingPathComponent(key)

        Task(priority: .background) {
            do {
                try data.write(to: fileURL)
            } catch {
                debugPrint(error)
            }
        }
    }

    public func clearAll() {
        Task(priority: .background) {
            do {
                try FileManager.default.removeItem(at: cacheDirectory)
                try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
            } catch {
                debugPrint(error)
            }
        }
    }

    private func cacheKey(for url: URL) -> String {
        let urlString = url.absoluteString
        let hash = SHA256.hash(data: Data(urlString.utf8))
        let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()
        let shortHash = String(hashString.prefix(16))
        let fileExtension = url.pathExtension.isEmpty ? "" : ".\(url.pathExtension)"
        return "\(shortHash)\(fileExtension)"
    }
}

// MARK: - ImageManager
public actor ImageManager {
    private let httpClient: HTTPClient
    private let cache = ImageCache()

    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    public func loadImage(from url: URL) async throws -> Data {
        if let cachedData = await cache.image(for: url) {
            return cachedData
        }

        let endpoint = APIEndpoint(url: url, timeoutInterval: 30.0)
        let data = try await httpClient.requestData(endpoint)

        await cache.setImage(data, for: url)

        return data
    }

    public func clearCache() {
        Task { @MainActor in
            await cache.clearAll()
        }
    }

    public func isImageCached(_ url: URL) async -> Bool {
        await cache.image(for: url) != nil
    }
}
