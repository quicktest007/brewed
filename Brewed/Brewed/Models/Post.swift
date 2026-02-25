//
//  Post.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let coffeeShopId: UUID?
    let imageURL: String?
    let coffeeRating: Double
    let shopRating: Double?
    let caption: String
    let timestamp: Date
    var likes: [UUID] // User IDs who liked
    var comments: [Comment]
    
    init(id: UUID = UUID(), userId: UUID, coffeeShopId: UUID? = nil, imageURL: String? = nil, coffeeRating: Double, shopRating: Double? = nil, caption: String, timestamp: Date = Date(), likes: [UUID] = [], comments: [Comment] = []) {
        self.id = id
        self.userId = userId
        self.coffeeShopId = coffeeShopId
        self.imageURL = imageURL
        self.coffeeRating = coffeeRating
        self.shopRating = shopRating
        self.caption = caption
        self.timestamp = timestamp
        self.likes = likes
        self.comments = comments
    }
}

struct Comment: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let text: String
    let timestamp: Date
    
    init(id: UUID = UUID(), userId: UUID, text: String, timestamp: Date = Date()) {
        self.id = id
        self.userId = userId
        self.text = text
        self.timestamp = timestamp
    }
}
