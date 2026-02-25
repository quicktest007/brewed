//
//  Brew.swift
//  Brewed
//
//  A single "brew" post: photo + place (or home) + rating + coffee type + tasting notes.
//

import Foundation
import CoreLocation

struct Brew: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    var placeId: UUID?              // nil = brewed at home
    var imageURL: String?
    var rating: Double
    var tastingNotes: [String]      // e.g. chocolatey, floral
    var brewMethod: BrewMethod       // kept for backward compatibility
    var coffeeType: String?         // e.g. "Latte", "Cold Brew" (drink type)
    var timeOfDay: TimeOfDay?
    var priceTier: PriceTier?
    var caption: String
    var createdAt: Date
    var likes: [UUID]
    var commentCount: Int
    
    init(
        id: UUID = UUID(),
        userId: UUID,
        placeId: UUID? = nil,
        imageURL: String? = nil,
        rating: Double,
        tastingNotes: [String] = [],
        brewMethod: BrewMethod = .espresso,
        coffeeType: String? = nil,
        timeOfDay: TimeOfDay? = nil,
        priceTier: PriceTier? = nil,
        caption: String = "",
        createdAt: Date = Date(),
        likes: [UUID] = [],
        commentCount: Int = 0
    ) {
        self.id = id
        self.userId = userId
        self.placeId = placeId
        self.imageURL = imageURL
        self.rating = rating
        self.tastingNotes = tastingNotes
        self.brewMethod = brewMethod
        self.coffeeType = coffeeType
        self.timeOfDay = timeOfDay
        self.priceTier = priceTier
        self.caption = caption
        self.createdAt = createdAt
        self.likes = likes
        self.commentCount = commentCount
    }
}

// MARK: - Coffee type (drink)

enum CoffeeType: String, CaseIterable, Identifiable {
    case espresso
    case ristretto
    case lungo
    case doppio
    case americano
    case latte
    case cappuccino
    case flatWhite
    case cortado
    case macchiato
    case mocha
    case whiteMocha
    case affogato
    case viennaCoffee
    case coldBrew
    case frappuccino
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .espresso: return "Espresso"
        case .ristretto: return "Ristretto"
        case .lungo: return "Lungo"
        case .doppio: return "Doppio"
        case .americano: return "Americano"
        case .latte: return "Latte"
        case .cappuccino: return "Cappuccino"
        case .flatWhite: return "Flat White"
        case .cortado: return "Cortado"
        case .macchiato: return "Macchiato"
        case .mocha: return "Mocha"
        case .whiteMocha: return "White Mocha"
        case .affogato: return "Affogato"
        case .viennaCoffee: return "Vienna Coffee"
        case .coldBrew: return "Cold Brew"
        case .frappuccino: return "Frappuccino"
        }
    }
}

enum BrewMethod: String, Codable, CaseIterable {
    case espresso
    case pourOver
    case frenchPress
    case aeroPress
    case coldBrew
    case mokaPot
    case drip
    case chemex
    case siphon
    
    var displayName: String {
        switch self {
        case .espresso: return "Espresso"
        case .pourOver: return "Pour Over"
        case .frenchPress: return "French Press"
        case .aeroPress: return "AeroPress"
        case .coldBrew: return "Cold Brew"
        case .mokaPot: return "Moka Pot"
        case .drip: return "Drip"
        case .chemex: return "Chemex"
        case .siphon: return "Siphon"
        }
    }
    
    var iconName: String {
        switch self {
        case .espresso: return "cup.and.saucer.fill"
        case .pourOver: return "drop.fill"
        case .frenchPress: return "frenchpress.fill"
        case .aeroPress: return "wind"
        case .coldBrew: return "snowflake"
        case .mokaPot: return "flame.fill"
        case .drip: return "drop.triangle.fill"
        case .chemex: return "flask.fill"
        case .siphon: return "testtube.2"
        }
    }
}

enum TimeOfDay: String, Codable, CaseIterable {
    case morning
    case midday
    case afternoon
    case evening
    
    var displayName: String {
        rawValue.capitalized
    }
}

enum PriceTier: String, Codable, CaseIterable {
    case budget = "$"
    case moderate = "$$"
    case premium = "$$$"
    
    var displayName: String { rawValue }
}
