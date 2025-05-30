//
//  CachedImageRepository.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Foundation

public final class CachedImageRepository: ImageRepository {
    private let imageManager: ImageManager

    public init(imageManager: ImageManager) {
        self.imageManager = imageManager
    }

    public func loadImage(from url: URL) async throws -> Data {
        do {
            return try await imageManager.loadImage(from: url)
        } catch let error as HTTPError {
            switch error {
            case .timeout:
                throw DomainError.requestTimeout
            case .networkError:
                throw DomainError.networkUnavailable
            case .statusCode(let code, _):
                if code >= 500 {
                    throw DomainError.serverError(code)
                } else {
                    throw DomainError.invalidData("HTTP \(code)")
                }
            case .noData:
                throw DomainError.noData
            default:
                throw DomainError.repositoryError(error)
            }
        } catch {
            throw DomainError.repositoryError(error)
        }
    }

    public func clearCache() async throws {
        await imageManager.clearCache()
    }

    public func isImageCached(url: URL) async -> Bool {
        await imageManager.isImageCached(url)
    }
}
