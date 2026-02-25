//
//  MockDataService.swift
//  Brewed
//
//  Mock data for Map, Feed, Passport. Design for real API later.
//

import Foundation
import CoreLocation
import Combine

final class MockDataService: ObservableObject {
    static let shared = MockDataService()
    
    @Published var currentUser: AppUser
    @Published var places: [Place] = []
    @Published var brews: [Brew] = []

    init() {
        currentUser = AppUser(
            displayName: "Alex",
            username: "alexbrews",
            tasteTags: ["Chocolate", "Nutty", "Smooth"],
            favoriteBrewMethods: [.pourOver, .espresso],
            stampPlaceIds: [], // Filled after loadMockData so we have place IDs
            savedPlaceIds: []
        )
        loadMockData()
        // Seed passport with first two places so Passport has content
        if currentUser.stampPlaceIds.isEmpty, places.count >= 2 {
            currentUser.stampPlaceIds = [places[0].id, places[1].id]
        }
    }
    
    private func loadMockData() {
        places = Place.mockList
        brews = Brew.mockList(places: places, userId: currentUser.id)
    }
    
    func brews(for placeId: UUID) -> [Brew] {
        brews.filter { $0.placeId == placeId }
    }
    
    func place(id: UUID?) -> Place? {
        guard let id = id else { return nil }
        return places.first { $0.id == id }
    }
    
    func addBrew(_ brew: Brew) {
        brews.insert(brew, at: 0)
    }
    
    func toggleLike(brewId: UUID) {
        guard let i = brews.firstIndex(where: { $0.id == brewId }) else { return }
        if brews[i].likes.contains(currentUser.id) {
            brews[i].likes.removeAll { $0 == currentUser.id }
        } else {
            brews[i].likes.append(currentUser.id)
        }
    }
    
    func savePlace(_ placeId: UUID) {
        if !currentUser.savedPlaceIds.contains(placeId) {
            currentUser.savedPlaceIds.append(placeId)
        }
    }
    
    func addStamp(_ placeId: UUID) {
        if !currentUser.stampPlaceIds.contains(placeId) {
            currentUser.stampPlaceIds.append(placeId)
        }
    }
}

// MARK: - Mock Data

extension Place {
    static var mockList: [Place] {
        [
            Place(
                name: "Sightglass Coffee",
                address: "3014 20th St, San Francisco, CA",
                latitude: 37.7592,
                longitude: -122.4094,
                averageRating: 4.6,
                reviewCount: 342,
                imageURLs: [],
                brewMethods: [.pourOver, .espresso, .drip],
                priceTier: .moderate,
                openNow: true,
                neighborhood: "Mission",
                city: "San Francisco",
                vibeTags: ["minimal", "spacious", "laptop-friendly"]
            ),
            Place(
                name: "Ritual Coffee Roasters",
                address: "1026 Valencia St, San Francisco, CA",
                latitude: 37.7580,
                longitude: -122.4214,
                averageRating: 4.5,
                reviewCount: 218,
                imageURLs: [],
                brewMethods: [.pourOver, .espresso, .aeroPress],
                priceTier: .moderate,
                openNow: true,
                neighborhood: "Mission",
                city: "San Francisco",
                vibeTags: ["cozy", "roaster"]
            ),
            Place(
                name: "Blue Bottle Coffee",
                address: "66 Mint St, San Francisco, CA",
                latitude: 37.7849,
                longitude: -122.4094,
                averageRating: 4.4,
                reviewCount: 520,
                imageURLs: [],
                brewMethods: [.espresso, .pourOver, .coldBrew],
                priceTier: .premium,
                openNow: true,
                neighborhood: "SOMA",
                city: "San Francisco",
                roasterName: "Blue Bottle",
                vibeTags: ["minimal", "premium"]
            ),
            Place(
                name: "Four Barrel Coffee",
                address: "375 Valencia St, San Francisco, CA",
                latitude: 37.7652,
                longitude: -122.4218,
                averageRating: 4.5,
                reviewCount: 189,
                imageURLs: [],
                brewMethods: [.pourOver, .espresso],
                priceTier: .moderate,
                openNow: false,
                neighborhood: "Mission",
                city: "San Francisco",
                vibeTags: ["industrial", "cozy"]
            ),
        ]
    }
}

extension Brew {
    static func mockList(places: [Place], userId: UUID) -> [Brew] {
        guard places.count >= 2 else { return [] }
        return [
            Brew(
                userId: userId,
                placeId: places[0].id,
                imageURL: nil,
                rating: 4.5,
                tastingNotes: ["Chocolate", "Nutty", "Smooth"],
                brewMethod: .pourOver,
                coffeeType: CoffeeType.latte.displayName,
                timeOfDay: .morning,
                priceTier: .moderate,
                caption: "Perfect morning ritual. Single-origin Ethiopian.",
                createdAt: Date().addingTimeInterval(-3600),
                likes: [],
                commentCount: 3
            ),
            Brew(
                userId: userId,
                placeId: places[1].id,
                rating: 4.8,
                tastingNotes: ["Floral", "Citrus", "Bright"],
                brewMethod: .espresso,
                coffeeType: CoffeeType.flatWhite.displayName,
                timeOfDay: .afternoon,
                caption: "Killer flat white. Vibes immaculate.",
                createdAt: Date().addingTimeInterval(-7200),
                likes: [userId],
                commentCount: 1
            ),
        ]
    }
}
