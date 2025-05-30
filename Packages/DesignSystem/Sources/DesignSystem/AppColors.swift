//
//  AppColors.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

public struct AppColors: Sendable {
    public let primary = Color.blue
    public let error = Color.red

    public let background = Color(.systemBackground)
    public let secondaryBackground = Color(.secondarySystemBackground)
    public let tertiaryBackground = Color(.tertiarySystemBackground)

    public let text = Color(.label)
    public let secondaryText = Color(.secondaryLabel)

    public let border = Color(.separator).opacity(0.3)

    public let cardBackground = Color(.systemBackground)
    public let cardBorder = Color(.separator).opacity(0.2)

    public let recipeImagePlaceholder = Color(.systemGray5)

    init() {}
}
