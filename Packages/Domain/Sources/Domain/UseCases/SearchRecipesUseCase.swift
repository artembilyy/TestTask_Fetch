//
//  SearchRecipesUseCase.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

// MARK: - SearchRecipesUseCase
public protocol SearchRecipesUseCase: UseCase where Input == SearchInput, Output == RecipeResult {
    func execute(_ input: SearchInput) async -> RecipeResult
}

// MARK: - SearchInput
public struct SearchInput: Sendable {
    public let searchTerm: String
    public let recipes: RecipeCollection

    public init(searchTerm: String, recipes: RecipeCollection) {
        self.searchTerm = searchTerm
        self.recipes = recipes
    }
}

// MARK: - SearchRecipesUseCaseImpl
public final class SearchRecipesUseCaseImpl: SearchRecipesUseCase {
    public init() {}

    public func execute(_ input: SearchInput) async -> RecipeResult {
        guard !input.searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .success(input.recipes.sortedAlphabetically())
        }

        let trimmedTerm = input.searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedTerm.count >= 1 else {
            return .success(input.recipes.sortedAlphabetically())
        }

        let filteredCollection = input.recipes.filtered(by: trimmedTerm)
        let sortedCollection = filteredCollection.sortedAlphabetically()

        return .success(sortedCollection)
    }
}
