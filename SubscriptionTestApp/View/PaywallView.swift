//
//  PaywallView.swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import SwiftUI

struct PaywallView: View {
    
    @EnvironmentObject private var appState: AppStateViewModel
    @State private var isProcessing: Bool = false
    @State private var showSuccessAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            headerSection
            
            planSelectorSection
            
            benefitsSection
            
            Spacer()
            
            continueButton
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
        .padding(.top, 32)
        .alert("Покупка выполнена", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {
                appState.purchaseCurrentPlan()
            }
        } message: {
            Text("Подписка активирована локально (эмуляция). При следующем запуске сразу откроется главный экран.")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Открой полный доступ")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Text("Очень простой paywall. Здесь нет реального биллинга, оплата только эмулируется.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.top, 32)
    }
    
    private var planSelectorSection: some View {
        VStack(spacing: 12) {
            Picker("План подписки", selection: $appState.selectedPlan) {
                ForEach(SubscriptionPlan.allCases) { plan in
                    Text(plan.title).tag(plan)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 24)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(appState.selectedPlan.priceText)
                        .font(.title3)
                        .fontWeight(.semibold)
                    if let badge = appState.selectedPlan.discountBadge {
                        Text(badge)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.16))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                }
                
                Text(appState.selectedPlan.subtitle)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
            .padding(.horizontal, 24)
        }
    }
    
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            benefitRow(iconName: "checkmark.circle.fill", text: "Неограниченный доступ к контенту")
            benefitRow(iconName: "checkmark.circle.fill", text: "Обновления и новые функции")
            benefitRow(iconName: "checkmark.circle.fill", text: "Поддержка разработчика")
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    private func benefitRow(iconName: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: iconName)
                .foregroundColor(.accentColor)
            Text(text)
                .font(.subheadline)
        }
    }
    
    private var continueButton: some View {
        Button(action: {
            if isProcessing {
                return
            }
            isProcessing = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isProcessing = false
                showSuccessAlert = true
            }
        }, label: {
            HStack {
                if isProcessing {
                    ProgressView()
                } else {
                    Text("Продолжить")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isProcessing ? Color.gray.opacity(0.3) : Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(12)
        })
        .disabled(isProcessing)
    }
}
