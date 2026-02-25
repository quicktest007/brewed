//
//  EmptyStateView.swift
//  Brewed
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        VStack(spacing: BrewedSpacing.xl) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(theme.textSecondary.opacity(0.6))
            
            VStack(spacing: BrewedSpacing.sm) {
                Text(title)
                    .font(BrewedFont.title3())
                    .foregroundColor(theme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(BrewedFont.subheadline())
                    .foregroundColor(theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                BrewedButton(actionTitle, style: .primary, action: action)
                    .frame(width: 200)
            }
        }
        .padding(BrewedSpacing.xxl)
    }
}

#Preview("EmptyState") {
    EmptyStateView(
        icon: "cup.and.saucer",
        title: "No brews yet",
        message: "Add your first brew to start your passport.",
        actionTitle: "Add Brew",
        action: {}
    )
}
