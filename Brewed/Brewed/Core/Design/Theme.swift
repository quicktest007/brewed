//
//  Theme.swift
//  Brewed
//
//  Design tokens: colors, typography, spacing, radius, shadows.
//  Coffee-inspired, modern. Light + dark.
//

import SwiftUI

// MARK: - Colors

enum BrewedColors {
    // Light
    static let backgroundLight = Color(red: 0.98, green: 0.97, blue: 0.96)
    static let backgroundDark = Color(red: 0.08, green: 0.08, blue: 0.09)
    
    static let surfaceLight = Color.white
    static let surfaceDark = Color(red: 0.14, green: 0.14, blue: 0.16)
    
    static let textPrimaryLight = Color(red: 0.12, green: 0.11, blue: 0.10)
    static let textPrimaryDark = Color(red: 0.98, green: 0.97, blue: 0.96)
    
    static let textSecondaryLight = Color(red: 0.45, green: 0.42, blue: 0.40)
    static let textSecondaryDark = Color(red: 0.65, green: 0.63, blue: 0.61)
    
    static let accentLight = Color(red: 0.72, green: 0.45, blue: 0.28)   // terracotta/amber
    static let accentDark = Color(red: 0.85, green: 0.62, blue: 0.45)
    
    static let ratingLight = Color(red: 0.85, green: 0.55, blue: 0.25)
    static let ratingDark = Color(red: 0.95, green: 0.75, blue: 0.45)
    
    static let textTertiaryLight = Color(red: 0.55, green: 0.52, blue: 0.50)
    static let textTertiaryDark = Color(red: 0.55, green: 0.53, blue: 0.52)
}

// MARK: - Typography

enum BrewedFont {
    static func largeTitle(_ scheme: ColorScheme = .light) -> Font { .system(size: 28, weight: .bold, design: .default) }
    static func title1(_ scheme: ColorScheme = .light) -> Font { .system(size: 22, weight: .bold, design: .default) }
    static func title2(_ scheme: ColorScheme = .light) -> Font { .system(size: 18, weight: .semibold, design: .default) }
    static func title3(_ scheme: ColorScheme = .light) -> Font { .system(size: 16, weight: .semibold, design: .default) }
    static func body(_ scheme: ColorScheme = .light) -> Font { .system(size: 16, weight: .regular, design: .default) }
    static func callout(_ scheme: ColorScheme = .light) -> Font { .system(size: 15, weight: .regular, design: .default) }
    static func subheadline(_ scheme: ColorScheme = .light) -> Font { .system(size: 14, weight: .regular, design: .default) }
    static func footnote(_ scheme: ColorScheme = .light) -> Font { .system(size: 12, weight: .regular, design: .default) }
    static func caption(_ scheme: ColorScheme = .light) -> Font { .system(size: 11, weight: .regular, design: .default) }
    static func tab(_ scheme: ColorScheme = .light) -> Font { .system(size: 10, weight: .medium, design: .default) }
    
    /// For ratings, price — monospaced numbers
    static func numeric(_ scheme: ColorScheme = .light) -> Font { .system(size: 14, weight: .semibold, design: .rounded).monospacedDigit() }
}

// MARK: - Spacing

enum BrewedSpacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - Corner Radius

enum BrewedRadius {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let full: CGFloat = 999
}

// MARK: - Shadows

enum BrewedShadow {
    static let sm = (color: Color.black.opacity(0.06), radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
    static let md = (color: Color.black.opacity(0.08), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
    static let lg = (color: Color.black.opacity(0.12), radius: CGFloat(16), x: CGFloat(0), y: CGFloat(8))
}

// MARK: - Semantic Colors (theme-aware)

struct BrewedTheme {
    let isDark: Bool
    
    var background: Color { isDark ? BrewedColors.backgroundDark : BrewedColors.backgroundLight }
    var surface: Color { isDark ? BrewedColors.surfaceDark : BrewedColors.surfaceLight }
    var textPrimary: Color { isDark ? BrewedColors.textPrimaryDark : BrewedColors.textPrimaryLight }
    var textSecondary: Color { isDark ? BrewedColors.textSecondaryDark : BrewedColors.textSecondaryLight }
    var accent: Color { isDark ? BrewedColors.accentDark : BrewedColors.accentLight }
    var rating: Color { isDark ? BrewedColors.ratingDark : BrewedColors.ratingLight }
    var textTertiary: Color { isDark ? BrewedColors.textTertiaryDark : BrewedColors.textTertiaryLight }
}
