//
//  RootView..swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var appState: AppStateViewModel
    
    var body: some View {
        Group {
            switch appState.flow {
            case .onboarding:
                OnboardingView()
            case .paywall:
                PaywallView()
            case .main:
                MainView()
            }
        }
    }
}
