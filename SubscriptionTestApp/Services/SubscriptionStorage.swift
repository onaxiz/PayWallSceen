//
//  SubscriptionStorage.swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import Foundation

protocol SubscriptionStorageProtocol {
    var isSubscribed: Bool { get set }
    var selectedPlan: SubscriptionPlan? { get set }
}

final class SubscriptionStorage: SubscriptionStorageProtocol {
    
    private enum Keys {
        static let isSubscribed = "isSubscribed"
        static let selectedPlan = "selectedPlan"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var isSubscribed: Bool {
        get {
            userDefaults.bool(forKey: Keys.isSubscribed)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isSubscribed)
        }
    }
    
    var selectedPlan: SubscriptionPlan? {
        get {
            guard let rawValue = userDefaults.string(forKey: Keys.selectedPlan) else {
                return nil
            }
            return SubscriptionPlan(rawValue: rawValue)
        }
        set {
            if let newValue = newValue {
                userDefaults.set(newValue.rawValue, forKey: Keys.selectedPlan)
            } else {
                userDefaults.removeObject(forKey: Keys.selectedPlan)
            }
        }
    }
}
