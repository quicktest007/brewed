# Brewed — Design Rationale

## Why Not Instagram

Brewed is **discovery-first**, not social-graph-first. We avoid:
- Circular avatars as the main visual language
- Follower counts as primary metrics
- Story-style ephemeral content
- Infinite scroll of undifferentiated photos

Instead: **place + taste + ritual**. The map is the home. The feed is a curated list of “Coffee Cards” — each post is a brew: where, what, how it tasted, how it was made.

## Tab Structure (New IA)

| Tab | Role | Primary action |
|-----|------|----------------|
| **Map** | Discovery home | Browse nearby/trending places, tap pin → place card → “Add Brew” |
| **Feed** | “What’s brewing” | Scroll Coffee Cards, save place, “Brew again”, comment |
| **Create** | “Add Brew” | Step composer: place → photo → rating + notes + tags → publish |
| **Passport** | Collection + light gamification | Stamps by city/neighborhood/roaster, progress, “next to try” |
| **Profile** | You + your taste | Taste profile (tags/radar), map of your brews, stats |

Map is **first** in the tab bar so opening the app = “where can I get great coffee?” not “what did people post?”

## Visual Direction

- **Palette**: Coffee-inspired but modern — deep charcoal and warm stone, not brown overload. Accent: a single warm tone (terracotta/amber) for CTAs and ratings. Cream/off-white backgrounds; dark mode uses true black with warm grays.
- **Typography**: Bold, editorial headlines; clear body; monospace or technical for numbers (rating, price). Dynamic Type supported.
- **Motion**: Restrained. Cards lift on tap; sheets slide; list items stagger on appear. No bouncy cartoon physics.
- **Components**: Reusable Coffee Card, rating pills, tag chips, bottom sheets, toasts. Everything feels like a premium magazine + smart map.

## File Organization

```
Brewed/
  App/           — BrewedApp, entry
  Core/
    Design/      — Theme, tokens, BrewedButton, BrewedCard, RatingPill, TagChip, etc.
    Components/ — BottomSheet, Toast, Skeleton, EmptyState
  Features/
    Map/         — MapDiscoveryView, bottom sheet, place cards, place detail
    Feed/       — FeedView, CoffeeCardView
    Create/     — AddBrewView, step composer
    Passport/   — PassportView, stamps
    Profile/    — ProfileView, taste profile
  Models/       — Brew, Place, User, Tag, Review
  Services/     — MockDataService
```
