//
//  AppLayout.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

public struct AppLayout: Sendable {
    // Recipe card dimensions
    public let recipeCardImageSize: CGSize = .init(width: 60, height: 60)
    public let recipeDetailImageHeight: CGFloat = 250

    // Screen margins
    public let screenHorizontalMargin: CGFloat = 16
    public let listHorizontalMargin: CGFloat = 16

    // Grid layout
    public let minRecipeCardWidth: CGFloat = 300
    public let recipeCardSpacing: CGFloat = 16

    init() {}
}
