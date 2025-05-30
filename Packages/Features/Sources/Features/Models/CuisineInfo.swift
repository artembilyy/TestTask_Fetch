//
//  CuisineInfo.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import SwiftUI

// MARK: - CuisineInfo
public struct CuisineInfo: Sendable {
    public let flag: String
    public let color: Color
    public let displayName: String

    public init(flag: String, color: Color, displayName: String) {
        self.flag = flag
        self.color = color
        self.displayName = displayName
    }
}

// MARK: - CuisineDataManager
public struct CuisineDataManager: @unchecked Sendable {
    public static let shared = CuisineDataManager()

    private let cuisineData: [String: CuisineInfo] = [
        "italian": CuisineInfo(flag: "🇮🇹", color: .red, displayName: "Italian"),
        "french": CuisineInfo(flag: "🇫🇷", color: .blue, displayName: "French"),
        "british": CuisineInfo(flag: "🇬🇧", color: .indigo, displayName: "British"),
        "spanish": CuisineInfo(flag: "🇪🇸", color: .yellow, displayName: "Spanish"),
        "german": CuisineInfo(flag: "🇩🇪", color: .red, displayName: "German"),
        "greek": CuisineInfo(flag: "🇬🇷", color: .blue, displayName: "Greek"),
        "polish": CuisineInfo(flag: "🇵🇱", color: .pink, displayName: "Polish"),
        "portuguese": CuisineInfo(flag: "🇵🇹", color: .orange, displayName: "Portuguese"),
        "turkish": CuisineInfo(flag: "🇹🇷", color: .red, displayName: "Turkish"),
        "russian": CuisineInfo(flag: "🇷🇺", color: .blue, displayName: "Russian"),
        "chinese": CuisineInfo(flag: "🇨🇳", color: .yellow, displayName: "Chinese"),
        "japanese": CuisineInfo(flag: "🇯🇵", color: .pink, displayName: "Japanese"),
        "korean": CuisineInfo(flag: "🇰🇷", color: .blue, displayName: "Korean"),
        "thai": CuisineInfo(flag: "🇹🇭", color: .red, displayName: "Thai"),
        "vietnamese": CuisineInfo(flag: "🇻🇳", color: .red, displayName: "Vietnamese"),
        "indian": CuisineInfo(flag: "🇮🇳", color: .orange, displayName: "Indian"),
        "malaysian": CuisineInfo(flag: "🇲🇾", color: .mint, displayName: "Malaysian"),
        "american": CuisineInfo(flag: "🇺🇸", color: .blue, displayName: "American"),
        "mexican": CuisineInfo(flag: "🇲🇽", color: .green, displayName: "Mexican"),
        "canadian": CuisineInfo(flag: "🇨🇦", color: .red, displayName: "Canadian"),
        "brazilian": CuisineInfo(flag: "🇧🇷", color: .green, displayName: "Brazilian"),
        "moroccan": CuisineInfo(flag: "🇲🇦", color: .red, displayName: "Moroccan"),
        "tunisian": CuisineInfo(flag: "🇹🇳", color: .yellow, displayName: "Tunisian"),
        "lebanese": CuisineInfo(flag: "🇱🇧", color: .red, displayName: "Lebanese"),
        "australian": CuisineInfo(flag: "🇦🇺", color: .blue, displayName: "Australian"),
        "mediterranean": CuisineInfo(flag: "🌊", color: .teal, displayName: "Mediterranean"),
        "caribbean": CuisineInfo(flag: "🏝️", color: .orange, displayName: "Caribbean"),
        "scandinavian": CuisineInfo(flag: "❄️", color: .blue, displayName: "Scandinavian"),
        "fusion": CuisineInfo(flag: "🌍", color: .purple, displayName: "Fusion"),
    ]

    private init() {}

    public func getCuisineInfo(_ cuisine: String) -> CuisineInfo {
        let key = cuisine.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        if let info = cuisineData[key] {
            return info
        }

        for (cuisineKey, info) in cuisineData {
            if key.contains(cuisineKey) || cuisineKey.contains(key) {
                return info
            }
        }

        return CuisineInfo(flag: "🌍", color: .gray, displayName: cuisine)
    }

    public func getColor(for cuisine: String) -> Color {
        getCuisineInfo(cuisine).color
    }

    public func getFlag(for cuisine: String) -> String {
        getCuisineInfo(cuisine).flag
    }

    public var allCuisines: [String] {
        Array(cuisineData.keys).sorted()
    }
}
