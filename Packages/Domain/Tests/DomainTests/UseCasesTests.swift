//
//  UseCasesTests.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

@testable import Domain
import Foundation
import Testing

// MARK: - MockRecipeRepository
private final class MockRecipeRepository: RecipeRepository, @unchecked Sendable {
    var shouldFail = false
    var recipes: [Recipe] = []
    var errorToThrow: DomainError = .networkUnavailable

    func fetchRecipes() async throws -> RecipeCollection {
        if shouldFail {
            throw errorToThrow
        }
        return RecipeCollection(recipes: recipes)
    }
}

// MARK: - MockImageRepository
private final class MockImageRepository: ImageRepository, @unchecked Sendable {
    var cachedImages: [URL: Data] = [:]
    var shouldFailLoad = false
    var shouldFailCache = false
    var errorToThrow: DomainError = .networkUnavailable

    func loadImage(from url: URL) async throws -> Data {
        if let cached = cachedImages[url] {
            return cached
        }

        if shouldFailLoad {
            throw errorToThrow
        }

        let imageData = "mock_image_data".data(using: .utf8)!
        cachedImages[url] = imageData
        return imageData
    }

    func clearCache() async throws {
        if shouldFailCache {
            throw DomainError.cacheError("Failed to clear")
        }
        cachedImages.removeAll()
    }

    func isImageCached(url: URL) async -> Bool {
        cachedImages[url] != nil
    }
}

// MARK: - GetRecipesUseCaseTests
@Suite("GetRecipesUseCase Logic")
struct GetRecipesUseCaseTests {
    @Test("GetRecipesUseCase returns sorted recipes")
    func getRecipesUseCaseSuccess() async {
        let mockRepo = MockRecipeRepository()
        mockRepo.recipes = [
            Recipe(name: "Zebra Cake", cuisine: "American", imageURLs: Recipe.ImageURLs()),
            Recipe(name: "Apple Pie", cuisine: "American", imageURLs: Recipe.ImageURLs()),
        ]

        let useCase = GetRecipesUseCaseImpl(repository: mockRepo)
        let result = await useCase.execute()

        switch result {
        case .success(let collection):
            #expect(collection.count == 2)
            #expect(collection.recipes.first?.name == "Apple Pie")
        case .failure:
            #expect(Bool(false), "Should not fail")
        }
    }

    @Test("GetRecipesUseCase handles network errors")
    func getRecipesUseCaseNetworkFailure() async {
        let mockRepo = MockRecipeRepository()
        mockRepo.shouldFail = true
        mockRepo.errorToThrow = .networkUnavailable

        let useCase = GetRecipesUseCaseImpl(repository: mockRepo)
        let result = await useCase.execute()

        switch result {
        case .success:
            #expect(Bool(false), "Should fail")
        case .failure(let error):
            #expect(error == DomainError.networkUnavailable)
        }
    }

    @Test("GetRecipesUseCase wraps unknown errors")
    func getRecipesUseCaseWrapsUnknownErrors() async {
        let mockRepo = MockRecipeRepository()
        mockRepo.shouldFail = true
        mockRepo.errorToThrow = .unknown(NSError(domain: "test", code: 1))

        let useCase = GetRecipesUseCaseImpl(repository: mockRepo)
        let result = await useCase.execute()

        switch result {
        case .success:
            #expect(Bool(false), "Should fail")
        case .failure(let error):
            if case .repositoryError = error {
            } else if case .unknown = error {
                break
            } else {
                #expect(Bool(false), "Should be repository or unknown error")
            }
        }
    }
}

// MARK: - SearchRecipesUseCaseTests
@Suite("SearchRecipesUseCase Logic")
struct SearchRecipesUseCaseTests {
    private func createTestCollection() -> RecipeCollection {
        let recipes = [
            Recipe(name: "Apple Pie", cuisine: "American", imageURLs: Recipe.ImageURLs()),
            Recipe(name: "Pasta Carbonara", cuisine: "Italian", imageURLs: Recipe.ImageURLs()),
            Recipe(name: "Beef Stroganoff", cuisine: "Russian", imageURLs: Recipe.ImageURLs()),
        ]
        return RecipeCollection(recipes: recipes)
    }

