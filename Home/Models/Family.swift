import Foundation

struct Family: Identifiable, Codable {
    let id = UUID()
    var name: String
    var members: [User]
    var house: House
    var virtualPet: VirtualPet?
    var activities: [FamilyActivity]
    var createdAt: Date = Date()
}

struct House: Codable {
    var rooms: [Room]
    var furniture: [Furniture]
    var theme: HouseTheme = .modern
    var name: String = "Family Home"
}

struct Room: Identifiable, Codable {
    let id = UUID()
    var name: String
    var type: RoomType
    var position: CGPoint
    var size: CGSize
    var furniture: [Furniture]
}

enum RoomType: String, CaseIterable, Codable {
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case bedroom = "Bedroom"
    case bathroom = "Bathroom"
    case diningRoom = "Dining Room"
    case office = "Office"
    case playroom = "Playroom"
}

struct Furniture: Identifiable, Codable {
    let id = UUID()
    var name: String
    var type: FurnitureType
    var position: CGPoint
    var isOccupied: Bool = false
    var occupiedBy: User?
    var activity: Activity?
}

enum FurnitureType: String, CaseIterable, Codable {
    case couch = "Couch"
    case tv = "TV"
    case diningTable = "Dining Table"
    case bed = "Bed"
    case desk = "Desk"
    case chair = "Chair"
    case bookshelf = "Bookshelf"
    case kitchenCounter = "Kitchen Counter"
}

enum HouseTheme: String, CaseIterable, Codable {
    case modern = "Modern"
    case cozy = "Cozy"
    case minimalist = "Minimalist"
    case rustic = "Rustic"
    case colorful = "Colorful"
}

struct VirtualPet: Codable {
    var name: String
    var type: PetType
    var happiness: Double = 0.5
    var hunger: Double = 0.5
    var energy: Double = 1.0
    var health: Double = 1.0
    var training: Double = 0.0
    var age: Int = 0 // in days
    var personality: PetPersonality = .friendly
    var lastFed: Date = Date()
    var lastPlayed: Date = Date()
    var lastTrained: Date = Date()
    var createdAt: Date = Date()
    var favoriteToy: String = "Ball"
    var favoriteFood: String = "Pet Food"
}

enum PetType: String, CaseIterable, Codable {
    case dog = "Dog"
    case cat = "Cat"
    case bird = "Bird"
    case fish = "Fish"
    case rabbit = "Rabbit"
    case hamster = "Hamster"
    case turtle = "Turtle"
}

enum PetPersonality: String, CaseIterable, Codable {
    case friendly = "Friendly"
    case shy = "Shy"
    case energetic = "Energetic"
    case lazy = "Lazy"
    case curious = "Curious"
    case protective = "Protective"
}

struct FamilyActivity: Identifiable, Codable {
    let id = UUID()
    var type: FamilyActivityType
    var title: String
    var description: String
    var participants: [User]
    var startTime: Date
    var endTime: Date?
    var isCompleted: Bool = false
}

enum FamilyActivityType: String, CaseIterable, Codable {
    case dinner = "Dinner Together"
    case puzzle = "Puzzle"
    case movie = "Movie Night"
    case game = "Game Night"
    case petCare = "Pet Care"
    case other = "Other"
} 