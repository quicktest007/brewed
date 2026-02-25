//
//  AppData.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import Foundation
import SwiftUI
import Combine

class AppData: ObservableObject {
    @Published var currentUser: User
    @Published var users: [User] = []
    @Published var posts: [Post] = []
    @Published var coffeeShops: [CoffeeShop] = []
    
    init() {
        // Initialize with sample current user
        self.currentUser = User(
            username: "coffeelover",
            displayName: "Coffee Lover",
            bio: "Passionate about great coffee ☕"
        )
        
        // Sample data
        setupSampleData()
    }
    
    private func setupSampleData() {
        // Sample users
        let user1 = User(username: "barista_jane", displayName: "Jane Smith", bio: "Professional barista", isVerified: true)
        let user2 = User(username: "coffee_explorer", displayName: "Mike Johnson", bio: "Exploring coffee shops worldwide", isVerified: false)
        users = [user1, user2]
        
        // Sample coffee shops (spread around San Francisco area for location testing)
        coffeeShops = [
            CoffeeShop(
                name: "Artisan Roasters",
                address: "123 Main St, San Francisco, CA",
                latitude: 37.7749,
                longitude: -122.4194,
                averageRating: 4.5,
                totalRatings: 120,
                description: "A cozy spot with excellent espresso"
            ),
            CoffeeShop(
                name: "Bean There",
                address: "456 Market St, San Francisco, CA",
                latitude: 37.7849,
                longitude: -122.4094,
                averageRating: 4.2,
                totalRatings: 85,
                description: "Great atmosphere and friendly staff"
            ),
            CoffeeShop(
                name: "Café Mocha",
                address: "789 Mission St, San Francisco, CA",
                latitude: 37.7649,
                longitude: -122.4294,
                averageRating: 4.7,
                totalRatings: 200,
                description: "Premium coffee with a view"
            ),
            CoffeeShop(
                name: "Espresso Express",
                address: "321 Castro St, San Francisco, CA",
                latitude: 37.7600,
                longitude: -122.4350,
                averageRating: 4.3,
                totalRatings: 95,
                description: "Quick service and great coffee"
            ),
            CoffeeShop(
                name: "The Daily Grind",
                address: "555 Union St, San Francisco, CA",
                latitude: 37.8000,
                longitude: -122.4200,
                averageRating: 4.6,
                totalRatings: 150,
                description: "Local favorite with amazing pastries"
            )
        ]
        
        // Sample posts
        posts = [
            Post(
                userId: user1.id,
                coffeeShopId: coffeeShops[0].id,
                coffeeRating: 4.5,
                shopRating: 4.5,
                caption: "Amazing latte art at Artisan Roasters! ☕✨",
                timestamp: Date().addingTimeInterval(-3600),
                likes: [currentUser.id]
            ),
            Post(
                userId: user2.id,
                coffeeShopId: coffeeShops[2].id,
                coffeeRating: 5.0,
                shopRating: 4.7,
                caption: "Perfect cappuccino with the best view in town!",
                timestamp: Date().addingTimeInterval(-7200),
                likes: [currentUser.id, user1.id]
            )
        ]
    }
    
    func addPost(_ post: Post) {
        posts.insert(post, at: 0)
    }
    
    func toggleLike(postId: UUID) {
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            if posts[index].likes.contains(currentUser.id) {
                posts[index].likes.removeAll { $0 == currentUser.id }
            } else {
                posts[index].likes.append(currentUser.id)
            }
        }
    }
    
    func addComment(postId: UUID, text: String) {
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            let comment = Comment(userId: currentUser.id, text: text)
            posts[index].comments.append(comment)
        }
    }
    
    func getUser(by id: UUID) -> User? {
        if id == currentUser.id {
            return currentUser
        }
        return users.first { $0.id == id }
    }
    
    func addFriend(userId: UUID) {
        if !currentUser.friends.contains(userId) {
            currentUser.friends.append(userId)
        }
    }
    
    func rateCoffeeShop(shopId: UUID, rating: Double) {
        if let index = coffeeShops.firstIndex(where: { $0.id == shopId }) {
            let shop = coffeeShops[index]
            let newTotal = shop.totalRatings + 1
            let newAverage = ((shop.averageRating * Double(shop.totalRatings)) + rating) / Double(newTotal)
            coffeeShops[index].averageRating = newAverage
            coffeeShops[index].totalRatings = newTotal
        }
    }
    
    func updateProfileImage(imageURL: String) {
        currentUser.profileImageURL = imageURL
    }
}
