//
//  ThemeKey.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

// MARK: - ThemeKey
public struct ThemeKey: EnvironmentKey {
    public static let defaultValue = AppTheme.shared
}

public extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
