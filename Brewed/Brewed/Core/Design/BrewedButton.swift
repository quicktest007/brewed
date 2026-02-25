//
//  BrewedButton.swift
//  Brewed
//

import SwiftUI

struct BrewedButton: View {
    enum Style {
        case primary
        case secondary
        case ghost
    }
    
    let title: String
    let style: Style
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(_ title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            Text(title)
                .font(BrewedFont.title3())
                .fontWeight(.semibold)
                .foregroundColor(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, BrewedSpacing.md)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
        }
        .buttonStyle(.plain)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary, .ghost: return theme.accent
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return theme.accent
        case .secondary: return theme.accent.opacity(0.12)
        case .ghost: return .clear
        }
    }
}

#Preview("BrewedButton") {
    VStack(spacing: BrewedSpacing.lg) {
        BrewedButton("Add Brew", style: .primary) {}
        BrewedButton("Save place", style: .secondary) {}
        BrewedButton("Cancel", style: .ghost) {}
    }
    .padding()
}
