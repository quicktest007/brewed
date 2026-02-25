//
//  BrewedApp.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI

@main
struct BrewedApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var appData = AppData()
    @StateObject private var mockData = MockDataService.shared
    @AppStorage("brewed-theme") private var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isLoading {
                    LoadingScreen()
                } else if !authManager.isAuthenticated {
                    AuthPage(onAuthSuccess: { hasAccount in
                        authManager.authenticate(hasAccount: hasAccount)
                    })
                } else {
                    MainTabView()
                        .environmentObject(authManager)
                        .environmentObject(appData)
                        .environmentObject(mockData)
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
