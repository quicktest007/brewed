//
//  CoffeeShop.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import Foundation
import CoreLocation

struct CoffeeShop: Identifiable, Codable {
    let id: UUID
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var averageRating: Double
    var totalRatings: Int
    var imageURL: String?
    var description: String
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(id: UUID = UUID(), name: String, address: String, latitude: Double, longitude: Double, averageRating: Double = 0.0, totalRatings: Int = 0, imageURL: String? = nil, description: String = "") {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.averageRating = averageRating
        self.totalRatings = totalRatings
        self.imageURL = imageURL
        self.description = description
    }
}
