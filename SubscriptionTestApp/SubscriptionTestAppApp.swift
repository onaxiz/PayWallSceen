//
//  SubscriptionTestAppApp.swift
//  SubscriptionTestApp
//
//  Created by Евгения Максимова on 02.12.2025.
//

import SwiftUI

@main
struct SubscriptionTestAppApp: App {
    
    @StateObject private var appState = AppStateViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                    .environmentObject(appState)
        }
    }
}
