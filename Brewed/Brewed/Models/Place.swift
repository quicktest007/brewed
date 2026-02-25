//
//  Place.swift
//  Brewed
//
//  A coffee shop / venue. Used for map pins and place cards.
//

import Foundation
import CoreLocation

struct Place: Identifiable, Codable {
    let id: UUID
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var averageRating: Double
    var reviewCount: Int
    var imageURLs: [String]
    var brewMethods: [BrewMethod]
    var priceTier: PriceTier?
    var openNow: Bool?
    var neighborhood: String?
    var city: String?
    var roasterName: String?
    var vibeTags: [String]   // e.g. "cozy", "minimal", "laptop-friendly"
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
        averageRating: Double = 0,
        reviewCount: Int = 0,
        imageURLs: [String] = [],
        brewMethods: [BrewMethod] = [],
        priceTier: PriceTier? = nil,
        openNow: Bool? = nil,
        neighborhood: String? = nil,
        city: String? = nil,
        roasterName: String? = nil,
        vibeTags: [String] = []
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.averageRating = averageRating
        self.reviewCount = reviewCount
        self.imageURLs = imageURLs
        self.brewMethods = brewMethods
        self.priceTier = priceTier
        self.openNow = openNow
        self.neighborhood = neighborhood
        self.city = city
        self.roasterName = roasterName
        self.vibeTags = vibeTags
    }
}
