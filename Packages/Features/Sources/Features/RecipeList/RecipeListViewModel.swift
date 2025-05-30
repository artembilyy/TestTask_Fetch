//
//  RecipeListViewModel.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Combine
import Domain
import Foundation

// MARK: - RecipeListViewModel
@MainActor
public final class RecipeListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published public private(set) var uiState: RecipeListUIState = .idle
    @Published public var searchText: String = "" {
        didSet {
            Task { await performSearch() }
        }
    }

    private let getRecipesUseCase: any GetRecipesUseCase
    private let searchRecipesUseCase: any SearchRecipesUseCase
    private var allRecipes = RecipeCollection()
    private var searchTask: Task<Void, Never>?

    public init(
        getRecipesUseCase: any GetRecipesUseCase,
        searchRecipesUseCase: any SearchRecipesUseCase
    ) {
        self.getRecipesUseCase = getRecipesUseCase
        self.searchRecipesUseCase = searchRecipesUseCase
    }

    public func loadRecipes() async {
        if case .idle = uiState {
            uiState = .loading
        }

        let result = await getRecipesUseCase.execute()

        switch result {
        case .success(let recipeCollection):
            allRecipes = recipeCollection
            await updateUIWithRecipes(recipeCollection)
        case .failure(let error):
            uiState = .error(error.userMessage)
        }
    }

    public func silentRefresh() async {
        let result = await getRecipesUseCase.execute()
        try? await Task.sleep(nanoseconds: 1_500_000_000)

        switch result {
        case .success(let recipeCollection):
            allRecipes = recipeCollection
            await updateUIWithRecipes(recipeCollection)
        case .failure(let error):
            uiState = .error(error.userMessage)
        }
    }

    private func performSearch() async {
        searchTask?.cancel()

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)

            guard !Task.isCancelled else {
                return
            }
            await executeSearch()
        }
    }

    private func executeSearch() async {
        if searchText.isEmpty {
            await updateUIWithRecipes(allRecipes)
            return
        }

        guard !allRecipes.isEmpty else {
            return
        }

        let searchInput = SearchInput(searchTerm: searchText, recipes: allRecipes)
        let result = await searchRecipesUseCase.execute(searchInput)

        switch result {
        case .success(let filteredCollection):
            let items = filteredCollection.toPresentationSections()
            if items.isEmpty {
                uiState = .empty
            } else {
                uiState = .loaded(items)
            }
        case .failure(let error):
            uiState = .error(error.userMessage)
        }
    }

    private func updateUIWithRecipes(_ recipeCollection: RecipeCollection) async {
        if recipeCollection.isEmpty {
            uiState = .empty
        } else {
            let sections = recipeCollection.toPresentationSections()
            uiState = .loaded(sections)
        }
    }
}

public extension RecipeListViewModel {
    var emptyStateTitle: String {
        if searchText.isEmpty {
            "No Recipes"
        } else {
            "No Results"
        }
    }

    var emptyStateDescription: String {
        if searchText.isEmpty {
            "There are no recipes available at the moment. Pull to refresh or try again later."
        } else {
            "No recipes found for '\(searchText)'. Try a different search term."
        }
    }

    var emptyStateSystemImage: String {
        if searchText.isEmpty {
            "fork.knife"
        } else {
            "magnifyingglass"
        }
    }
}
