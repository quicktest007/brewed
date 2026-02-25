//
//  MapDiscoveryView.swift
//  Brewed
//
//  Primary tab: full-screen map + search + draggable bottom sheet of nearby/trending places.
//

import SwiftUI
import MapKit
import Combine

struct MapDiscoveryView: View {
    @StateObject private var data = MockDataService.shared
    @StateObject private var locationManager = LocationManager()
    
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7592, longitude: -122.4094),
            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        )
    )
    @State private var selectedPlace: Place?
    @State private var showPlaceDetail = false
    @State private var filterOpenNow = false
    @State private var searchText = ""
    @State private var showLocationSearch = false
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Map
            Map(position: $position) {
                ForEach(data.places) { place in
                    Annotation(place.name, coordinate: place.coordinate) {
                        MapPinButton(place: place) {
                            selectedPlace = place
                            showPlaceDetail = true
                        }
                    }
                }
                
                if let loc = locationManager.location {
                    Annotation("You", coordinate: loc.coordinate) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 32, height: 32)
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 16, height: 16)
                        }
                    }
                }
            }
            .mapControls {
                MapCompass()
            }
            .onAppear {
                locationManager.startUpdatingLocation()
            }
            .ignoresSafeArea(edges: .top)
            
            // Top bar: search + location controls
            VStack(spacing: 0) {
                HStack(spacing: BrewedSpacing.sm) {
                    // Search coffee shops
                    HStack(spacing: BrewedSpacing.sm) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(theme.textSecondary)
                        TextField("Search coffee shops", text: $searchText)
                            .font(BrewedFont.body())
                            .foregroundColor(theme.textPrimary)
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                    }
                    .padding(BrewedSpacing.sm)
                    .background(theme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
                    
                    // Move map to location (address search)
                    Button(action: { showLocationSearch = true }) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(theme.accent)
                            .symbolRenderingMode(.hierarchical)
                    }
                    .buttonStyle(.plain)
                    
                    // Center on my location
                    Button(action: centerOnUserLocation) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 22))
                            .foregroundColor(locationManager.location != nil ? theme.accent : theme.textSecondary)
                            .symbolRenderingMode(.hierarchical)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, BrewedSpacing.lg)
                .padding(.vertical, BrewedSpacing.sm)
                .padding(.top, 50)
                .background(
                    LinearGradient(
                        colors: [theme.background.opacity(0.95), theme.background.opacity(0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                Spacer()
            }
            .sheet(isPresented: $showLocationSearch) {
                LocationSearchSheet(
                    region: currentMapRegion,
                    onSelect: { coordinate in
                        position = .region(MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
                        ))
                        showLocationSearch = false
                    }
                )
            }
            
            // Bottom sheet: place list
            VStack(spacing: 0) {
                // Handle
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(theme.textSecondary.opacity(0.4))
                    .frame(width: 36, height: 5)
                    .padding(.top, BrewedSpacing.sm)
                
                // Filters
                HStack(spacing: BrewedSpacing.sm) {
                    FilterChip(title: "Open now", isOn: $filterOpenNow)
                    TagChip(label: "Espresso", onTap: {})
                    TagChip(label: "Pour over", onTap: {})
                }
                .padding(.horizontal, BrewedSpacing.lg)
                .padding(.vertical, BrewedSpacing.md)
                
                // Section header
                HStack {
                    Text(searchText.isEmpty ? "Nearby" : "Results")
                        .font(BrewedFont.title2())
                        .foregroundColor(theme.textPrimary)
                    Spacer()
                    Text("\(filteredPlaces.count) places")
                        .font(BrewedFont.footnote())
                        .foregroundColor(theme.textSecondary)
                }
                .padding(.horizontal, BrewedSpacing.lg)
                .padding(.bottom, BrewedSpacing.sm)
                
                // Place cards
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: BrewedSpacing.md) {
                        ForEach(filteredPlaces) { place in
                            PlaceCardView(place: place, brewCount: data.brews(for: place.id).count) {
                                selectedPlace = place
                                showPlaceDetail = true
                            }
                        }
                    }
                    .padding(.horizontal, BrewedSpacing.lg)
                    .padding(.bottom, BrewedSpacing.xxxl)
                }
                .frame(maxHeight: 320)
            }
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.xxl, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 20, y: -4)
        }
        .sheet(isPresented: $showPlaceDetail) {
            if let place = selectedPlace {
                PlaceDetailSheet(
                    place: place,
                    brews: data.brews(for: place.id),
                    onAddBrew: { showPlaceDetail = false },
                    onSavePlace: { data.savePlace(place.id) }
                )
            }
        }
    }
    
    private var currentMapRegion: MKCoordinateRegion {
        Self.region(from: position) ?? MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7592, longitude: -122.4094),
            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        )
    }
    
    private static func region(from position: MapCameraPosition) -> MKCoordinateRegion? {
        // Extract .region associated value without let binding (avoids expression-context error)
        Mirror(reflecting: position).children
            .first { $0.label == "region" }
            .flatMap { $0.value as? MKCoordinateRegion }
    }
    
    private func centerOnUserLocation() {
        guard let loc = locationManager.location else {
            locationManager.requestLocationPermission()
            return
        }
        withAnimation(.easeInOut(duration: 0.3)) {
            position = .region(MKCoordinateRegion(
                center: loc.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            ))
        }
    }
    
    private var filteredPlaces: [Place] {
        var list = data.places
        if filterOpenNow {
            list = list.filter { $0.openNow == true }
        }
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty { return list }
        return list.filter { place in
            place.name.lowercased().contains(query)
            || (place.neighborhood?.lowercased().contains(query) ?? false)
            || place.address.lowercased().contains(query)
            || (place.city?.lowercased().contains(query) ?? false)
            || (place.roasterName?.lowercased().contains(query) ?? false)
            || place.vibeTags.contains { $0.lowercased().contains(query) }
        }
    }
}

