//
//  Recipe.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Foundation

// MARK: - Recipe
public struct Recipe: Sendable, Identifiable, Hashable {
    public let id: UUID
    public let name: String
    public let cuisine: String
    public let imageURLs: ImageURLs
    public let externalLinks: ExternalLinks

    // MARK: - Initialization
    public init(
        id: UUID = UUID(),
        name: String,
        cuisine: String,
        imageURLs: ImageURLs,
        externalLinks: ExternalLinks = ExternalLinks()
    ) {
        precondition(
            !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            "Recipe name cannot be empty"
        )

        precondition(
            !cuisine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            "Recipe cuisine cannot be empty"
        )

        self.id = id
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.cuisine = cuisine.trimmingCharacters(in: .whitespacesAndNewlines)
        self.imageURLs = imageURLs
        self.externalLinks = externalLinks
    }
}

public extension Recipe {
    struct ImageURLs: Sendable, Hashable {
        public let small: URL?
        public let large: URL?

        public init(small: URL? = nil, large: URL? = nil) {
            self.small = small
            self.large = large
        }

        public func bestURL(preferLarge: Bool = false) -> URL? {
            if preferLarge {
                large ?? small
            } else {
                small ?? large
            }
        }

        public var hasImage: Bool {
            small != nil || large != nil
        }
    }

    struct ExternalLinks: Sendable, Hashable {
        public let source: URL?
        public let youtube: URL?

        public init(source: URL? = nil, youtube: URL? = nil) {
            self.source = source
            self.youtube = youtube
        }

        public var hasLinks: Bool {
            source != nil || youtube != nil
        }
    }
}

// MARK: - Business Logic
public extension Recipe {
    var displayTitle: String {
        "\(name) (\(cuisine))"
    }

    func matches(searchTerm: String) -> Bool {
        guard !searchTerm.isEmpty else {
            return true
        }

        let lowercasedTerm = searchTerm.lowercased()
        return name.lowercased().contains(lowercasedTerm) ||
            cuisine.lowercased().contains(lowercasedTerm)
    }

    var firstLetter: String {
        String(name.prefix(1)).uppercased()
    }
}

// MARK: - RecipeCollection
public struct RecipeCollection: Sendable {
    public let recipes: [Recipe]

    public init(recipes: [Recipe] = []) {
        self.recipes = recipes
    }

    public func filtered(by searchTerm: String) -> RecipeCollection {
        let filteredRecipes = recipes.filter { $0.matches(searchTerm: searchTerm) }
        return RecipeCollection(recipes: filteredRecipes)
    }

    public func groupedByFirstLetter() -> [String: [Recipe]] {
        Dictionary(grouping: recipes) { $0.firstLetter }
    }

    public func sortedAlphabetically() -> RecipeCollection {
        let sortedRecipes = recipes.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        return RecipeCollection(recipes: sortedRecipes)
    }

    public var isEmpty: Bool {
        recipes.isEmpty
    }

    public var count: Int {
        recipes.count
    }
}
