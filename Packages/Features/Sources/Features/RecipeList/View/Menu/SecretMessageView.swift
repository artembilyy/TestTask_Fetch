//
//  SecretMessageView.swift
//  Copyright © FETCH 29.05.2025.
//  All rights reserved.
//  Created by Artem Bilyi.
//

import SwiftUI

// MARK: - SecretMessageView
struct SecretMessageView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme
    @State private var displayedText = ""
    @State private var currentIndex = 0
    @State private var showLink = false

    private let message =
        "Hi! I'm Artem. Would love to connect and hear your feedback on this project. Thanks for taking the time to review it!"
    private let linkedInURL = "https://www.linkedin.com/in/artembilyi/"
    private let typingSpeed: TimeInterval = 0.05

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                headerSection
                messageSection
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.medium)
                }
            }
        }
        .onAppear(perform: startTypingAnimation)
    }
}

private extension SecretMessageView {
    var headerSection: some View {
        VStack(spacing: 20) {
            RotatingEmojiView()

            Text("Greetings!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(theme.colors.primary)
        }
        .padding(.top, 42)
    }

    var messageSection: some View {
        VStack(spacing: 24) {
            messageText

            if showLink {
                linkedInButton
            }
        }
    }

    var messageText: some View {
        Text(displayedText)
            .font(.body)
            .lineSpacing(4)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .frame(minHeight: 100, alignment: .top)
    }

    var linkedInButton: some View {
        Link(destination: URL(string: linkedInURL)!) {
            HStack(spacing: 8) {
                Image(systemName: "person.badge.plus")
                Text("Connect on LinkedIn")
            }
            .font(.callout.weight(.semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.blue.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .transition(.scale(scale: 0.8).combined(with: .opacity))
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showLink)
    }
}

private extension SecretMessageView {
    func startTypingAnimation() {
        displayedText = ""
        currentIndex = 0
        showLink = false

        typeNextCharacter()
    }

    func typeNextCharacter() {
        guard currentIndex < message.count else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    showLink = true
                }
            }
            return
        }

        let characterIndex = message.index(message.startIndex, offsetBy: currentIndex)
        displayedText += String(message[characterIndex])
        currentIndex += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed) {
            typeNextCharacter()
        }
    }
}

// MARK: - RotatingEmojiView
private struct RotatingEmojiView: View {
    @State private var isRotating = false

    var body: some View {
        Image(systemName: "face.smiling.inverse")
            .font(.system(size: 60, weight: .medium))
            .foregroundColor(.yellow)
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    isRotating = true
                }
            }
    }
}
