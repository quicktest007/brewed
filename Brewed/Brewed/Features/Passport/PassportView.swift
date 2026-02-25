//
//  PassportView.swift
//  Brewed
//
//  Stamps grid by city/neighborhood/roaster. Progress rings. "Next to try" suggestions.
//

import SwiftUI
import MapKit

struct PassportView: View {
    @StateObject private var data = MockDataService.shared
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    private var stampedPlaces: [Place] {
        data.currentUser.stampPlaceIds.compactMap { data.place(id: $0) }
    }
    
    private var placesByCity: [String: [Place]] {
        Dictionary(grouping: stampedPlaces) { $0.city ?? "Unknown" }
    }
    
    private var nextToTry: [Place] {
        data.places.filter { !data.currentUser.stampPlaceIds.contains($0.id) }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if stampedPlaces.isEmpty {
                    EmptyStateView(
                        icon: "star.circle",
                        title: "No stamps yet",
                        message: "Visit coffee shops and add a brew to collect stamps.",
                        actionTitle: "Discover on map",
                        action: {}
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: BrewedSpacing.xl) {
                            // Progress summary
                            progressSection
                            
                            // Stamps by city
                            stampsByCitySection
                            
                            // Next to try
                            if !nextToTry.isEmpty {
                                nextToTrySection
                            }
                        }
                        .padding(BrewedSpacing.lg)
                        .padding(.bottom, BrewedSpacing.xxxl)
                    }
                }
            }
            .background(theme.background)
            .navigationTitle("Passport")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            Text("Your progress")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            
            HStack(spacing: BrewedSpacing.lg) {
                ProgressRing(
                    value: Double(stampedPlaces.count),
                    max: 10,
                    lineWidth: 8,
                    color: theme.accent
                ) {
                    VStack(spacing: 2) {
                        Text("\(stampedPlaces.count)")
                            .font(BrewedFont.title1())
                            .foregroundColor(theme.textPrimary)
                        Text("stamps")
                            .font(BrewedFont.caption())
                            .foregroundColor(theme.textSecondary)
                    }
                }
                .frame(width: 88, height: 88)
                
                VStack(alignment: .leading, spacing: BrewedSpacing.xs) {
                    Text("\(placesByCity.count) cities")
                        .font(BrewedFont.subheadline())
                        .foregroundColor(theme.textPrimary)
                    Text("\(stampedPlaces.count) shops collected")
                        .font(BrewedFont.footnote())
                        .foregroundColor(theme.textSecondary)
                }
                Spacer()
            }
            .padding(BrewedSpacing.lg)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.lg))
        }
    }
    
    private var stampsByCitySection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            Text("Stamps")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            
            ForEach(Array(placesByCity.keys.sorted()), id: \.self) { city in
                VStack(alignment: .leading, spacing: BrewedSpacing.sm) {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 14))
                            .foregroundColor(theme.accent)
                        Text(city)
                            .font(BrewedFont.title3())
                            .foregroundColor(theme.textPrimary)
                        Spacer()
                        Text("\(placesByCity[city]?.count ?? 0)")
                            .font(BrewedFont.footnote())
                            .foregroundColor(theme.textSecondary)
                    }
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 100), spacing: BrewedSpacing.md)
                    ], spacing: BrewedSpacing.md) {
                        ForEach(placesByCity[city] ?? []) { place in
                            StampCard(place: place)
                        }
                    }
                }
                .padding(BrewedSpacing.md)
                .background(theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.lg))
            }
        }
    }
    
    private var nextToTrySection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            Text("Next to try")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            
            VStack(spacing: BrewedSpacing.sm) {
                ForEach(nextToTry.prefix(3)) { place in
                    NextToTryRow(place: place)
                }
            }
        }
    }
}

// MARK: - Progress Ring

struct ProgressRing: View {
    let value: Double
    let max: Double
    let lineWidth: CGFloat
    let color: Color
    let label: () -> AnyView
    
    init<V: View>(
        value: Double,
        max: Double,
        lineWidth: CGFloat = 8,
        color: Color,
        @ViewBuilder label: @escaping () -> V
    ) {
        self.value = value
        self.max = max
        self.lineWidth = lineWidth
        self.color = color
        self.label = { AnyView(label()) }
    }
    
    private var progress: CGFloat {
        guard max > 0 else { return 0 }
        return CGFloat(min(value / max, 1))
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            label()
        }
    }
}

// MARK: - Stamp Card

struct StampCard: View {
    let place: Place
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        VStack(spacing: BrewedSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: BrewedRadius.md)
                    .fill(theme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: BrewedRadius.md)
                            .stroke(theme.accent.opacity(0.4), lineWidth: 1)
                    )
                    .aspectRatio(1, contentMode: .fit)
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(theme.accent)
            }
            Text(place.name)
                .font(BrewedFont.caption())
                .foregroundColor(theme.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

// MARK: - Next to Try Row

struct NextToTryRow: View {
    let place: Place
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        HStack(spacing: BrewedSpacing.md) {
            RoundedRectangle(cornerRadius: BrewedRadius.sm)
                .fill(theme.textTertiary.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "cup.and.saucer")
                        .foregroundColor(theme.textSecondary)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(place.name)
                    .font(BrewedFont.subheadline())
                    .foregroundColor(theme.textPrimary)
                if let neighborhood = place.neighborhood {
                    Text(neighborhood)
                        .font(BrewedFont.caption())
                        .foregroundColor(theme.textSecondary)
                }
            }
            Spacer()
            RatingPill(rating: place.averageRating)
        }
        .padding(BrewedSpacing.md)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
    }
}

#Preview("PassportView") {
    PassportView()
}
