//
//  RecipeDetailView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Components
import DesignSystem
import SwiftUI

public struct RecipeDetailView: View {
    @Environment(\.theme) private var theme

    public let recipe: RecipePresentationModel
    public let loadImageData: (URL) async -> Data?

    public init(
        recipe: RecipePresentationModel,
        loadImageData: @escaping (URL) async -> Data?
    ) {
        self.recipe = recipe
        self.loadImageData = loadImageData
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                recipeHeader
                recipeContent

                if recipe.sourceURL != nil || recipe.youtubeURL != nil {
                    recipeActions
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(theme.colors.background)
    }

    @ViewBuilder
    private var recipeHeader: some View {
        VStack(spacing: 20) {
            if let imageURL = recipe.largeImageURL ?? recipe.imageURL {
                AsyncImageView(
                    url: imageURL,
                    size: .custom(CGSize(width: 280, height: 280)),
                    contentMode: .fill,
                    loadImageData: loadImageData
                )
                .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius.recipeImage))
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
            }

            HStack {
                Spacer()

                HStack(spacing: 8) {
                    Text("🍽")
                        .font(.system(size: 14))

                    Text(recipe.subtitle.uppercased())
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(theme.colors.text.opacity(0.8))
                        .tracking(1)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(theme.colors.text.opacity(0.08))
                )

                Spacer()
            }
        }
    }

    @ViewBuilder
    private var recipeContent: some View {
        VStack(spacing: 16) {
            Text(recipe.title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(theme.colors.text)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal, 8)
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private var recipeActions: some View {
        VStack(spacing: 16) {
            Text("EXPLORE MORE")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(theme.colors.text.opacity(0.6))
                .tracking(2)

            VStack(spacing: 12) {
                if let sourceURL = recipe.sourceURL {
                    actionButton(
                        title: "VIEW FULL RECIPE",
                        icon: "doc.text",
                        url: sourceURL,
                        color: theme.colors.text
                    )
                }

                if let youtubeURL = recipe.youtubeURL {
                    actionButton(
                        title: "WATCH VIDEO",
                        icon: "play.circle",
                        url: youtubeURL,
                        color: .red
                    )
                }
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.cardBackground)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
        )
    }

    @ViewBuilder
    private func actionButton(
        title: String,
        icon: String,
        url: URL,
        color: Color
    ) -> some View {
        Button(action: {
            UIApplication.shared.open(url)
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)

                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                    .fill(color)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
