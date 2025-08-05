import Foundation

struct Message: Identifiable, Codable {
    let id = UUID()
    var sender: User
    var content: String
    var type: MessageType
    var timestamp: Date = Date()
    var isRead: Bool = false
    var location: Location?
    var activity: Activity?
}

enum MessageType: String, CaseIterable, Codable {
    case text = "Text"
    case location = "Location"
    case activity = "Activity"
    case notification = "Notification"
    case arrival = "Arrival"
    case departure = "Departure"
}

struct Notification: Identifiable, Codable {
    let id = UUID()
    var title: String
    var body: String
    var type: NotificationType
    var sender: User
    var timestamp: Date = Date()
    var isRead: Bool = false
    var actionRequired: Bool = false
}

enum NotificationType: String, CaseIterable, Codable {
    case locationUpdate = "Location Update"
    case activityUpdate = "Activity Update"
    case familyInvite = "Family Invite"
    case petCare = "Pet Care"
    case familyActivity = "Family Activity"
    case arrival = "Arrival"
    case departure = "Departure"
} 