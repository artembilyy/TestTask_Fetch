//
//  AsyncImageView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import DesignSystem
import SwiftUI

public struct AsyncImageView: View {
    @Environment(\.theme) private var theme
    @State private var imageData: Data?
    @State private var isLoading = false
    @State private var hasError = false

    private let url: URL?
    private let size: ImageSize
    private let contentMode: ContentMode
    private let placeholder: AnyView?
    private let loadImageData: (URL) async -> Data?

    public init(
        url: URL?,
        size: ImageSize,
        contentMode: ContentMode = .fill,
        placeholder: AnyView? = nil,
        loadImageData: @escaping (URL) async -> Data?
    ) {
        self.url = url
        self.size = size
        self.contentMode = contentMode
        self.placeholder = placeholder
        self.loadImageData = loadImageData
    }

    public var body: some View {
        Group {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.colors.recipeImagePlaceholder)
            } else if hasError {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundStyle(theme.colors.secondaryText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.colors.recipeImagePlaceholder)
            } else {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundStyle(theme.colors.secondaryText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.colors.recipeImagePlaceholder)
            }
        }
        .frame(width: size.width, height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius.recipeImage))
        .task(id: url) {
            await loadImage()
        }
    }

    // MARK: - Private Methods

    @MainActor
    private func loadImage() async {
        guard let url else {
            return
        }

        imageData = nil
        hasError = false
        isLoading = true

        imageData = await loadImageData(url)
        hasError = (imageData == nil)

        isLoading = false
    }

    public enum ImageSize {
        case custom(CGSize)

        var width: CGFloat {
            switch self {
            case .custom(let size): size.width
            }
        }

        var height: CGFloat {
            switch self {
            case .custom(let size): size.height
            }
        }
    }
}
