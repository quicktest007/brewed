//
//  User.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var username: String
    var displayName: String
    var profileImageURL: String?
    var bio: String
    var friends: [UUID]
    var isVerified: Bool
    
    init(id: UUID = UUID(), username: String, displayName: String, profileImageURL: String? = nil, bio: String = "", friends: [UUID] = [], isVerified: Bool = false) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.friends = friends
        self.isVerified = isVerified
    }
}
