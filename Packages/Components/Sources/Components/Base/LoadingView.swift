//
//  LoadingView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import DesignSystem
import SwiftUI

public struct LoadingView: View {
    @Environment(\.theme) private var theme

    private let text: String?
    private let size: ControlSize

    public init(text: String? = nil, size: ControlSize = .regular) {
        self.text = text
        self.size = size
    }

    public var body: some View {
        VStack(spacing: theme.spacing.md) {
            ProgressView()
                .controlSize(size)

            if let text {
                Text(text)
                    .font(theme.fonts.callout)
                    .foregroundStyle(theme.colors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background)
    }
}
