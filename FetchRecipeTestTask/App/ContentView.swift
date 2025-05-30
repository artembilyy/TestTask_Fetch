//
//  ContentView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Features
import SwiftUI

struct ContentView: View {
    private let dependencies = AppDependencies()

    var body: some View {
        RecipeListView(
            viewModel: dependencies.recipeListViewModel,
            loadImageData: dependencies.loadImageData,
            clearCacheAction: dependencies.clearCache
        )
        .themed()
    }
}
