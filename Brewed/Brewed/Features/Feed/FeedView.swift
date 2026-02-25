//
//  FeedView.swift
//  Brewed
//
//  Feed = Coffee Cards + short text + tags. Discovery and taste, not follower vanity.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var data = MockDataService.shared
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        NavigationStack {
            Group {
                if data.brews.isEmpty {
                    EmptyStateView(
                        icon: "cup.and.saucer",
                        title: "No brews yet",
                        message: "Add your first brew or discover places on the map.",
                        actionTitle: "Discover on map",
                        action: {}
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: BrewedSpacing.lg) {
                            ForEach(Array(data.brews.enumerated()), id: \.element.id) { index, brew in
                                CoffeeCardView(brew: brew, place: data.place(id: brew.placeId)) {
                                    data.toggleLike(brewId: brew.id)
                                }
                                .opacity(1)
                                .offset(y: 0)
                            }
                        }
                        .padding(BrewedSpacing.lg)
                        .padding(.bottom, BrewedSpacing.xxxl)
                    }
                }
            }
            .background(theme.background)
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview("FeedView") {
    FeedView()
}
