//
//  DesignSystem.swift
//  SubscriptionTestApp
//
//  Created by Assistant on 04.12.2025.
//

import SwiftUI

enum AppTheme {
    // MARK: - Palette
    static let accentPrimary = Color(red: 105 / 255, green: 119 / 255, blue: 1.0)
    static let accentSecondary = Color(red: 182 / 255, green: 108 / 255, blue: 255 / 255)
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 16 / 255, green: 15 / 255, blue: 35 / 255),
            Color(red: 38 / 255, green: 20 / 255, blue: 61 / 255),
            Color(red: 14 / 255, green: 34 / 255, blue: 59 / 255)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardStroke = Color.white.opacity(0.18)
    static let cardBackground = Color(red: 22 / 255, green: 22 / 255, blue: 38 / 255).opacity(0.78)
    static let cardHighlight = Color.white.opacity(0.08)
    static let subtleText = Color.white.opacity(0.75)
}

// MARK: - Components
struct GlassCard<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(AppTheme.cardBackground)
                    .overlay(
                        LinearGradient(
                            colors: [AppTheme.cardHighlight, .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(AppTheme.cardStroke, lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(0.3), radius: 24, x: 0, y: 14)
    }
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [AppTheme.accentPrimary, AppTheme.accentSecondary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .opacity(configuration.isPressed ? 0.8 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: AppTheme.accentPrimary.opacity(0.35), radius: 18, x: 0, y: 12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

// MARK: - Typography
enum AppTypography {
    static let largeTitle = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let title = Font.system(.title2, design: .rounded).weight(.semibold)
    static let sectionTitle = Font.system(.title3, design: .rounded).weight(.semibold)
    static let headline = Font.system(.headline, design: .rounded).weight(.semibold)
    static let body = Font.system(.body, design: .rounded)
    static let subheadline = Font.system(.subheadline, design: .rounded)
    static let footnote = Font.system(.footnote, design: .rounded)
    static let button = Font.system(.callout, design: .rounded).weight(.semibold)
}

// MARK: - View Helpers
extension View {
    func gradientBackground() -> some View {
        background(AppTheme.backgroundGradient.ignoresSafeArea())
    }
    
    func sectionTitleStyle() -> some View {
        font(AppTypography.sectionTitle)
            .foregroundColor(.white)
    }
}
