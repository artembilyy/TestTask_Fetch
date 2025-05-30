//
//  AppShadows.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

public struct AppShadows: Sendable {
    public let card: Shadow
    public let button: Shadow
    public let modal: Shadow

    init() {
        card = Shadow(
            color: Color.black.opacity(0.1),
            radius: 4,
            x: 0,
            y: 2
        )

        button = Shadow(
            color: Color.black.opacity(0.15),
            radius: 2,
            x: 0,
            y: 1
        )

        modal = Shadow(
            color: Color.black.opacity(0.2),
            radius: 16,
            x: 0,
            y: 8
        )
    }
}
