//
//  NetworkRecipeRepository.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Domain
import Foundation

public final class NetworkRecipeRepository: RecipeRepository, @unchecked Sendable {
    private let httpClient: HTTPClient
    private let endpoint: RecipeAPIEndpoint

    public init(
        httpClient: HTTPClient,
        endpoint: RecipeAPIEndpoint = .allRecipes
    ) {
        self.httpClient = httpClient
        self.endpoint = endpoint
    }

    public func fetchRecipes() async throws -> RecipeCollection {
        do {
            let apiResponse = try await httpClient.request(
                endpoint.apiEndpoint,
                responseType: RecipeAPIResponse.self
            )

            guard !apiResponse.recipes.isEmpty else {
                throw DomainError.noData
            }

            let domainCollection = try apiResponse.toDomain()

            guard !domainCollection.isEmpty else {
                throw DomainError.noData
            }

            return domainCollection

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
            case .decodingError:
                throw DomainError.malformedData("Failed to parse recipe data")
            case .noData:
                throw DomainError.noData
            case .invalidResponse, .invalidURL:
                throw DomainError.invalidData("Invalid API response")
            }
        } catch let error as DomainError {
            throw error
        } catch {
            throw DomainError.repositoryError(error)
        }
    }
}
