//
//  RecipeCardView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import DesignSystem
import SwiftUI

public struct RecipeCardView: View {
    @Environment(\.theme) private var theme

    public let title: String
    public let cuisineFlag: String
    public let cuisine: String
    public let cuisineColor: Color
    public let imageURL: URL?
    public let loadImageData: ((URL) async -> Data?)?

    public init(
        title: String,
        cuisine: String,
        cuisineFlag: String,
        cuisineColor: Color,
        imageURL: URL?,
        loadImageData: ((URL) async -> Data?)? = nil
    ) {
        self.title = title
        self.cuisine = cuisine
        self.cuisineFlag = cuisineFlag
        self.cuisineColor = cuisineColor
        self.imageURL = imageURL
        self.loadImageData = loadImageData
    }

    public var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                HStack {
                    HStack(spacing: 6) {
                        Text(cuisineFlag)
                            .font(.system(size: 16))

                        Text(cuisine.uppercased())
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .tracking(0.8)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(cuisineColor)
                    )

                    Spacer()
                }

                AsyncImageView(
                    url: imageURL,
                    size: .custom(CGSize(width: 100, height: 100)),
                    contentMode: .fill,
                    loadImageData: loadImageData!
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(theme.colors.text)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                HStack {
                    Spacer()

                    HStack(spacing: 8) {
                        Text("VIEW RECIPE")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(theme.colors.primary)
                    )

                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(theme.colors.cardBackground)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
    }
}
