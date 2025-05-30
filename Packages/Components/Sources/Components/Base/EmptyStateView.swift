//
//  EmptyStateView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import DesignSystem
import SwiftUI

public struct EmptyStateView: View {
    @Environment(\.theme) private var theme

    private let title: String
    private let description: String
    private let systemImage: String
    private let action: EmptyStateAction?

    public init(
        title: String,
        description: String,
        systemImage: String = "tray",
        action: EmptyStateAction? = nil
    ) {
        self.title = title
        self.description = description
        self.systemImage = systemImage
        self.action = action
    }

    public var body: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView {
                Label(title, systemImage: systemImage)
            } description: {
                Text(description)
            } actions: {
                if let action {
                    Button(action.title, action: action.handler)
                        .buttonStyle(.borderedProminent)
                }
            }
        } else {
            VStack(spacing: theme.spacing.md) {
                Image(systemName: systemImage)
                    .font(.system(size: 48))
                    .foregroundStyle(theme.colors.secondaryText)

                Text(title)
                    .font(theme.fonts.title2)
                    .foregroundStyle(theme.colors.text)

                Text(description)
                    .font(theme.fonts.body)
                    .foregroundStyle(theme.colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, theme.spacing.lg)

                if let action {
                    Button(action.title, action: action.handler)
                        .buttonStyle(.borderedProminent)
                        .padding(.top, theme.spacing.sm)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(theme.spacing.lg)
            .background(theme.colors.background)
        }
    }

    public struct EmptyStateAction: Sendable {
        public let title: String
        public let handler: @Sendable () -> Void

        public init(title: String, handler: @escaping @Sendable () -> Void) {
            self.title = title
            self.handler = handler
        }
    }
}
