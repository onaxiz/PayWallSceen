//
//  RootView..swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var appState: AppStateViewModel
    
    // MARK: - Body
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            switch appState.flow {
            case .onboarding:
                OnboardingView()
                    .transition(.opacity)
            case .paywall:
                PaywallView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            case .main:
                MainView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: RootViewConstants.transitionDuration), value: appState.flow)
        .background(AppTheme.backgroundGradient.ignoresSafeArea())
    }
}

// MARK: - Constants
private enum RootViewConstants {
    static let transitionDuration: Double = 0.35
}
