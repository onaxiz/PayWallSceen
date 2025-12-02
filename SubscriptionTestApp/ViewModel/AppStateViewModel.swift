//
//  AppStateViewModel.swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import Foundation

enum AppFlowState {
    case onboarding
    case paywall
    case main
}

final class AppStateViewModel: ObservableObject {
    
    @Published var flow: AppFlowState
    @Published var selectedPlan: SubscriptionPlan
    
    private var storage: SubscriptionStorageProtocol
    
    init(storage: SubscriptionStorageProtocol = SubscriptionStorage()) {
        self.storage = storage
        
        if storage.isSubscribed {
            self.flow = .main
        } else {
            self.flow = .onboarding
        }
        
        self.selectedPlan = storage.selectedPlan ?? .yearly
    }
    
    func completeOnboarding() {
        if storage.isSubscribed {
            flow = .main
        } else {
            flow = .paywall
        }
    }
    
    func purchaseCurrentPlan() {
        storage.selectedPlan = selectedPlan
        storage.isSubscribed = true
        flow = .main
    }
    
    func resetForDebug() {
        storage.isSubscribed = false
        storage.selectedPlan = nil
        selectedPlan = .yearly
        flow = .onboarding
    }
}
