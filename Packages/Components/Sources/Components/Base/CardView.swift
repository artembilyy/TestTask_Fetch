//
//  CardView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import DesignSystem
import SwiftUI

public struct CardView<Content: View>: View {
    @Environment(\.theme) private var theme

    private let content: Content
    private let style: CardStyle

    public init(style: CardStyle = .default, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }

    public var body: some View {
        content
            .padding(theme.spacing.cardPadding)
            .background(style.backgroundColor(theme: theme))
            .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius.card))
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius.card)
                    .stroke(style.borderColor(theme: theme), lineWidth: style.borderWidth)
            )
            .shadow(
                color: theme.shadows.card.color,
                radius: theme.shadows.card.radius,
                x: theme.shadows.card.x,
                y: theme.shadows.card.y
            )
    }

    public enum CardStyle {
        case `default`
        case highlighted
        case bordered
        case subtle

        var borderWidth: CGFloat {
            switch self {
            case .default, .subtle: 0
            case .bordered, .highlighted: 1
            }
        }

        func backgroundColor(theme: AppTheme) -> Color {
            switch self {
            case .bordered, .default, .highlighted: theme.colors.cardBackground
            case .subtle: theme.colors.tertiaryBackground
            }
        }

        func borderColor(theme: AppTheme) -> Color {
            switch self {
            case .default, .subtle: .clear
            case .highlighted: theme.colors.primary.opacity(0.3)
            case .bordered: theme.colors.border
            }
        }
    }
}