    @Test("SearchRecipesUseCase returns all recipes for empty query")
    func searchUseCaseEmptyQuery() async {
        let collection = createTestCollection()
        let useCase = SearchRecipesUseCaseImpl()
        let input = SearchInput(searchTerm: "", recipes: collection)

        let result = await useCase.execute(input)

        switch result {
        case .success(let filtered):
            #expect(filtered.count == 3)
            #expect(filtered.recipes.first?.name == "Apple Pie")
        case .failure:
            #expect(Bool(false), "Should not fail")
        }
    }

    @Test("SearchRecipesUseCase returns all recipes for whitespace query")
    func searchUseCaseWhitespaceQuery() async {
        let collection = createTestCollection()
        let useCase = SearchRecipesUseCaseImpl()
        let input = SearchInput(searchTerm: "   ", recipes: collection)

        let result = await useCase.execute(input)

        switch result {
        case .success(let filtered):
            #expect(filtered.count == 3)
        case .failure:
            #expect(Bool(false), "Should not fail")
        }
    }

    @Test("SearchRecipesUseCase filters recipes by name")
    func searchUseCaseFilterByName() async {
        let collection = createTestCollection()
        let useCase = SearchRecipesUseCaseImpl()
        let input = SearchInput(searchTerm: "pasta", recipes: collection)

        let result = await useCase.execute(input)

        switch result {
        case .success(let filtered):
            #expect(filtered.count == 1)
            #expect(filtered.recipes.first?.name == "Pasta Carbonara")
        case .failure:
            #expect(Bool(false), "Should not fail")
        }
    }

    @Test("SearchRecipesUseCase filters recipes by cuisine")
    func searchUseCaseFilterByCuisine() async {
        let collection = createTestCollection()
        let useCase = SearchRecipesUseCaseImpl()
        let input = SearchInput(searchTerm: "italian", recipes: collection)

        let result = await useCase.execute(input)

        switch result {
        case .success(let filtered):
            #expect(filtered.count == 1)
            #expect(filtered.recipes.first?.cuisine == "Italian")
        case .failure:
            #expect(Bool(false), "Should not fail")
        }
    }

    @Test("SearchRecipesUseCase returns empty result for non-existent query")
    func searchUseCaseNoMatches() async {
        let collection = createTestCollection()
        let useCase = SearchRecipesUseCaseImpl()
        let input = SearchInput(searchTerm: "nonexistent", recipes: collection)

        let result = await useCase.execute(input)

        switch result {
        case .success(let filtered):
            #expect(filtered.isEmpty)
        case .failure:
            #expect(Bool(false), "Should not fail")
        }
    }
}

// MARK: - GetRecipeImageUseCaseTests
@Suite("GetRecipeImageUseCase Logic")
struct GetRecipeImageUseCaseTests {
    @Test("GetRecipeImageUseCase loads image successfully")
    func imageUseCaseLoadSuccess() async {
        let mockRepo = MockImageRepository()
        let useCase = GetRecipeImageUseCaseImpl(repository: mockRepo)
        let testURL = URL(string: "https://example.com/image.jpg")!

        let result = await useCase.execute(testURL)

        switch result {
        case .success(let data):
            #expect(!data.isEmpty)
            #expect(String(data: data, encoding: .utf8) == "mock_image_data")
        case .failure:
            #expect(Bool(false), "Should not fail")
        }
    }

    @Test("GetRecipeImageUseCase caches image after loading")
    func imageUseCaseCachesAfterLoad() async {
        let mockRepo = MockImageRepository()
        let useCase = GetRecipeImageUseCaseImpl(repository: mockRepo)
        let testURL = URL(string: "https://example.com/cached_image.jpg")!

        let isCachedBefore = await mockRepo.isImageCached(url: testURL)
        #expect(isCachedBefore == false)

        let result = await useCase.execute(testURL)

        switch result {
        case .success(let data):
            #expect(!data.isEmpty)
            let isCachedAfter = await mockRepo.isImageCached(url: testURL)
            #expect(isCachedAfter == true)
        case .failure:
            #expect(Bool(false), "Should not fail")
        }
    }

