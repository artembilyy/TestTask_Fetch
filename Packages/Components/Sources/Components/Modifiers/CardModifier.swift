//
//  CardModifier.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import DesignSystem
import SwiftUI

// MARK: - CardModifier
public struct CardModifier: ViewModifier {
    @Environment(\.theme) private var theme

    private let style: CardStyle

    public init(style: CardStyle = .default) {
        self.style = style
    }

    public func body(content: Content) -> some View {
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

// MARK: - ErrorAlertModifier
public struct ErrorAlertModifier: ViewModifier {
    @Binding private var error: Error?
    private let title: String

    public init(error: Binding<Error?>, title: String = "Error") {
        _error = error
        self.title = title
    }

    public func body(content: Content) -> some View {
        content
            .alert(title, isPresented: .constant(error != nil)) {
                Button("OK") {
                    error = nil
                }
            } message: {
                if let error {
                    Text(error.localizedDescription)
                }
            }
    }
}

// MARK: - HapticFeedbackModifier
public struct HapticFeedbackModifier: ViewModifier {
    private let feedbackType: UIImpactFeedbackGenerator.FeedbackStyle

    public init(feedbackType: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        self.feedbackType = feedbackType
    }

    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                let impact = UIImpactFeedbackGenerator(style: feedbackType)
                impact.impactOccurred()
            }
    }
}

// MARK: - View Extensions
public extension View {
    func appCard(style: CardModifier.CardStyle = .default) -> some View {
        modifier(CardModifier(style: style))
    }

    func errorAlert(_ error: Binding<Error?>, title: String = "Error") -> some View {
        modifier(ErrorAlertModifier(error: error, title: title))
    }

    func hapticFeedback(_ feedbackType: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        modifier(HapticFeedbackModifier(feedbackType: feedbackType))
    }
}
