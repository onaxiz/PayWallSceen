//
//  PaywallView.swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import SwiftUI

struct PaywallView: View {
    
    @EnvironmentObject private var appState: AppStateViewModel
    @State private var isProcessing = false
    @State private var showSuccessAlert = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: PaywallConstants.sectionSpacing) {
                    headerSection
                    
                    planSelectorSection
                    
                    benefitsSection
                    
                    footnote
                        .padding(.horizontal, PaywallConstants.footnoteHorizontalPadding)
                    
                    continueButton
                        .padding(.horizontal, PaywallConstants.buttonHorizontalPadding)
                        .padding(.top, PaywallConstants.buttonTopPadding)
                }
                .padding(.horizontal, PaywallConstants.scrollHorizontalPadding)
                .padding(.top, PaywallConstants.scrollTopPadding)
                .padding(.bottom, PaywallConstants.scrollBottomPadding)
            }
        }
        .alert(PaywallConstants.alertTitle, isPresented: $showSuccessAlert) {
            Button(PaywallConstants.alertActionTitle, role: .cancel) {
                appState.purchaseCurrentPlan()
            }
        } message: {
            Text(PaywallConstants.alertMessage)
        }
    }
    
    // MARK: - Sections
    private var headerSection: some View {
        GlassCard {
            VStack(spacing: PaywallConstants.heroSpacing) {
                headerBadge
                
                Text(PaywallConstants.heroTitle)
                    .font(AppTypography.largeTitle)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Text(PaywallConstants.heroDescription)
                    .font(AppTypography.body)
                    .foregroundColor(AppTheme.subtleText)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var planSelectorSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: PaywallConstants.planSpacing) {
                Text(PaywallConstants.planTitle)
                    .sectionTitleStyle()
                
                Picker(PaywallConstants.planPickerLabel, selection: $appState.selectedPlan) {
                    ForEach(SubscriptionPlan.allCases) { plan in
                        Text(plan.title).tag(plan)
                    }
                }
                .pickerStyle(.segmented)
                .padding(PaywallConstants.segmentedPadding)
                .background(
                    Color.white.opacity(PaywallConstants.segmentedBackgroundOpacity),
                    in: RoundedRectangle(cornerRadius: PaywallConstants.segmentedCornerRadius, style: .continuous)
                )
                
                VStack(alignment: .leading, spacing: PaywallConstants.planPriceSpacing) {
                    HStack(alignment: .firstTextBaseline, spacing: PaywallConstants.planPriceSpacing) {
                        Text(appState.selectedPlan.priceText)
                            .font(AppTypography.headline)
                            .foregroundColor(.white)
                        
                        discountBadge(for: appState.selectedPlan)
                    }
                    
                    Text(appState.selectedPlan.subtitle)
                        .font(AppTypography.footnote)
                        .foregroundColor(AppTheme.subtleText)
                }
            }
        }
    }
    
    private var benefitsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: PaywallConstants.benefitSpacing) {
                Text(PaywallConstants.benefitsTitle)
                    .sectionTitleStyle()
                
                ForEach(PaywallConstants.benefits) { benefit in
                    benefitRow(benefit)
                }
            }
        }
    }
    
    private func benefitRow(_ benefit: PaywallBenefit) -> some View {
        HStack(spacing: PaywallConstants.benefitRowSpacing) {
            Image(systemName: benefit.iconName)
                .font(.system(size: PaywallConstants.benefitIconSize))
                .foregroundColor(.white)
                .frame(width: PaywallConstants.benefitIconContainerSize, height: PaywallConstants.benefitIconContainerSize)
                .background(
                    RoundedRectangle(cornerRadius: PaywallConstants.benefitIconCornerRadius, style: .continuous)
                        .fill(Color.white.opacity(PaywallConstants.benefitIconBackgroundOpacity))
                )
            
            Text(benefit.title)
                .font(AppTypography.body)
                .foregroundColor(.white)
        }
    }
    
    private var continueButton: some View {
        Button(action: handlePurchase) {
            HStack(spacing: PaywallConstants.buttonContentSpacing) {
                if isProcessing {
                    ProgressView()
                        .tint(.white)
                }
                Text(isProcessing ? PaywallConstants.processingTitle : PaywallConstants.primaryButtonTitle)
                    .font(AppTypography.button)
            }
        }
        .buttonStyle(GradientButtonStyle())
        .opacity(isProcessing ? PaywallConstants.buttonDisabledOpacity : 1)
        .animation(.easeInOut(duration: 0.2), value: isProcessing)
        .disabled(isProcessing)
    }
    
    private var footnote: some View {
        Text(PaywallConstants.footnoteText)
            .font(AppTypography.footnote)
            .foregroundColor(AppTheme.subtleText)
            .multilineTextAlignment(.center)
    }
    
    private var headerBadge: some View {
        HStack(spacing: PaywallConstants.badgeSpacing) {
            ZStack {
                RoundedRectangle(cornerRadius: PaywallConstants.badgeCornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.accentSecondary, AppTheme.accentPrimary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: PaywallConstants.badgeSize, height: PaywallConstants.badgeSize)
                    .opacity(PaywallConstants.badgeOpacity)
                
                Image(systemName: PaywallConstants.badgeIcon)
                    .font(.system(size: PaywallConstants.badgeIconSize))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: PaywallConstants.badgeTextSpacing) {
                Text(PaywallConstants.badgeTitle)
                    .font(AppTypography.footnote.weight(.semibold))
                    .foregroundColor(.white)
                    .opacity(PaywallConstants.badgeTitleOpacity)
                Text(PaywallConstants.badgeSubtitle)
                    .font(AppTypography.subheadline)
                    .foregroundColor(AppTheme.subtleText)
            }
        }
    }
    
    // MARK: - Actions
    private func handlePurchase() {
        guard !isProcessing else { return }
        isProcessing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + PaywallConstants.processingDelay) {
            isProcessing = false
            showSuccessAlert = true
        }
    }
    
    @ViewBuilder
    private func discountBadge(for plan: SubscriptionPlan) -> some View {
        if let badge = plan.discountBadge {
            Text(badge)
                .font(AppTypography.footnote.weight(.semibold))
                .padding(.horizontal, PaywallConstants.badgeHorizontalPadding)
                .padding(.vertical, PaywallConstants.badgeVerticalPadding)
                .background(
                    Capsule()
                        .fill(Color.green.opacity(PaywallConstants.badgeBackgroundOpacity))
                )
                .foregroundColor(.green)
        } else {
            Text(PaywallConstants.badgePlaceholder)
                .font(AppTypography.footnote.weight(.semibold))
                .padding(.horizontal, PaywallConstants.badgeHorizontalPadding)
                .padding(.vertical, PaywallConstants.badgeVerticalPadding)
                .background(
                    Capsule()
                        .fill(Color.clear)
                )
                .hidden()
        }
    }
}

