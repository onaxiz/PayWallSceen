//
//  SubscriptionPlan.swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import Foundation

enum SubscriptionPlan: String, CaseIterable, Identifiable {
    case monthly
    case yearly
    
    var id: String {
        rawValue
    }
    
    var title: String {
        switch self {
        case .monthly:
            return "Месяц"
        case .yearly:
            return "Год"
        }
    }
    
    var subtitle: String {
        switch self {
        case .monthly:
            return "Оплата раз в месяц"
        case .yearly:
            return "Годовая подписка со скидкой"
        }
    }
    
    var priceText: String {
        switch self {
        case .monthly:
            return "299 ₽ / месяц"
        case .yearly:
            return "1 990 ₽ / год"
        }
    }
    
    var discountBadge: String? {
        switch self {
        case .monthly:
            return nil
        case .yearly:
            return "−45% выгоднее"
        }
    }
}
