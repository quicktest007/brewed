//
//  CoffeeCardView.swift
//  Brewed
//
//  Coffee Card: photo, place, rating, tasting notes, brew method, vibe caption.
//  Quick actions: save place, Brew again, comment.
//

import SwiftUI

struct CoffeeCardView: View {
    let brew: Brew
    let place: Place?
    let onLike: () -> Void
    
    @State private var isLiked: Bool = false
    @State private var isSaved: Bool = false
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: BrewedRadius.lg)
                    .fill(theme.surface.opacity(0.8))
                    .frame(height: 220)
                    .overlay(
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 56))
                            .foregroundColor(theme.textSecondary.opacity(0.3))
                    )
                
                // Rating + coffee type overlay
                HStack(spacing: BrewedSpacing.sm) {
                    RatingPill(rating: brew.rating)
                    HStack(spacing: BrewedSpacing.xxs) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 12))
                        Text(brew.coffeeType ?? brew.brewMethod.displayName)
                            .font(BrewedFont.caption())
                    }
                    .foregroundColor(theme.textSecondary)
                    .padding(.horizontal, BrewedSpacing.sm)
                    .padding(.vertical, BrewedSpacing.xs)
                    .background(theme.surface.opacity(0.9))
                    .clipShape(Capsule())
                }
                .padding(BrewedSpacing.md)
            }
            
            // Content
            VStack(alignment: .leading, spacing: BrewedSpacing.md) {
                // Place or "At home"
                if let place = place {
                    Text(place.name)
                        .font(BrewedFont.title3())
                        .foregroundColor(theme.textPrimary)
                    if let neighborhood = place.neighborhood {
                        Text(neighborhood)
                            .font(BrewedFont.footnote())
                            .foregroundColor(theme.textSecondary)
                    }
                } else {
                    Text("At home")
                        .font(BrewedFont.title3())
                        .foregroundColor(theme.textPrimary)
                    Text("Home brew")
                        .font(BrewedFont.footnote())
                        .foregroundColor(theme.textSecondary)
                }
                
                // Tasting tags
                if !brew.tastingNotes.isEmpty {
                    FlowLayout(spacing: BrewedSpacing.sm) {
                        ForEach(brew.tastingNotes, id: \.self) { note in
                            TagChip(label: note)
                        }
                    }
                }
                
                // Caption
                if !brew.caption.isEmpty {
                    Text(brew.caption)
                        .font(BrewedFont.body())
                        .foregroundColor(theme.textPrimary)
                        .lineLimit(3)
                }
                
                // Actions
                HStack(spacing: BrewedSpacing.xl) {
                    Button(action: {
                        isLiked.toggle()
                        onLike()
                    }) {
                        HStack(spacing: BrewedSpacing.xs) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? theme.rating : theme.textSecondary)
                            Text("\(brew.likes.count)")
                                .font(BrewedFont.footnote())
                                .foregroundColor(theme.textSecondary)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {}) {
                        HStack(spacing: BrewedSpacing.xs) {
                            Image(systemName: "bubble.right")
                                .foregroundColor(theme.textSecondary)
                            Text("\(brew.commentCount)")
                                .font(BrewedFont.footnote())
                                .foregroundColor(theme.textSecondary)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { isSaved.toggle() }) {
                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                            .foregroundColor(isSaved ? theme.accent : theme.textSecondary)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button("Brew again") {
                        // Navigate to Add Brew with place pre-filled
                    }
                    .font(BrewedFont.footnote())
                    .fontWeight(.medium)
                    .foregroundColor(theme.accent)
                }
            }
            .padding(BrewedSpacing.lg)
        }
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.lg))
        .shadow(
            color: BrewedShadow.md.color,
            radius: BrewedShadow.md.radius,
            x: BrewedShadow.md.x,
            y: BrewedShadow.md.y
        )
        .onAppear {
            isLiked = brew.likes.contains(data.currentUser.id)
        }
    }
    
    private var data: MockDataService { MockDataService.shared }
}

#Preview("CoffeeCard") {
    CoffeeCardView(
        brew: Brew(
            userId: UUID(),
            placeId: UUID(),
            rating: 4.5,
            tastingNotes: ["Chocolate", "Nutty"],
            brewMethod: .pourOver,
            caption: "Perfect morning ritual."
        ),
        place: Place.mockList.first,
        onLike: {}
    )
    .padding()
}