    @Test("GetRecipeImageUseCase uses cache on repeated load")
    func imageUseCaseUsesCache() async {
        let mockRepo = MockImageRepository()
        let useCase = GetRecipeImageUseCaseImpl(repository: mockRepo)
        let testURL = URL(string: "https://example.com/repeated_image.jpg")!

        let result1 = await useCase.execute(testURL)

        switch result1 {
        case .success(let data1):
            #expect(String(data: data1, encoding: .utf8) == "mock_image_data")

            mockRepo.shouldFailLoad = true
            mockRepo.errorToThrow = .networkUnavailable

            let result2 = await useCase.execute(testURL)

            switch result2 {
            case .success(let data2):
                #expect(String(data: data2, encoding: .utf8) == "mock_image_data")
                #expect(data1 == data2)
            case .failure:
                #expect(Bool(false), "Should use cache and not fail")
            }
        case .failure:
            #expect(Bool(false), "First load should not fail")
        }
    }

    @Test("GetRecipeImageUseCase checks image presence in cache")
    func imageUseCaseChecksCache() async {
        let mockRepo = MockImageRepository()
        let useCase = GetRecipeImageUseCaseImpl(repository: mockRepo)
        let testURL = URL(string: "https://example.com/check_cache.jpg")!

        let isCachedInitially = await mockRepo.isImageCached(url: testURL)
        #expect(isCachedInitially == false)

        _ = await useCase.execute(testURL)

        let isCachedAfterLoad = await mockRepo.isImageCached(url: testURL)
        #expect(isCachedAfterLoad == true)
    }

    @Test("GetRecipeImageUseCase handles loading errors")
    func imageUseCaseLoadFailure() async {
        let mockRepo = MockImageRepository()
        mockRepo.shouldFailLoad = true
        mockRepo.errorToThrow = .requestTimeout

        let useCase = GetRecipeImageUseCaseImpl(repository: mockRepo)
        let testURL = URL(string: "https://example.com/image.jpg")!

        let result = await useCase.execute(testURL)

        switch result {
        case .success:
            #expect(Bool(false), "Should fail")
        case .failure(let error):
            #expect(error == DomainError.requestTimeout)
        }
    }
}

// MARK: - CacheManagementUseCaseTests
@Suite("CacheManagementUseCase Logic")
struct CacheManagementUseCaseTests {
    @Test("CacheManagementUseCase clears cache successfully")
    func cacheManagementClearSuccess() async {
        let mockRepo = MockImageRepository()
        let testURL = URL(string: "https://example.com/image.jpg")!
        mockRepo.cachedImages[testURL] = Data()

        let useCase = CacheManagementUseCaseImpl(repository: mockRepo)
        let result = await useCase.execute(.clearCache)

        switch result {
        case .cleared:
            let isCached = await mockRepo.isImageCached(url: testURL)
            #expect(isCached == false)
        case .error:
            #expect(Bool(false), "Should not fail")
        case .size:
            #expect(Bool(false), "Should return cleared")
        }
    }

    @Test("CacheManagementUseCase handles clearing errors")
    func cacheManagementClearFailure() async {
        let mockRepo = MockImageRepository()
        mockRepo.shouldFailCache = true

        let useCase = CacheManagementUseCaseImpl(repository: mockRepo)
        let result = await useCase.execute(.clearCache)

        switch result {
        case .error(let domainError):
            if case .cacheError(let message) = domainError {
                #expect(message == "Failed to clear")
            } else {
                #expect(Bool(false), "Should be cache error")
            }
        case .cleared, .size:
            #expect(Bool(false), "Should fail")
        }
    }
}
