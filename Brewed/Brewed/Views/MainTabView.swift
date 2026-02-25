//
//  MainTabView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var mockData: MockDataService
    @State private var selectedTab = 0
    @State private var showAddBrew = false
    
    var body: some View {
        ZStack {
            // App background - cream color matching logo
            Color.coffeeCream
                .ignoresSafeArea()
            
            // Content
            Group {
                switch selectedTab {
                case 0:
                    MapDiscoveryView()
                case 1:
                    FeedView()
                case 2:
                    Color.clear // Create — handled by center button
                case 3:
                    PassportView()
                case 4:
                    BrewedProfileView()
                        .environmentObject(authManager)
                default:
                    MapDiscoveryView()
                }
            }
            .environmentObject(appData)
            .environmentObject(authManager)
            .environmentObject(mockData)
            
            // Bottom Navigation
            VStack {
                Spacer()
                BottomNavView(activeTab: selectedTab) { tab in
                    if tab == 2 {
                        showAddBrew = true
                    } else {
                        selectedTab = tab
                    }
                }
            }
        }
        .sheet(isPresented: $showAddBrew) {
            AddBrewView()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthManager())
        .environmentObject(AppData())
        .environmentObject(MockDataService.shared)
}
