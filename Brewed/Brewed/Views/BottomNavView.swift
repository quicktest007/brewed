//
//  BottomNavView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI

struct BottomNavView: View {
    let activeTab: Int
    let onTabChange: (Int) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background with border
            HStack(spacing: 0) {
                // Map (primary)
                TabButton(
                    icon: "map.fill",
                    label: "Map",
                    isActive: activeTab == 0,
                    action: { onTabChange(0) }
                )
                
                // Feed
                TabButton(
                    icon: "house.fill",
                    label: "Feed",
                    isActive: activeTab == 1,
                    action: { onTabChange(1) }
                )
                
                // Spacer for Create (Add Brew) button
                Color.clear
                    .frame(maxWidth: .infinity)
                
                // Passport
                TabButton(
                    icon: "star.circle.fill",
                    label: "Passport",
                    isActive: activeTab == 3,
                    action: { onTabChange(3) }
                )
                
                // Profile
                TabButton(
                    icon: "person.fill",
                    label: "Profile",
                    isActive: activeTab == 4,
                    action: { onTabChange(4) }
                )
            }
            .frame(height: 60)
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.coffeeCream),
                alignment: .top
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -2)
            
            // Post button - elevated above the border
            Button(action: {
                onTabChange(2)
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.coffeeBrown, Color.coffeeAccent]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.coffeeCream)
                }
            }
            .offset(y: -28)
        }
    }
}

struct TabButton: View {
    let icon: String
    let label: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: isActive ? .semibold : .regular))
                    .foregroundColor(isActive ? .coffeeBrown : .coffeeAccent)
                    .symbolVariant(isActive ? .fill : .none)
                
                Text(label)
                    .font(.system(size: 10))
                    .foregroundColor(isActive ? .coffeeBrown : .coffeeAccent)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    VStack {
        Spacer()
        BottomNavView(activeTab: 0, onTabChange: { _ in })
    }
}
