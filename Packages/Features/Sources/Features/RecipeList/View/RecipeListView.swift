//
//  RecipeListView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import Components
import DesignSystem
import Domain
import SwiftUI

public struct RecipeListView: View {
    @Environment(\.theme) private var theme
    @StateObject private var viewModel: RecipeListViewModel
    @State private var showingSecretMessage = false

    public let loadImageData: (URL) async -> Data?
    public let clearCache: () async -> Void

    public init(
        viewModel: RecipeListViewModel,
        loadImageData: @escaping (URL) async -> Data?,
        clearCacheAction: @escaping () async -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.loadImageData = loadImageData
        clearCache = clearCacheAction
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Recipes")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        infoMenu
                    }
                }
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search recipes or cuisine"
                )
                .task {
                    await viewModel.loadRecipes()
                }
                .refreshable {
                    await clearCache()
                    await viewModel.silentRefresh()
                }
                .sheet(isPresented: $showingSecretMessage) {
                    SecretMessageView()
                }
        }
    }

    private var infoMenu: some View {
        Menu {
            Button(action: {
                let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/take-home-project.html")!
                UIApplication.shared.open(url)
            }) {
                Label("Test task", systemImage: "doc.text")
            }

            Button(action: {
                showingSecretMessage = true
            }) {
                Label("Secret Button", systemImage: "eye.slash")
            }
        } label: {
            Image(systemName: "info.circle")
                .foregroundColor(theme.colors.primary)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.uiState {
        case .idle:
            EmptyView()

        case .loading:
            LoadingView(text: "Loading recipes...")

        case .loaded(let sections):
            recipeList(sections: sections)

        case .empty:
            EmptyStateView(
                title: viewModel.emptyStateTitle,
                description: viewModel.emptyStateDescription,
                systemImage: viewModel.emptyStateSystemImage,
                action: .init(title: "Refresh") {
                    Task { await viewModel.silentRefresh() }
                }
            )

        case .error(let message):
            ErrorView(
                title: "Unable to load recipes",
                message: message,
                retryAction: {
                    Task { await viewModel.silentRefresh() }
                }
            )
        }
    }

    @ViewBuilder
    private func recipeList(sections: [RecipeSectionPresentationModel]) -> some View {
        List {
            ForEach(sections) { section in
                Section {
                    ForEach(section.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe, loadImageData: loadImageData)) {
                            RecipeRowView(recipe: recipe, loadImageData: loadImageData)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowBackground(Color.clear)
                    }
                } header: {
                    if !section.title.isEmpty {
                        SectionHeaderView(title: section.title)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(.plain)
    }
}
