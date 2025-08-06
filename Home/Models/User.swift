import Foundation
import CoreLocation

struct User: Identifiable, Codable {
    let id = UUID()
    var name: String
    var email: String
    var avatar: Avatar
    var currentLocation: Location?
    var keyLocations: [KeyLocation]
    var currentActivity: Activity?
    var familyId: String?
    var isOnline: Bool = false
    var lastSeen: Date = Date()
    
    // Privacy settings
    var shareLocation: Bool = true
    var shareBrowsing: Bool = false
    var shareActivity: Bool = true
}

struct Avatar: Codable {
    var name: String = ""
    var skinTone: String = "light"
    var hairStyle: String = "short"
    var hairColor: String = "brown"
    var eyeColor: String = "brown"
    var clothing: String = "casual"
    var accessories: [String] = []
    
    // Bitmoji integration
    var useBitmoji: Bool = false
    var bitmojiAvatarId: String?
    var bitmojiAvatarUrl: String?
    
    // Full body avatar properties
    var bodyType: String = "average"
    var height: String = "average"
    var pose: String = "standing"
    var expression: String = "happy"
    var outfit: String = "casual"
    var shoes: String = "sneakers"
    
    // Animation states
    var isWalking: Bool = false
    var isSitting: Bool = false
    var isWaving: Bool = false
    var isPointing: Bool = false
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let name: String
    let timestamp: Date
}

struct KeyLocation: Identifiable, Codable {
    let id = UUID()
    var name: String
    var type: LocationType
    var latitude: Double
    var longitude: Double
    var radius: Double = 100 // meters
}

enum LocationType: String, CaseIterable, Codable {
    case home = "Home"
    case work = "Work"
    case gym = "Gym"
    case store = "Store"
    case restaurant = "Restaurant"
    case other = "Other"
}

struct Activity: Codable {
    var type: ActivityType
    var title: String
    var details: String?
    var timestamp: Date = Date()
}

enum ActivityType: String, CaseIterable, Codable {
    case watching = "Watching"
    case shopping = "Shopping"
    case working = "Working"
    case exercising = "Exercising"
    case eating = "Eating"
    case relaxing = "Relaxing"
    case other = "Other"
} 