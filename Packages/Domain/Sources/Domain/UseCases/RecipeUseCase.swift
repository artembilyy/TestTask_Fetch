//
//  RecipeUseCase.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Foundation

// MARK: - GetRecipesUseCase
public protocol GetRecipesUseCase: UseCase where Input == Void, Output == RecipeResult {
    func execute() async -> RecipeResult
}

// MARK: - GetRecipesUseCaseImpl
public final class GetRecipesUseCaseImpl: GetRecipesUseCase {
    private let repository: RecipeRepository

    public init(repository: RecipeRepository) {
        self.repository = repository
    }

    public func execute(_ input: Void = ()) async -> RecipeResult {
        do {
            let collection = try await repository.fetchRecipes()

            let sortedCollection = collection.sortedAlphabetically()

            return .success(sortedCollection)
        } catch let error as DomainError {
            return .failure(error)
        } catch {
            return .failure(.repositoryError(error))
        }
    }

    public func execute() async -> RecipeResult {
        await execute(())
    }
}

// MARK: - GetRecipeImageUseCase
public protocol GetRecipeImageUseCase: UseCase where Input == URL, Output == ImageResult {
    func execute(_ input: URL) async -> ImageResult
}

// MARK: - GetRecipeImageUseCaseImpl
public final class GetRecipeImageUseCaseImpl: GetRecipeImageUseCase {
    private let repository: ImageRepository

    public init(repository: ImageRepository) {
        self.repository = repository
    }

    public func execute(_ input: URL) async -> ImageResult {
        do {
            let imageData = try await repository.loadImage(from: input)
            return .success(imageData)
        } catch let error as DomainError {
            return .failure(error)
        } catch {
            return .failure(.repositoryError(error))
        }
    }
}
