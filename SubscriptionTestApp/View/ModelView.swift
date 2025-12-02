//
//  ModelView.swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var appState: AppStateViewModel
    private let recommendations = RecommendationItem.sample
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: MainViewConstants.stackSpacing) {
                        headerSection
                        
                        subscriptionCard
                        
                        Text(MainViewConstants.recommendationsTitle)
                            .sectionTitleStyle()
                        
                        VStack(spacing: MainViewConstants.cardSpacing) {
                            ForEach(recommendations) { item in
                                RecommendationCard(item: item)
                            }
                        }
                        
                        debugButton
                    }
                    .padding(.top, MainViewConstants.topPadding)
                    .padding(.horizontal, MainViewConstants.horizontalPadding)
                    .padding(.bottom, MainViewConstants.bottomPadding)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    // MARK: - Sections
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: MainViewConstants.headerSpacing) {
            Text(MainViewConstants.headerTitle)
                .font(AppTypography.title)
                .foregroundColor(.white)
            
            Text(MainViewConstants.headerSubtitle)
                .font(AppTypography.body)
                .foregroundColor(AppTheme.subtleText)
        }
    }
    
    private var subscriptionCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: MainViewConstants.cardContentSpacing) {
                HStack {
                    Text(MainViewConstants.subscriptionActive)
                        .font(AppTypography.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(appState.selectedPlanReadable)
                        .font(AppTypography.footnote.weight(.semibold))
                        .padding(.horizontal, MainViewConstants.planPillHorizontalInset)
                        .padding(.vertical, MainViewConstants.planPillVerticalInset)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(MainViewConstants.planPillOpacity))
                        )
                }
                
                Text(MainViewConstants.subscriptionDescription)
                    .font(AppTypography.footnote)
                    .foregroundColor(AppTheme.subtleText)
                
                HStack(spacing: MainViewConstants.statSpacing) {
                    statPill(title: MainViewConstants.paymentTitle, value: appState.selectedPlan.priceText)
                    statPill(title: MainViewConstants.updateTitle, value: MainViewConstants.updateValue)
                }
            }
        }
    }
    
    private func statPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: MainViewConstants.statPillSpacing) {
            Text(title.uppercased())
                .font(AppTypography.footnote.weight(.semibold))
                .foregroundColor(AppTheme.subtleText)
            Text(value)
                .font(AppTypography.body.weight(.semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(MainViewConstants.statPillPadding)
        .background(
            RoundedRectangle(cornerRadius: MainViewConstants.statPillCornerRadius, style: .continuous)
                .fill(Color.white.opacity(MainViewConstants.statPillBackgroundOpacity))
        )
    }
    
    private var debugButton: some View {
        Button(action: appState.resetForDebug) {
            HStack(spacing: MainViewConstants.debugSpacing) {
                Image(systemName: MainViewConstants.debugIcon)
                Text(MainViewConstants.debugTitle)
                    .font(AppTypography.button)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .padding(.top, MainViewConstants.debugTopPadding)
        .padding(.bottom, MainViewConstants.debugBottomPadding)
        .background(
            RoundedRectangle(cornerRadius: MainViewConstants.debugCornerRadius, style: .continuous)
                .stroke(
                    Color.white.opacity(MainViewConstants.debugStrokeOpacity),
                    style: StrokeStyle(lineWidth: 1, dash: MainViewConstants.debugDashPattern)
                )
        )
        .padding(.top, MainViewConstants.debugOuterTopPadding)
        .foregroundColor(.white)
    }
}

// MARK: - Recommendation Card
private struct RecommendationCard: View {
    let item: RecommendationItem
    
    var body: some View {
        GlassCard {
            HStack(spacing: MainViewConstants.recommendationSpacing) {
                Image(systemName: item.icon)
                    .font(.system(size: MainViewConstants.recommendationIconSize))
                    .foregroundColor(.white)
                    .frame(width: MainViewConstants.recommendationIconContainer, height: MainViewConstants.recommendationIconContainer)
                    .background(
                        LinearGradient(
                            colors: item.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: MainViewConstants.recommendationCornerRadius, style: .continuous))
                
                VStack(alignment: .leading, spacing: MainViewConstants.recommendationTextSpacing) {
                    Text(item.title)
                        .font(AppTypography.headline)
                        .foregroundColor(.white)
                    Text(item.subtitle)
                        .font(AppTypography.footnote)
                        .foregroundColor(AppTheme.subtleText)
                }
                
                Spacer()
                
                Image(systemName: MainViewConstants.recommendationChevronIcon)
                    .foregroundColor(AppTheme.subtleText)
            }
        }
    }
}

private struct RecommendationItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
    
    static let sample: [RecommendationItem] = [
        .init(icon: "rectangle.stack.person.crop", title: "Коллекция UI", subtitle: "Подборка экранов для вдохновения", gradient: [Color.purple, AppTheme.accentPrimary]),
        .init(icon: "sparkles.tv", title: "Live-сессия", subtitle: "Разбор подписки и StoreKit", gradient: [Color.orange, Color.pink]),
        .init(icon: "paintbrush", title: "Темы iOS", subtitle: "Гайды по адаптивному дизайну", gradient: [Color.blue, Color.cyan])
    ]
}

// MARK: - View Model Helpers
extension AppStateViewModel {
    var selectedPlanReadable: String {
        switch selectedPlan {
        case .monthly:
            return "Месячная"
        case .yearly:
            return "Годовая"
        }
    }
}

// MARK: - Constants
private enum MainViewConstants {
    static let stackSpacing: CGFloat = 24
    static let cardSpacing: CGFloat = 16
    static let topPadding: CGFloat = 32
    static let horizontalPadding: CGFloat = 20
    static let bottomPadding: CGFloat = 40
    
    static let headerSpacing: CGFloat = 12
    static let headerTitle = "Рады видеть тебя снова"
    static let headerSubtitle = "Спасибо за поддержку проекта. Мы подготовили свежий контент и следим за статусом подписки в локальном хранилище."
    
    static let recommendationsTitle = "Рекомендации для тебя"
    static let recommendationSpacing: CGFloat = 16
    static let recommendationIconSize: CGFloat = 26
    static let recommendationIconContainer: CGFloat = 58
    static let recommendationCornerRadius: CGFloat = 18
    static let recommendationTextSpacing: CGFloat = 6
    static let recommendationChevronIcon = "chevron.right"
    
    static let cardContentSpacing: CGFloat = 16
    static let subscriptionActive = "Подписка активна"
    static let subscriptionDescription = "Мы запомним твой выбор и откроем основной экран сразу после успешной \"покупки\". При желании можно сбросить состояние и пройти путь заново."
    static let planPillHorizontalInset: CGFloat = 10
    static let planPillVerticalInset: CGFloat = 4
    static let planPillOpacity: CGFloat = 0.1
    static let statSpacing: CGFloat = 12
    static let paymentTitle = "Оплата"
    static let updateTitle = "Обновление"
    static let updateValue = "Неделю назад"
    
    static let statPillSpacing: CGFloat = 6
    static let statPillPadding: CGFloat = 14
    static let statPillCornerRadius: CGFloat = 18
    static let statPillBackgroundOpacity: CGFloat = 0.06
    
    static let debugSpacing: CGFloat = 10
    static let debugIcon = "arrow.counterclockwise"
    static let debugTitle = "Сбросить состояние для демонстрации"
    static let debugTopPadding: CGFloat = 8
    static let debugBottomPadding: CGFloat = 12
    static let debugCornerRadius: CGFloat = 24
    static let debugStrokeOpacity: CGFloat = 0.3
    static let debugDashPattern: [CGFloat] = [6, 4]
    static let debugOuterTopPadding: CGFloat = 12
}