// MARK: - Map Pin

struct MapPinButton: View {
    let place: Place
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(theme.accent)
                Text(place.name)
                    .font(BrewedFont.caption())
                    .foregroundColor(theme.textPrimary)
                    .lineLimit(1)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(theme.surface)
                    .clipShape(Capsule())
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    @Binding var isOn: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            Text(title)
                .font(BrewedFont.footnote())
                .fontWeight(.medium)
                .foregroundColor(isOn ? .white : theme.textSecondary)
                .padding(.horizontal, BrewedSpacing.md)
                .padding(.vertical, BrewedSpacing.sm)
                .background(isOn ? theme.accent : theme.surface)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Place Card (in list)

struct PlaceCardView: View {
    let place: Place
    let brewCount: Int
    let onTap: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: BrewedSpacing.md) {
                // Thumb
                RoundedRectangle(cornerRadius: BrewedRadius.md)
                    .fill(theme.surface.opacity(0.8))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 24))
                            .foregroundColor(theme.textSecondary.opacity(0.6))
                    )
                
                VStack(alignment: .leading, spacing: BrewedSpacing.xs) {
                    Text(place.name)
                        .font(BrewedFont.title3())
                        .foregroundColor(theme.textPrimary)
                        .lineLimit(1)
                    
                    if let neighborhood = place.neighborhood {
                        Text(neighborhood)
                            .font(BrewedFont.footnote())
                            .foregroundColor(theme.textSecondary)
                    }
                    
                    HStack(spacing: BrewedSpacing.sm) {
                        RatingPill(rating: place.averageRating)
                        if let tier = place.priceTier {
                            Text(tier.displayName)
                                .font(BrewedFont.footnote())
                                .foregroundColor(theme.textSecondary)
                        }
                        if brewCount > 0 {
                            Text("\(brewCount) brews")
                                .font(BrewedFont.caption())
                                .foregroundColor(theme.textSecondary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(theme.textTertiary)
            }
            .padding(BrewedSpacing.md)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.lg))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Location search (move map to address)

final class LocationSearchViewModel: NSObject, ObservableObject {
    @Published var completions: [MKLocalSearchCompletion] = []
    @Published var isSearching = false
    
    private let completer = MKLocalSearchCompleter()
    private var region: MKCoordinateRegion
    
    init(region: MKCoordinateRegion) {
        self.region = region
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
    }
    
    func setRegion(_ region: MKCoordinateRegion) {
        self.region = region
        completer.region = region
    }
    
    var queryFragment: String {
        get { completer.queryFragment }
        set { completer.queryFragment = newValue }
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async { [weak self] in
            self?.completions = completer.results
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.completions = []
        }
    }
}

struct LocationSearchSheet: View {
    let region: MKCoordinateRegion
    let onSelect: (CLLocationCoordinate2D) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var query = ""
    @StateObject private var viewModel: LocationSearchViewModel
    
    init(region: MKCoordinateRegion, onSelect: @escaping (CLLocationCoordinate2D) -> Void) {
        self.region = region
        self.onSelect = onSelect
        _viewModel = StateObject(wrappedValue: LocationSearchViewModel(region: region))
    }
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: BrewedSpacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(theme.textSecondary)
                    TextField("Address, city, or place", text: $query)
                        .font(BrewedFont.body())
                        .foregroundColor(theme.textPrimary)
                        .autocorrectionDisabled()
                }
                .padding(BrewedSpacing.md)
                .background(theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
                .padding(.horizontal, BrewedSpacing.lg)
                .padding(.top, BrewedSpacing.sm)
                
                Text("Search for an area to move the map")
                    .font(BrewedFont.footnote())
                    .foregroundColor(theme.textSecondary)
                    .padding(.horizontal, BrewedSpacing.lg)
                    .padding(.top, BrewedSpacing.xs)
                
                if viewModel.isSearching {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, BrewedSpacing.xxl)
                } else if viewModel.completions.isEmpty && !query.isEmpty {
                    Text("No results")
                        .font(BrewedFont.subheadline())
                        .foregroundColor(theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, BrewedSpacing.xxl)
                } else {
                    List {
                        ForEach(Array(viewModel.completions.enumerated()), id: \.offset) { _, completion in
                            Button(action: { selectCompletion(completion) }) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(completion.title)
                                        .font(BrewedFont.subheadline())
                                        .foregroundColor(theme.textPrimary)
                                    if !completion.subtitle.isEmpty {
                                        Text(completion.subtitle)
                                            .font(BrewedFont.caption())
                                            .foregroundColor(theme.textSecondary)
                                    }
                                }
                                .padding(.vertical, BrewedSpacing.xs)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                Spacer(minLength: 0)
            }
            .background(theme.background)
            .navigationTitle("Search location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(theme.accent)
                }
            }
            .onAppear {
                viewModel.setRegion(region)
            }
            .onChange(of: query) { newValue in
                viewModel.queryFragment = newValue
                if newValue.isEmpty {
                    viewModel.completions = []
                }
            }
        }
    }
    
    private func selectCompletion(_ completion: MKLocalSearchCompletion) {
        viewModel.isSearching = true
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        let onSelectCallback = onSelect
        let viewModelRef = viewModel
        search.start { response, error in
            DispatchQueue.main.async {
                viewModelRef.isSearching = false
                guard let item = response?.mapItems.first,
                      error == nil else { return }
                onSelectCallback(item.placemark.coordinate)
            }
        }
    }
}

#Preview("MapDiscovery") {
    MapDiscoveryView()
}
