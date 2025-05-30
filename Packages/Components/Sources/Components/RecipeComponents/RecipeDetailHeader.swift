//
//  RecipeDetailHeader.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import DesignSystem
import SwiftUI

public struct RecipeDetailHeader: View {
    @Environment(\.theme) private var theme

    public let title: String
    public let cuisine: String
    public let imageURL: URL?
    public let loadImageData: ((URL) async -> Data?)?

    public init(
        title: String,
        cuisine: String,
        imageURL: URL?,
        loadImageData: ((URL) async -> Data?)? = nil
    ) {
        self.title = title
        self.cuisine = cuisine
        self.imageURL = imageURL
        self.loadImageData = loadImageData
    }

    public var body: some View {
        VStack(spacing: theme.spacing.md) {
            Text(title)
                .font(theme.fonts.largeTitle)
                .foregroundStyle(theme.colors.text)
                .multilineTextAlignment(.center)
                .lineLimit(3)

            Text("Cuisine: \(cuisine)")
                .font(theme.fonts.subheadline)
                .foregroundStyle(theme.colors.secondaryText)

            if let imageURL {
                AsyncImageView(
                    url: imageURL,
                    size: .custom(CGSize(
                        width: UIScreen.main.bounds.width - (theme.spacing.lg * 2),
                        height: theme.layout.recipeDetailImageHeight
                    )),
                    contentMode: .fill,
                    loadImageData: loadImageData!
                )
                .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius.lg))
            }
        }
        .padding(.horizontal, theme.spacing.lg)
    }
}
