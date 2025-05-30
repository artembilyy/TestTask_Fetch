//
//  DomainTypes.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Foundation

public typealias RecipeResult = Result<RecipeCollection, DomainError>

public typealias ImageResult = Result<Data, DomainError>

// MARK: - DomainError
public enum DomainError: Error, Sendable, Equatable {
    case noData
    case invalidData(String)
    case malformedData(String)
    case networkUnavailable
    case requestTimeout
    case serverError(Int)
    case noInternetConnection
    case repositoryError(Error)
    case cacheError(String)
    case cacheFull
    case cacheCorrupted
    case invalidSearchTerm
    case recipeNotFound(UUID)

    case unknown(Error)

    public static func == (lhs: DomainError, rhs: DomainError) -> Bool {
        switch (lhs, rhs) {
        case (.cacheCorrupted, .cacheCorrupted),
             (.cacheFull, .cacheFull),
             (.invalidSearchTerm, .invalidSearchTerm),
             (.networkUnavailable, .networkUnavailable),
             (.noData, .noData),
             (.noInternetConnection, .noInternetConnection),
             (.requestTimeout, .requestTimeout):
            true
        case (.cacheError(let lhsMessage), .cacheError(let rhsMessage)),
             (.invalidData(let lhsMessage), .invalidData(let rhsMessage)),
             (.malformedData(let lhsMessage), .malformedData(let rhsMessage)):
            lhsMessage == rhsMessage
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            lhsCode == rhsCode
        case (.recipeNotFound(let lhsID), .recipeNotFound(let rhsID)):
            lhsID == rhsID
        case (.repositoryError(let lhsError), .repositoryError(let rhsError)),
             (.unknown(let lhsError), .unknown(let rhsError)):
            lhsError.localizedDescription == rhsError.localizedDescription
        default:
            false
        }
    }
}

public extension DomainError {
    var userMessage: String {
        switch self {
        case .noData:
            "No recipes available at the moment"
        case .invalidData(let details):
            "Data format error: \(details)"
        case .malformedData(let details):
            "Invalid recipe data: \(details)"
        case .networkUnavailable:
            "Network is currently unavailable"
        case .requestTimeout:
            "Request timed out. Please try again"
        case .serverError(let code):
            "Server error (\(code)). Please try again later"
        case .noInternetConnection:
            "No internet connection available"
        case .repositoryError(let error):
            "Data access error: \(error.localizedDescription)"
        case .cacheError(let details):
            "Cache error: \(details)"
        case .cacheFull:
            "Storage is full. Please clear cache"
        case .cacheCorrupted:
            "Cache is corrupted and needs to be cleared"
        case .invalidSearchTerm:
            "Invalid search term"
        case .recipeNotFound(let id):
            "Recipe \(id) not found"
        case .unknown(let error):
            "Unexpected error: \(error.localizedDescription)"
        }
    }

    var isRecoverable: Bool {
        switch self {
        case .networkUnavailable, .noInternetConnection, .requestTimeout, .serverError:
            true
        case .cacheCorrupted, .cacheFull:
            true
        default:
            false
        }
    }

    var recoveryAction: String? {
        switch self {
        case .networkUnavailable, .noInternetConnection:
            "Check your internet connection and try again"
        case .requestTimeout, .serverError:
            "Pull to refresh or try again later"
        case .cacheCorrupted, .cacheFull:
            "Clear cache in Settings"
        default:
            nil
        }
    }
}

// MARK: - DomainConstants
public enum DomainConstants {
    public static let maxSearchTermLength = 100

    public static let minSearchTermLength = 1

    public static let maxRecipeNameLength = 200

    public static let maxCuisineNameLength = 100
}
