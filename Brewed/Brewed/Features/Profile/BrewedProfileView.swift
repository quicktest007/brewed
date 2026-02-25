//
//  BrewedProfileView.swift
//  Brewed
//
//  Coffee-first profile: taste profile (tag cloud), stats, map of brews.
//

import SwiftUI
import MapKit

struct BrewedProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var data = MockDataService.shared
    @State private var showSettings = false
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    private var myBrews: [Brew] {
        data.brews.filter { $0.userId == data.currentUser.id }
    }
    
    private var averageRating: Double {
        guard !myBrews.isEmpty else { return 0 }
        return myBrews.map(\.rating).reduce(0, +) / Double(myBrews.count)
    }
    
    private var mostVisitedPlace: Place? {
        let withPlace = myBrews.compactMap { brew -> (UUID, Brew)? in
            guard let id = brew.placeId else { return nil }
            return (id, brew)
        }
        let placeCounts = Dictionary(grouping: withPlace, by: \.0).mapValues(\.count)
        guard let topId = placeCounts.max(by: { $0.value < $1.value })?.key else { return nil }
        return data.place(id: topId)
    }
    
    private var topBrewMethod: BrewMethod? {
        let methodCounts = Dictionary(grouping: myBrews, by: \.brewMethod)
            .mapValues(\.count)
        return methodCounts.max(by: { $0.value < $1.value })?.key
    }
    
    private var stampedPlaces: [Place] {
        data.currentUser.stampPlaceIds.compactMap { data.place(id: $0) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: BrewedSpacing.xl) {
                    // Header: name, username, taste profile
                    profileHeader
                    
                    // Stats: avg rating, most visited, top brew method
                    statsSection
                    
                    // Taste profile: tag cloud
                    tasteProfileSection
                    
                    // Map of your brews (compact)
                    if !stampedPlaces.isEmpty {
                        mapOfBrewsSection
                    }
                    
                    // My brews count / recent
                    myBrewsSection
                }
                .padding(BrewedSpacing.lg)
                .padding(.bottom, BrewedSpacing.xxxl)
            }
            .background(theme.background)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(theme.textSecondary)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: BrewedSpacing.md) {
            // Avatar
            ZStack {
                Circle()
                    .fill(theme.accent.opacity(0.2))
                    .frame(width: 80, height: 80)
                Text(data.currentUser.displayName.prefix(1).uppercased())
                    .font(BrewedFont.largeTitle())
                    .foregroundColor(theme.accent)
            }
            VStack(spacing: BrewedSpacing.xs) {
                Text(data.currentUser.displayName)
                    .font(BrewedFont.title2())
                    .foregroundColor(theme.textPrimary)
                Text("@\(data.currentUser.username)")
                    .font(BrewedFont.subheadline())
                    .foregroundColor(theme.textSecondary)
            }
            if let bio = data.currentUser.bio, !bio.isEmpty {
                Text(bio)
                    .font(BrewedFont.body())
                    .foregroundColor(theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(BrewedSpacing.xl)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.lg))
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            Text("Your stats")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: BrewedSpacing.md) {
                StatChip(
                    value: myBrews.isEmpty ? "—" : String(format: "%.1f", averageRating),
                    label: "Avg rating"
                )
                StatChip(
                    value: "\(myBrews.count)",
                    label: "Brews"
                )
                StatChip(
                    value: mostVisitedPlace?.name ?? "—",
                    label: "Most visited",
                    valueIsText: true
                )
                StatChip(
                    value: topBrewMethod?.rawValue ?? "—",
                    label: "Top method",
                    valueIsText: true
                )
            }
            .padding(BrewedSpacing.md)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.lg))
        }
    }
    
    private var tasteProfileSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            Text("Taste profile")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: BrewedSpacing.sm) {
                    ForEach(data.currentUser.tasteTags, id: \.self) { tag in
                        Text(tag)
                            .font(BrewedFont.footnote())
                            .foregroundColor(theme.accent)
                            .padding(.horizontal, BrewedSpacing.md)
                            .padding(.vertical, BrewedSpacing.sm)
                            .background(theme.accent.opacity(0.15))
                            .clipShape(Capsule())
                    }
                    ForEach(data.currentUser.favoriteBrewMethods, id: \.rawValue) { method in
                        Text(method.displayName)
                            .font(BrewedFont.footnote())
                            .foregroundColor(theme.textSecondary)
                            .padding(.horizontal, BrewedSpacing.md)
                            .padding(.vertical, BrewedSpacing.sm)
                            .background(theme.surface)
                            .clipShape(Capsule())
                    }
                }
                .padding(BrewedSpacing.xxs)
            }
            .padding(BrewedSpacing.md)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.lg))
        }
    }
    
    private var mapOfBrewsSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            Text("Where you've brewed")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            
            let region = stampedPlaces.isEmpty ? MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7592, longitude: -122.4094),
                span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            ) : regionForPlaces(stampedPlaces)
            
            Map(position: .constant(.region(region))) {
                ForEach(stampedPlaces) { place in
                    Annotation(place.name, coordinate: place.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(theme.accent)
                    }
                }
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
        }
    }
    
    private func regionForPlaces(_ places: [Place]) -> MKCoordinateRegion {
        guard !places.isEmpty else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7592, longitude: -122.4094),
                span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            )
        }
        let lats = places.map(\.latitude)
        let lons = places.map(\.longitude)
        let minLat = lats.min() ?? 37.75
        let maxLat = lats.max() ?? 37.77
        let minLon = lons.min() ?? -122.43
        let maxLon = lons.max() ?? -122.40
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.4, 0.02),
            longitudeDelta: max((maxLon - minLon) * 1.4, 0.02)
        )
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private var myBrewsSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            HStack {
                Text("My brews")
                    .font(BrewedFont.title3())
                    .foregroundColor(theme.textPrimary)
                Spacer()
                Text("\(myBrews.count)")
                    .font(BrewedFont.footnote())
                    .foregroundColor(theme.textSecondary)
            }
            
            if myBrews.isEmpty {
                Text("No brews yet. Add one from the map or Create.")
                    .font(BrewedFont.subheadline())
                    .foregroundColor(theme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(BrewedSpacing.xl)
                    .background(theme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
            } else {
                VStack(spacing: BrewedSpacing.sm) {
                    ForEach(myBrews.prefix(5)) { brew in
                        BrewRowCompact(brew: brew)
                    }
                }
            }
        }
    }
}

// MARK: - Stat Chip

struct StatChip: View {
    let value: String
    let label: String
    var valueIsText: Bool = false
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        VStack(spacing: BrewedSpacing.xs) {
            Text(value)
                .font(valueIsText ? BrewedFont.caption() : BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
                .lineLimit(valueIsText ? 1 : nil)
            Text(label)
                .font(BrewedFont.caption())
                .foregroundColor(theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("BrewedProfileView") {
    BrewedProfileView()
        .environmentObject(AuthManager())
}
