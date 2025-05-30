//
//  RecipeRowView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Components
import SwiftUI

struct RecipeRowView: View {
    let recipe: RecipePresentationModel
    let loadImageData: (URL) async -> Data?

    var body: some View {
        RecipeCardView(
            title: recipe.title,
            cuisine: recipe.subtitle,
            cuisineFlag: cuisineInfo.flag,
            cuisineColor: cuisineInfo.color,
            imageURL: recipe.imageURL,
            loadImageData: loadImageData
        )
        .appCard(style: .default)
        .hapticFeedback(.light)
        .allowsHitTesting(false)
    }

    private var cuisineInfo: (flag: String, color: Color) {
        let info = CuisineDataManager.shared.getCuisineInfo(recipe.subtitle)
        return (info.flag, info.color)
    }
}
