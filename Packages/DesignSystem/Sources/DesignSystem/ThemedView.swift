//
//  ThemedView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

// MARK: - ThemedView
public struct ThemedView: ViewModifier {
    init() {}

    public func body(content: Content) -> some View {
        content
            .environment(\.theme, AppTheme.shared)
    }
}

public extension View {
    func themed() -> some View {
        modifier(ThemedView())
    }
}
