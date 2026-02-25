//
//  RatingPill.swift
//  Brewed
//

import SwiftUI

struct RatingPill: View {
    let rating: Double
    var showDecimal: Bool = true
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        HStack(spacing: BrewedSpacing.xxs) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 12))
                .foregroundColor(theme.rating)
            Text(showDecimal ? String(format: "%.1f", rating) : "\(Int(rating))")
                .font(BrewedFont.numeric())
                .foregroundColor(theme.textPrimary)
        }
        .padding(.horizontal, BrewedSpacing.sm)
        .padding(.vertical, BrewedSpacing.xs)
        .background(theme.surface)
        .clipShape(Capsule())
    }
}

#Preview("RatingPill") {
    HStack(spacing: 8) {
        RatingPill(rating: 4.5)
        RatingPill(rating: 5.0, showDecimal: false)
    }
    .padding()
}
