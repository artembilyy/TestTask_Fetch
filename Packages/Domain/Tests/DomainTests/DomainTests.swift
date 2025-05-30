//
//  DomainTests.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

@testable import Domain
import Foundation
import Testing

// MARK: - RecipeTests
@Suite("Recipe Core Business Logic")
struct RecipeTests {
    @Test("Recipe creates with valid data")
    func recipeCreationWithValidData() {
        let recipe = Recipe(
            name: "Pasta Carbonara",
            cuisine: "Italian",
            imageURLs: Recipe.ImageURLs(),
            externalLinks: Recipe.ExternalLinks()
        )

        #expect(recipe.name == "Pasta Carbonara")
        #expect(recipe.cuisine == "Italian")
        #expect(recipe.firstLetter == "P")
    }

    @Test("Recipe trims whitespace in name and cuisine")
    func recipeTrimsWhitespace() {
        let recipe = Recipe(
            name: "  Pasta Carbonara  ",
            cuisine: "  Italian  ",
            imageURLs: Recipe.ImageURLs(),
            externalLinks: Recipe.ExternalLinks()
        )

        #expect(recipe.name == "Pasta Carbonara")
        #expect(recipe.cuisine == "Italian")
    }

    @Test("Recipe search works correctly")
    func recipeSearchMatching() {
        let recipe = Recipe(
            name: "Pasta Carbonara",
            cuisine: "Italian",
            imageURLs: Recipe.ImageURLs(),
            externalLinks: Recipe.ExternalLinks()
        )

        #expect(recipe.matches(searchTerm: "pasta"))
        #expect(recipe.matches(searchTerm: "PASTA"))
        #expect(recipe.matches(searchTerm: "italian"))
        #expect(recipe.matches(searchTerm: "carbon"))
        #expect(!recipe.matches(searchTerm: "french"))
    }

    @Test("Recipe returns best image URL")
    func recipeBestImageURL() {
        let smallURL = URL(string: "https://example.com/small.jpg")!
        let largeURL = URL(string: "https://example.com/large.jpg")!

        let imageURLs = Recipe.ImageURLs(small: smallURL, large: largeURL)

        #expect(imageURLs.bestURL(preferLarge: true) == largeURL)
        #expect(imageURLs.bestURL(preferLarge: false) == smallURL)

        let onlySmall = Recipe.ImageURLs(small: smallURL, large: nil)
        #expect(onlySmall.bestURL(preferLarge: true) == smallURL)
    }

    @Test("Recipe ImageURLs determines image availability")
    func recipeImageURLsHasImage() {
        let withImages = Recipe.ImageURLs(
            small: URL(string: "https://example.com/small.jpg"),
            large: URL(string: "https://example.com/large.jpg")
        )
        #expect(withImages.hasImage == true)

        let withoutImages = Recipe.ImageURLs(small: nil, large: nil)
        #expect(withoutImages.hasImage == false)
    }

    @Test("Recipe ExternalLinks determines link availability")
    func recipeExternalLinksHasLinks() {
        let withLinks = Recipe.ExternalLinks(
            source: URL(string: "https://example.com/recipe"),
            youtube: URL(string: "https://youtube.com/watch")
        )
        #expect(withLinks.hasLinks == true)

        let withoutLinks = Recipe.ExternalLinks(source: nil, youtube: nil)
        #expect(withoutLinks.hasLinks == false)
    }
}

// MARK: - RecipeCollectionTests
@Suite("RecipeCollection Business Operations")
struct RecipeCollectionTests {
    private func createTestRecipes() -> [Recipe] {
        [
            Recipe(
                name: "Apple Pie",
                cuisine: "American",
                imageURLs: Recipe.ImageURLs(),
                externalLinks: Recipe.ExternalLinks()
            ),
            Recipe(
                name: "Pasta Carbonara",
                cuisine: "Italian",
                imageURLs: Recipe.ImageURLs(),
                externalLinks: Recipe.ExternalLinks()
            ),
            Recipe(
                name: "Beef Stroganoff",
                cuisine: "Russian",
                imageURLs: Recipe.ImageURLs(),
                externalLinks: Recipe.ExternalLinks()
            ),
        ]
    }

    @Test("RecipeCollection filters recipes by search query")
    func collectionFiltering() {
        let collection = RecipeCollection(recipes: createTestRecipes())

        let filtered = collection.filtered(by: "pasta")
        #expect(filtered.count == 1)
        #expect(filtered.recipes.first?.name == "Pasta Carbonara")

        let italianFiltered = collection.filtered(by: "italian")
        #expect(italianFiltered.count == 1)

        let emptyFiltered = collection.filtered(by: "french")
        #expect(emptyFiltered.isEmpty)
    }

    @Test("RecipeCollection sorts recipes alphabetically")
    func collectionSorting() {
        let collection = RecipeCollection(recipes: createTestRecipes())
        let sorted = collection.sortedAlphabetically()

        let expectedOrder = ["Apple Pie", "Beef Stroganoff", "Pasta Carbonara"]
        let actualOrder = sorted.recipes.map(\.name)

        #expect(actualOrder == expectedOrder)
    }

    @Test("RecipeCollection groups by first letter")
    func collectionGrouping() {
        let collection = RecipeCollection(recipes: createTestRecipes())
        let grouped = collection.groupedByFirstLetter()

        #expect(grouped["A"]?.count == 1)
        #expect(grouped["P"]?.count == 1)
        #expect(grouped["B"]?.count == 1)
        #expect(grouped["A"]?.first?.name == "Apple Pie")
    }

    @Test("RecipeCollection determines emptiness and count")
    func collectionBasicProperties() {
        let emptyCollection = RecipeCollection()
        #expect(emptyCollection.isEmpty == true)
        #expect(emptyCollection.isEmpty)

        let collection = RecipeCollection(recipes: createTestRecipes())
        #expect(collection.isEmpty == false)
        #expect(collection.count == 3)
    }
}
