//
//  AppDependencies.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Domain
import Features
import Foundation
import Infrastructure

// MARK: - AppDependencies
// TODO: Rework or use 3rd party eg Needle at least ServiceLocator pattern

import SwiftUI

// MARK: - DependenciesKey
struct DependenciesKey: EnvironmentKey {
    static let defaultValue: AppDependencies? = nil
}

extension EnvironmentValues {
    var dependencies: AppDependencies? {
        get { self[DependenciesKey.self] }
        set { self[DependenciesKey.self] = newValue }
    }
}

extension View {
    func dependencies(_ dependencies: AppDependencies) -> some View {
        environment(\.dependencies, dependencies)
    }
}

// MARK: - AppDependencies
@MainActor
final class AppDependencies {
    private let httpClient: HTTPClient
    private let imageManager: ImageManager

    private let recipeRepository: any RecipeRepository
    private let imageRepository: any ImageRepository

    private let getRecipesUseCase: any GetRecipesUseCase
    private let searchRecipesUseCase: any SearchRecipesUseCase
    private let getRecipeImageUseCase: any GetRecipeImageUseCase
    private let cacheManagementUseCase: any CacheManagementUseCase

    // MARK: - View Models
    lazy var recipeListViewModel: RecipeListViewModel = .init(
        getRecipesUseCase: getRecipesUseCase,
        searchRecipesUseCase: searchRecipesUseCase
    )

    init() {
        httpClient = URLSessionHTTPClient()

        imageManager = ImageManager(httpClient: httpClient)

        recipeRepository = NetworkRecipeRepository(httpClient: httpClient)
        imageRepository = CachedImageRepository(imageManager: imageManager)

        getRecipesUseCase = GetRecipesUseCaseImpl(repository: recipeRepository)
        searchRecipesUseCase = SearchRecipesUseCaseImpl()
        getRecipeImageUseCase = GetRecipeImageUseCaseImpl(repository: imageRepository)
        cacheManagementUseCase = CacheManagementUseCaseImpl(repository: imageRepository)
    }

    // MARK: - Image Loading Function
    func loadImageData(from url: URL) async -> Data? {
        let result = await getRecipeImageUseCase.execute(url)
        switch result {
        case .success(let data):
            return data
        case .failure:
            return nil
        }
    }

    func clearCache() async {
        let result = await cacheManagementUseCase.execute(.clearCache)
        switch result {
        case .cleared:
            debugPrint("Cache cleared successfully")
        case .error(let error):
            debugPrint("Failed to clear cache: \(error.userMessage)")
        case .size:
            break
        }
    }
}
