//
//  RecipePresentationModel.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Domain
import Foundation

// MARK: - RecipePresentationModel
public struct RecipePresentationModel: Identifiable, Sendable, Hashable {
    public let id: UUID
    public let title: String
    public let subtitle: String
    public let imageURL: URL?
    public let largeImageURL: URL?
    public let firstLetter: String
    public let sourceURL: URL?
    public let youtubeURL: URL?

    public init(
        id: UUID,
        title: String,
        subtitle: String,
        imageURL: URL?,
        largeImageURL: URL?,
        firstLetter: String,
        sourceURL: URL?,
        youtubeURL: URL?
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.largeImageURL = largeImageURL
        self.firstLetter = firstLetter
        self.sourceURL = sourceURL
        self.youtubeURL = youtubeURL
    }
}

// MARK: - RecipeSectionPresentationModel
public struct RecipeSectionPresentationModel: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let recipes: [RecipePresentationModel]

    public init(id: String, title: String, recipes: [RecipePresentationModel]) {
        self.id = id
        self.title = title
        self.recipes = recipes
    }
}

// MARK: - RecipeListUIState
public enum RecipeListUIState: Sendable {
    case idle
    case loading
    case loaded([RecipeSectionPresentationModel])
    case empty
    case error(String)

    public var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    public var isEmpty: Bool {
        switch self {
        case .empty: true
        case .loaded(let sections): sections.isEmpty
        default: false
        }
    }

    public var errorMessage: String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }

    public var sections: [RecipeSectionPresentationModel] {
        if case .loaded(let sections) = self {
            return sections
        }
        return []
    }
}

public extension Recipe {
    func toPresentationModel() -> RecipePresentationModel {
        RecipePresentationModel(
            id: id,
            title: name,
            subtitle: cuisine,
            imageURL: imageURLs.bestURL(preferLarge: false),
            largeImageURL: imageURLs.bestURL(preferLarge: true),
            firstLetter: firstLetter,
            sourceURL: externalLinks.source,
            youtubeURL: externalLinks.youtube
        )
    }
}

public extension RecipeCollection {
    func toPresentationSections() -> [RecipeSectionPresentationModel] {
        let presentationModels = recipes.map { $0.toPresentationModel() }
        let grouped = Dictionary(grouping: presentationModels) { $0.firstLetter }

        return grouped
            .sorted { $0.key < $1.key }
            .map { key, recipes in
                RecipeSectionPresentationModel(
                    id: key,
                    title: key,
                    recipes: recipes.sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
                )
            }
    }

    func toPresentationModels() -> [RecipePresentationModel] {
        recipes.map { $0.toPresentationModel() }
    }
}