// MARK: - Constants
private struct PaywallBenefit: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
}

private enum PaywallConstants {
    static let sectionSpacing: CGFloat = 24
    static let footnoteHorizontalPadding: CGFloat = 12
    static let buttonHorizontalPadding: CGFloat = 24
    static let buttonTopPadding: CGFloat = 8
    static let scrollHorizontalPadding: CGFloat = 20
    static let scrollTopPadding: CGFloat = 48
    static let scrollBottomPadding: CGFloat = 60
    
    static let alertTitle = "Покупка выполнена"
    static let alertActionTitle = "OK"
    static let alertMessage = "Подписка активирована локально (эмуляция). При следующем запуске сразу откроется главный экран."
    
    static let heroSpacing: CGFloat = 20
    static let heroTitle = "Открой полный доступ"
    static let heroDescription = "Получай подборки, живые обновления и персональные рекомендации. Оплата эмулируется и нужна только для демонстрации логики экранов."
    
    static let badgeSpacing: CGFloat = 14
    static let badgeCornerRadius: CGFloat = 18
    static let badgeSize: CGFloat = 72
    static let badgeOpacity: CGFloat = 0.9
    static let badgeIcon = "lock.shield"
    static let badgeIconSize: CGFloat = 30
    static let badgeTextSpacing: CGFloat = 4
    static let badgeTitle = "Paywall Showcase"
    static let badgeSubtitle = "Интерактивный демо-экран подписки"
    static let badgeTitleOpacity: CGFloat = 0.85
    
    static let planSpacing: CGFloat = 16
    static let planTitle = "Выберите план"
    static let planPickerLabel = "План подписки"
    static let segmentedPadding: CGFloat = 6
    static let segmentedBackgroundOpacity = 0.08
    static let segmentedCornerRadius: CGFloat = 18
    static let planPriceSpacing: CGFloat = 8
    static let badgeHorizontalPadding: CGFloat = 10
    static let badgeVerticalPadding: CGFloat = 4
    static let badgeBackgroundOpacity: CGFloat = 0.2
    static let badgePlaceholder = "−45% выгоднее"
    
    static let benefitSpacing: CGFloat = 16
    static let benefitsTitle = "Что внутри"
    static let benefitRowSpacing: CGFloat = 12
    static let benefitIconSize: CGFloat = 20
    static let benefitIconContainerSize: CGFloat = 44
    static let benefitIconCornerRadius: CGFloat = 14
    static let benefitIconBackgroundOpacity: CGFloat = 0.08
    
    static let benefits: [PaywallBenefit] = [
        PaywallBenefit(iconName: "sparkles", title: "Новые подборки каждую неделю"),
        PaywallBenefit(iconName: "bolt.horizontal.circle", title: "Синхронизация между устройствами"),
        PaywallBenefit(iconName: "paintbrush.pointed", title: "Эксклюзивные дизайн-шаблоны")
    ]
    
    static let footnoteText = "Демонстрационный paywall. Покупка не списывает средства, а нужна, чтобы показать переход к главному экрану и сохранение выбранного плана."
    static let primaryButtonTitle = "Получить полный доступ"
    static let processingTitle = "Оформляем..."
    static let processingDelay: Double = 0.6
    static let buttonContentSpacing: CGFloat = 8
    static let buttonDisabledOpacity: CGFloat = 0.86
}
