//
//  AppTheme.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import SwiftUI

public struct AppTheme: Sendable {
    public static let shared = AppTheme()
    private init() {}

    public let colors = AppColors()
    public let fonts = AppFonts()
    public let spacing = AppSpacing()
    public let cornerRadius = AppCornerRadius()
    public let shadows = AppShadows()
    public let layout = AppLayout()
}
