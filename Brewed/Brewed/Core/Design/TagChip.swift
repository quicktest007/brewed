//
//  TagChip.swift
//  Brewed
//

import SwiftUI

struct TagChip: View {
    let label: String
    var selected: Bool = false
    var onTap: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        let content = Text(label)
            .font(BrewedFont.footnote())
            .fontWeight(.medium)
            .foregroundColor(selected ? .white : theme.textSecondary)
            .padding(.horizontal, BrewedSpacing.md)
            .padding(.vertical, BrewedSpacing.sm)
            .background(selected ? theme.accent : theme.surface)
            .clipShape(Capsule())
        
        if let onTap = onTap {
            Button(action: onTap) { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }
}

#Preview("TagChip") {
    HStack(spacing: 8) {
        TagChip(label: "Chocolate")
        TagChip(label: "Floral", selected: true)
        TagChip(label: "Nutty", onTap: {})
    }
    .padding()
}
