//
//  AppUser.swift
//  Brewed
//
//  User model. Taste profile = preferred tags; no follower vanity.
//

import Foundation

struct AppUser: Identifiable, Codable {
    let id: UUID
    var displayName: String
    var username: String
    var profileImageURL: String?
    var bio: String?
    var tasteTags: [String]       // preferred tasting notes
    var favoriteBrewMethods: [BrewMethod]
    var stampPlaceIds: [UUID]     // Passport: places they've brewed at
    var savedPlaceIds: [UUID]
    
    init(
        id: UUID = UUID(),
        displayName: String,
        username: String,
        profileImageURL: String? = nil,
        bio: String? = nil,
        tasteTags: [String] = [],
        favoriteBrewMethods: [BrewMethod] = [],
        stampPlaceIds: [UUID] = [],
        savedPlaceIds: [UUID] = []
    ) {
        self.id = id
        self.displayName = displayName
        self.username = username
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.tasteTags = tasteTags
        self.favoriteBrewMethods = favoriteBrewMethods
        self.stampPlaceIds = stampPlaceIds
        self.savedPlaceIds = savedPlaceIds
    }
}
