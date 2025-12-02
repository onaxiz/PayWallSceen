//
//  ModelView.swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var appState: AppStateViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Главный экран")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(subscriptionText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                    .padding(.vertical, 8)
                
                Text("Любой контент")
                    .font(.headline)
                
                List {
                    Section(header: Text("Список элементов")) {
                        ForEach(1..<11) { index in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .font(.caption)
                                Text("Элемент №\(index)")
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button("Сбросить состояние (debug)") {
                    appState.resetForDebug()
                }
                .font(.footnote)
                .foregroundColor(.red)
            }
            .padding()
            .navigationTitle("Главный экран")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var subscriptionText: String {
        if let plan = appState.storageSelectedPlanDescription {
            return "Активная подписка: \(plan)"
        } else {
            return "Подписка не найдена. Это не должно происходить при нормальном сценарии."
        }
    }
}

extension AppStateViewModel {
    var storageSelectedPlanDescription: String? {
        switch selectedPlan {
        case .monthly:
            return "Месячная"
        case .yearly:
            return "Годовая"
        }
    }
}
