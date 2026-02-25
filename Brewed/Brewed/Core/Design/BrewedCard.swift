//
//  BrewedCard.swift
//  Brewed
//

import SwiftUI

struct BrewedCard<Content: View>: View {
    let content: Content
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.lg))
            .shadow(
                color: BrewedShadow.md.color,
                radius: BrewedShadow.md.radius,
                x: BrewedShadow.md.x,
                y: BrewedShadow.md.y
            )
    }
}

#Preview("BrewedCard") {
    BrewedCard {
        VStack(alignment: .leading, spacing: 8) {
            Text("Place name")
                .font(BrewedFont.title3())
            Text("Address line")
                .font(BrewedFont.subheadline())
                .foregroundColor(BrewedColors.textSecondaryLight)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(BrewedSpacing.lg)
    }
    .padding()
}
