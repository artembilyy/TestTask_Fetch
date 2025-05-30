//
//  ErrorView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import DesignSystem
import SwiftUI

public struct ErrorView: View {
    @Environment(\.theme) private var theme

    private let title: String
    private let message: String
    private let retryAction: (() -> Void)?

    public init(
        title: String = "Something went wrong",
        message: String,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack(spacing: theme.spacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(theme.colors.error)

            Text(title)
                .font(theme.fonts.title2)
                .foregroundStyle(theme.colors.text)

            Text(message)
                .font(theme.fonts.body)
                .foregroundStyle(theme.colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, theme.spacing.lg)

            if let retryAction {
                Button("Try Again", action: retryAction)
                    .buttonStyle(.borderedProminent)
                    .padding(.top, theme.spacing.sm)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(theme.spacing.lg)
        .background(theme.colors.background)
    }
}
