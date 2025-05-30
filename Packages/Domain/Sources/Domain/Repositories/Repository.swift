//
//  Repository.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Foundation

// MARK: - Repository
public protocol Repository: Sendable {}

// MARK: - RecipeRepository
public protocol RecipeRepository: Repository {
    func fetchRecipes() async throws -> RecipeCollection
}

// MARK: - ImageRepository
public protocol ImageRepository: Repository {
    func loadImage(from url: URL) async throws -> Data

    func clearCache() async throws

    func isImageCached(url: URL) async -> Bool
}
