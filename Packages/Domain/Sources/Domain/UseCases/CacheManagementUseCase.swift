//
//  CacheManagementUseCase.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

// MARK: - CacheManagementUseCase
public protocol CacheManagementUseCase: UseCase where Input == CacheAction, Output == CacheResult {
    func execute(_ input: CacheAction) async -> CacheResult
}

// MARK: - CacheAction
public enum CacheAction: Sendable {
    case clearCache
}

// MARK: - CacheResult
public enum CacheResult: Sendable {
    case size(Int)
    case cleared
    case error(DomainError)
}

// MARK: - CacheManagementUseCaseImpl
public final class CacheManagementUseCaseImpl: CacheManagementUseCase {
    private let repository: ImageRepository

    public init(repository: ImageRepository) {
        self.repository = repository
    }

    public func execute(_ input: CacheAction) async -> CacheResult {
        do {
            switch input {
            case .clearCache:
                try await repository.clearCache()
                return .cleared
            }
        } catch let error as DomainError {
            return .error(error)
        } catch {
            return .error(.repositoryError(error))
        }
    }
}
