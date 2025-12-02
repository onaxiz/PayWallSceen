//
//  OnboardingView.swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject private var appState: AppStateViewModel
    @State private var currentPageIndex = 0
    
    // MARK: - Body
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: OnboardingConstants.stackSpacing) {
                onboardingPager
                
                pageIndicators
                
                ctaButton
            }
            .padding(.horizontal)
            .padding(.top, OnboardingConstants.topPadding)
            .padding(.bottom, OnboardingConstants.bottomPadding)
        }
    }
    
    // MARK: - Private Subviews
    private var onboardingPager: some View {
        TabView(selection: $currentPageIndex) {
            ForEach(Array(OnboardingConstants.pages.enumerated()), id: \.element.id) { index, page in
                onboardingPage(page)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: OnboardingConstants.cardHeight)
    }
    
    private var pageIndicators: some View {
        HStack(spacing: OnboardingConstants.indicatorSpacing) {
            ForEach(0..<OnboardingConstants.pages.count, id: \.self) { index in
                let isActive = index == currentPageIndex
                Circle()
                    .fill(isActive ? AppTheme.accentPrimary : AppTheme.cardStroke)
                    .frame(
                        width: isActive ? OnboardingConstants.indicatorActiveSize : OnboardingConstants.indicatorInactiveSize,
                        height: isActive ? OnboardingConstants.indicatorActiveSize : OnboardingConstants.indicatorInactiveSize
                    )
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPageIndex)
            }
        }
    }
    
    private var ctaButton: some View {
        Button(action: advance) {
            Text(currentPageIndex == OnboardingConstants.pages.count - 1 ? OnboardingConstants.finalButtonTitle : OnboardingConstants.nextButtonTitle)
                .font(AppTypography.button)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(GradientButtonStyle())
        .padding(.horizontal, OnboardingConstants.ctaHorizontalPadding)
    }
    
    private func onboardingPage(_ page: OnboardingPage) -> some View {
        GlassCard {
            VStack(spacing: OnboardingConstants.cardContentSpacing) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.accentSecondary.opacity(0.7), AppTheme.accentPrimary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: OnboardingConstants.illustrationSize, height: OnboardingConstants.illustrationSize)
                        .opacity(0.8)
                        .blur(radius: 0.5)
                    
                    Image(systemName: page.systemImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: OnboardingConstants.iconSize, height: OnboardingConstants.iconSize)
                        .foregroundColor(.white)
                        .symbolRenderingMode(.hierarchical)
                }
                
                Text(page.title)
                    .font(AppTypography.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Text(page.subtitle)
                    .font(AppTypography.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppTheme.subtleText)
                    .padding(.horizontal, OnboardingConstants.textHorizontalInset)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func advance() {
        if currentPageIndex < OnboardingConstants.pages.count - 1 {
            withAnimation(.spring()) {
                currentPageIndex += 1
            }
        } else {
            appState.completeOnboarding()
        }
    }
}

// MARK: - Constants
private struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImageName: String
}

private enum OnboardingConstants {
    static let stackSpacing: CGFloat = 28
    static let cardHeight: CGFloat = 420
    static let topPadding: CGFloat = 40
    static let bottomPadding: CGFloat = 32
    static let indicatorSpacing: CGFloat = 10
    static let indicatorActiveSize: CGFloat = 12
    static let indicatorInactiveSize: CGFloat = 9
    static let ctaHorizontalPadding: CGFloat = 24
    static let cardContentSpacing: CGFloat = 20
    static let illustrationSize: CGFloat = 140
    static let iconSize: CGFloat = 72
    static let textHorizontalInset: CGFloat = 12
    static let finalButtonTitle = "Перейти к подписке"
    static let nextButtonTitle = "Продолжить"
    
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Добро пожаловать",
            subtitle: "Показываем, что ты умеешь работать с несколькими экранами и состояниями.",
            systemImageName: "sparkles"
        ),
        OnboardingPage(
            title: "Подписка",
            subtitle: "Сейчас мы предложим оформить подписку и откроем главный экран.",
            systemImageName: "star.circle.fill"
        )
    ]
}
