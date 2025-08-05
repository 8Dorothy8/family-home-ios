import Foundation
import SwiftUI
import CoreLocation

class AppStateManager: ObservableObject {
    @Published var currentUser: User?
    @Published var currentFamily: Family?
    @Published var isAuthenticated = false
    @Published var isOnboarding = true
    @Published var isLoading = false
    @Published var messages: [Message] = []
    @Published var notifications: [Notification] = []
    
    private let locationManager = CLLocationManager()
    
    init() {
        setupLocationManager()
        loadUserData()
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Authentication
    func createAccount(name: String, email: String, avatar: Avatar) {
        isLoading = true
        
        let newUser = User(
            name: name,
            email: email,
            avatar: avatar,
            keyLocations: []
        )
        
        currentUser = newUser
        saveUserData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.isAuthenticated = true
            self.isOnboarding = false
        }
    }
    
    func signIn(email: String) {
        isLoading = true
        
        // Simulate sign in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.isAuthenticated = true
            self.isOnboarding = false
        }
    }
    
    func signOut() {
        currentUser = nil
        currentFamily = nil
        isAuthenticated = false
        isOnboarding = true
        messages = []
        notifications = []
    }
    
    // MARK: - Family Management
    func createFamily(name: String) {
        guard let user = currentUser else { return }
        
        let newFamily = Family(
            name: name,
            members: [user],
            house: createDefaultHouse(),
            activities: []
        )
        
        currentFamily = newFamily
        saveFamilyData()
    }
    
    func joinFamily(familyId: String) {
        // Simulate joining family
        guard let user = currentUser else { return }
        
        let existingFamily = Family(
            name: "Sample Family",
            members: [user],
            house: createDefaultHouse(),
            activities: []
        )
        
        currentFamily = existingFamily
        saveFamilyData()
    }
    
    func inviteToFamily(email: String) {
        let notification = Notification(
            title: "Family Invitation",
            body: "\(currentUser?.name ?? "Someone") invited you to join their family",
            type: .familyInvite,
            sender: currentUser!
        )
        
        notifications.append(notification)
    }
    
    // MARK: - Location & Activity Updates
    func updateLocation(_ location: Location) {
        guard var user = currentUser else { return }
        user.currentLocation = location
        currentUser = user
        
        let message = Message(
            sender: user,
            content: "I'm at \(location.name)",
            type: .location,
            location: location
        )
        
        messages.append(message)
        saveUserData()
    }
    
    func updateActivity(_ activity: Activity) {
        guard var user = currentUser else { return }
        user.currentActivity = activity
        currentUser = user
        
        let message = Message(
            sender: user,
            content: "I'm \(activity.title.lowercased())",
            type: .activity,
            activity: activity
        )
        
        messages.append(message)
        saveUserData()
    }
    
    func addKeyLocation(_ location: KeyLocation) {
        guard var user = currentUser else { return }
        user.keyLocations.append(location)
        currentUser = user
        saveUserData()
    }
    
    // MARK: - House Management
    func updateHouse(_ house: House) {
        guard var family = currentFamily else { return }
        family.house = house
        currentFamily = family
        saveFamilyData()
    }
    
    func addRoom(_ room: Room) {
        guard var family = currentFamily else { return }
        family.house.rooms.append(room)
        currentFamily = family
        saveFamilyData()
    }
    
    func addFurniture(_ furniture: Furniture) {
        guard var family = currentFamily else { return }
        family.house.furniture.append(furniture)
        currentFamily = family
        saveFamilyData()
    }
    
    // MARK: - Virtual Pet
    func createPet(name: String, type: PetType, personality: PetPersonality) {
        guard var family = currentFamily else { return }
        
        let newPet = VirtualPet(
            name: name,
            type: type,
            personality: personality,
            favoriteFood: getFavoriteFood(for: type),
            favoriteToy: getFavoriteToy(for: type)
        )
        
        family.virtualPet = newPet
        currentFamily = family
        saveFamilyData()
        
        // Add legacy support
        createVirtualPet(name: name, type: type)
    }
    
    func createVirtualPet(name: String, type: PetType) {
        guard var family = currentFamily else { return }
        family.virtualPet = VirtualPet(name: name, type: type)
        currentFamily = family
        saveFamilyData()
    }
    
    func feedPet() {
        guard var family = currentFamily, var pet = family.virtualPet else { return }
        pet.hunger = min(1.0, pet.hunger + 0.3)
        pet.happiness = min(1.0, pet.happiness + 0.1)
        pet.health = min(1.0, pet.health + 0.05)
        pet.lastFed = Date()
        family.virtualPet = pet
        currentFamily = family
        saveFamilyData()
        
        // Add notification
        addNotification(
            title: "Pet Fed!",
            body: "\(pet.name) is feeling better now!",
            type: .petCare
        )
    }
    
    func playWithPet() {
        guard var family = currentFamily, var pet = family.virtualPet else { return }
        pet.happiness = min(1.0, pet.happiness + 0.2)
        pet.energy = max(0.0, pet.energy - 0.1)
        pet.lastPlayed = Date()
        family.virtualPet = pet
        currentFamily = family
        saveFamilyData()
        
        // Add notification
        addNotification(
            title: "Play Time!",
            body: "\(pet.name) had a great time playing!",
            type: .petCare
        )
    }
    
    func trainPet() {
        guard var family = currentFamily, var pet = family.virtualPet else { return }
        pet.training = min(1.0, pet.training + 0.1)
        pet.happiness = min(1.0, pet.happiness + 0.15)
        pet.energy = max(0.0, pet.energy - 0.15)
        pet.lastTrained = Date()
        family.virtualPet = pet
        currentFamily = family
        saveFamilyData()
        
        // Add notification
        addNotification(
            title: "Training Progress!",
            body: "\(pet.name) learned something new!",
            type: .petCare
        )
    }
    
    func restPet() {
        guard var family = currentFamily, var pet = family.virtualPet else { return }
        pet.energy = min(1.0, pet.energy + 0.4)
        pet.health = min(1.0, pet.health + 0.1)
        family.virtualPet = pet
        currentFamily = family
        saveFamilyData()
        
        // Add notification
        addNotification(
            title: "Pet Rested!",
            body: "\(pet.name) is feeling refreshed!",
            type: .petCare
        )
    }
    
    func updatePetAge() {
        guard var family = currentFamily, var pet = family.virtualPet else { return }
        pet.age += 1
        family.virtualPet = pet
        currentFamily = family
        saveFamilyData()
    }
    
    func updatePetStatus() {
        guard var family = currentFamily, var pet = family.virtualPet else { return }
        
        // Gradually decrease stats over time
        let timeSinceLastFed = Date().timeIntervalSince(pet.lastFed)
        let timeSinceLastPlayed = Date().timeIntervalSince(pet.lastPlayed)
        
        // Decrease hunger over time (every hour)
        if timeSinceLastFed > 3600 {
            pet.hunger = max(0.0, pet.hunger - 0.05)
        }
        
        // Decrease happiness if not played with recently
        if timeSinceLastPlayed > 7200 { // 2 hours
            pet.happiness = max(0.0, pet.happiness - 0.03)
        }
        
        // Decrease energy over time
        pet.energy = max(0.0, pet.energy - 0.02)
        
        // Health affects overall well-being
        if pet.hunger < 0.3 || pet.happiness < 0.3 {
            pet.health = max(0.0, pet.health - 0.01)
        }
        
        family.virtualPet = pet
        currentFamily = family
        saveFamilyData()
    }
    
    // Helper methods for pet preferences
    private func getFavoriteFood(for type: PetType) -> String {
        switch type {
        case .dog: return "Dog Treats"
        case .cat: return "Cat Food"
        case .bird: return "Seeds"
        case .fish: return "Fish Flakes"
        case .rabbit: return "Carrots"
        case .hamster: return "Hamster Pellets"
        case .turtle: return "Turtle Food"
        }
    }
    
    private func getFavoriteToy(for type: PetType) -> String {
        switch type {
        case .dog: return "Ball"
        case .cat: return "Laser Pointer"
        case .bird: return "Mirror"
        case .fish: return "Bubble Maker"
        case .rabbit: return "Tunnel"
        case .hamster: return "Wheel"
        case .turtle: return "Rock"
        }
    }
    
    // MARK: - Notifications
    func addNotification(title: String, body: String, type: NotificationType) {
        guard let user = currentUser else { return }
        
        let notification = Notification(
            title: title,
            body: body,
            type: type,
            sender: user
        )
        
        notifications.append(notification)
    }
    
    func markNotificationAsRead(_ notification: Notification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
        }
    }
    
    // MARK: - Family Activities
    func createFamilyActivity(_ activity: FamilyActivity) {
        guard var family = currentFamily else { return }
        family.activities.append(activity)
        currentFamily = family
        saveFamilyData()
    }
    
    // MARK: - Data Persistence
    private func saveUserData() {
        if let user = currentUser,
           let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
    }
    
    private func saveFamilyData() {
        if let family = currentFamily,
           let data = try? JSONEncoder().encode(family) {
            UserDefaults.standard.set(data, forKey: "currentFamily")
        }
    }
    
    private func loadUserData() {
        if let data = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
            isAuthenticated = true
            isOnboarding = false
        }
        
        if let data = UserDefaults.standard.data(forKey: "currentFamily"),
           let family = try? JSONDecoder().decode(Family.self, from: data) {
            currentFamily = family
        }
    }
    
    private func createDefaultHouse() -> House {
        let livingRoom = Room(
            name: "Living Room",
            type: .livingRoom,
            position: CGPoint(x: 0, y: 0),
            size: CGSize(width: 300, height: 200),
            furniture: []
        )
        
        let couch = Furniture(
            name: "Couch",
            type: .couch,
            position: CGPoint(x: 50, y: 100)
        )
        
        let tv = Furniture(
            name: "TV",
            type: .tv,
            position: CGPoint(x: 200, y: 50)
        )
        
        return House(
            rooms: [livingRoom],
            furniture: [couch, tv],
            theme: .modern
        )
    }
} 