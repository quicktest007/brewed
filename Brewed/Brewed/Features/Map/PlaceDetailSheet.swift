//
//  PlaceDetailSheet.swift
//  Brewed
//
//  Place detail: photos, rating, popular drinks, friend activity, Add Brew.
//

import SwiftUI
import MapKit

struct PlaceDetailSheet: View {
    let place: Place
    let brews: [Brew]
    let onAddBrew: () -> Void
    let onSavePlace: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: BrewedSpacing.xl) {
                    // Hero / image placeholder
                    RoundedRectangle(cornerRadius: BrewedRadius.lg)
                        .fill(theme.surface.opacity(0.6))
                        .frame(height: 180)
                        .overlay(
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 48))
                                .foregroundColor(theme.textSecondary.opacity(0.4))
                        )
                    
                    // Name + rating + meta
                    VStack(alignment: .leading, spacing: BrewedSpacing.sm) {
                        Text(place.name)
                            .font(BrewedFont.title1())
                            .foregroundColor(theme.textPrimary)
                        
                        if let neighborhood = place.neighborhood {
                            Text(neighborhood + (place.city.map { ", \($0)" } ?? ""))
                                .font(BrewedFont.subheadline())
                                .foregroundColor(theme.textSecondary)
                        }
                        
                        HStack(spacing: BrewedSpacing.lg) {
                            RatingPill(rating: place.averageRating)
                            if let tier = place.priceTier {
                                Text(tier.displayName)
                                    .font(BrewedFont.numeric())
                                    .foregroundColor(theme.textSecondary)
                            }
                            if place.openNow == true {
                                HStack(spacing: BrewedSpacing.xs) {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 6, height: 6)
                                    Text("Open now")
                                        .font(BrewedFont.footnote())
                                        .foregroundColor(theme.textSecondary)
                                }
                            }
                        }
                        
                        if !place.vibeTags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: BrewedSpacing.sm) {
                                    ForEach(place.vibeTags, id: \.self) { tag in
                                        TagChip(label: tag)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Mini map
                    Map(position: .constant(.region(MKCoordinateRegion(
                        center: place.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    )))) {
                        Annotation(place.name, coordinate: place.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(theme.accent)
                        }
                    }
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
                    
                    // Recent brews
                    if !brews.isEmpty {
                        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
                            Text("Recent brews")
                                .font(BrewedFont.title3())
                                .foregroundColor(theme.textPrimary)
                            
                            ForEach(brews.prefix(3)) { brew in
                                BrewRowCompact(brew: brew)
                            }
                        }
                    }
                    
                    // Actions
                    VStack(spacing: BrewedSpacing.md) {
                        BrewedButton("Add Brew", style: .primary, action: {
                            onAddBrew()
                            dismiss()
                        })
                        
                        BrewedButton("Save place", style: .secondary, action: {
                            onSavePlace()
                        })
                    }
                    .padding(.top, BrewedSpacing.md)
                }
                .padding(BrewedSpacing.lg)
            }
            .background(theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(theme.accent)
                }
            }
        }
    }
}

struct BrewRowCompact: View {
    let brew: Brew
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        HStack(spacing: BrewedSpacing.md) {
            RatingPill(rating: brew.rating)
            Text(brew.coffeeType ?? brew.brewMethod.displayName)
                .font(BrewedFont.footnote())
                .foregroundColor(theme.textSecondary)
            if !brew.tastingNotes.isEmpty {
                Text(brew.tastingNotes.prefix(2).joined(separator: ", "))
                    .font(BrewedFont.caption())
                    .foregroundColor(theme.textTertiary)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(BrewedSpacing.md)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
    }
}

#Preview("PlaceDetailSheet") {
    PlaceDetailSheet(
        place: Place.mockList[0],
        brews: [],
        onAddBrew: {},
        onSavePlace: {}
    )
}
