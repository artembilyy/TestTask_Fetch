//
//  RecipeAPIResponse.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Domain
import Foundation

// MARK: - RecipeAPIResponse
public struct RecipeAPIResponse: Codable, Sendable {
    public let recipes: [RecipeAPIModel]

    public init(recipes: [RecipeAPIModel]) {
        self.recipes = recipes
    }
}

// MARK: - RecipeAPIModel
public struct RecipeAPIModel: Codable, Sendable {
    public let uuid: UUID
    public let name: String
    public let cuisine: String
    public let photoURLLarge: URL?
    public let photoURLSmall: URL?
    public let sourceURL: URL?
    public let youtubeURL: URL?

    public init(
        uuid: UUID,
        name: String,
        cuisine: String,
        photoURLLarge: URL? = nil,
        photoURLSmall: URL? = nil,
        sourceURL: URL? = nil,
        youtubeURL: URL? = nil
    ) {
        self.uuid = uuid
        self.name = name
        self.cuisine = cuisine
        self.photoURLLarge = photoURLLarge
        self.photoURLSmall = photoURLSmall
        self.sourceURL = sourceURL
        self.youtubeURL = youtubeURL
    }

    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case cuisine
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

public extension RecipeAPIModel {
    func toDomain() throws -> Recipe {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw DomainError.invalidData("Recipe name is empty")
        }

        guard !cuisine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw DomainError.invalidData("Recipe cuisine is empty")
        }

        return Recipe(
            id: uuid,
            name: name,
            cuisine: cuisine,
            imageURLs: Recipe.ImageURLs(
                small: photoURLSmall,
                large: photoURLLarge
            ),
            externalLinks: Recipe.ExternalLinks(
                source: sourceURL,
                youtube: youtubeURL
            )
        )
    }
}

public extension RecipeAPIResponse {
    func toDomain() throws -> RecipeCollection {
        let domainRecipes = recipes.compactMap { apiModel in
            do {
                return try apiModel.toDomain()
            } catch {
                debugPrint("⚠️ Skipping malformed recipe: \(apiModel.name) - \(error)")
                return nil
            }
        }

        guard !domainRecipes.isEmpty else {
            throw DomainError.malformedData("No valid recipes found in response")
        }

        return RecipeCollection(recipes: domainRecipes)
    }
}

// MARK: - RecipeAPIEndpoint
public enum RecipeAPIEndpoint {
    case allRecipes
    case malformedRecipes
    case emptyRecipes

    public var apiEndpoint: APIEndpoint {
        switch self {
        case .allRecipes:
            APIEndpoint(
                url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
                method: .GET,
                timeoutInterval: 30.0
            )
        case .malformedRecipes:
            APIEndpoint(
                url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!,
                method: .GET,
                timeoutInterval: 30.0
            )
        case .emptyRecipes:
            APIEndpoint(
                url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!,
                method: .GET,
                timeoutInterval: 30.0
            )
        }
    }
}
