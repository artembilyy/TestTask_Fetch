//
//  SectionHeaderView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import DesignSystem
import SwiftUI

struct SectionHeaderView: View {
    @Environment(\.theme) private var theme
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            theme.colors.primary,
                            theme.colors.primary.opacity(0.7),
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [theme.colors.primary.opacity(0.3), Color.clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
                .padding(.leading, 8)
        }
        .padding(.vertical, theme.spacing.sm)
        .padding(.horizontal, theme.spacing.md)
    }
}
