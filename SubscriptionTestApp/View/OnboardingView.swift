//
//  OnboardingView.swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject private var appState: AppStateViewModel
    @State private var currentPageIndex: Int = 0
    
    private let totalPages: Int = 2
    
    var body: some View {
        VStack {
            TabView(selection: $currentPageIndex) {
                onboardingPage(
                    title: "Добро пожаловать",
                    subtitle: "Показываем, что ты умеешь работать с несколькими экранами и состояниями.",
                    systemImageName: "sparkles"
                )
                .tag(0)
                
                onboardingPage(
                    title: "Подписка",
                    subtitle: "Сейчас мы предложим оформить подписку и откроем главный экран.",
                    systemImageName: "star.circle.fill"
                )
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle())
            
            Button(action: {
                if currentPageIndex < totalPages - 1 {
                    currentPageIndex += 1
                } else {
                    appState.completeOnboarding()
                }
            }, label: {
                Text(currentPageIndex == totalPages - 1 ? "Перейти к подписке" : "Продолжить")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
            })
            .padding(.bottom, 24)
        }
    }
    
    private func onboardingPage(
        title: String,
        subtitle: String,
        systemImageName: String
    ) -> some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)
                .foregroundColor(.accentColor)
                .padding(.bottom, 8)
            
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}
