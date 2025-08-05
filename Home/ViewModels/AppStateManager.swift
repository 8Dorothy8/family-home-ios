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
    func createVirtualPet(name: String, type: PetType) {
        guard var family = currentFamily else { return }
        family.virtualPet = VirtualPet(name: name, type: type)
        currentFamily = family
        saveFamilyData()
    }
    
    func feedPet() {
        guard var family = currentFamily, var pet = family.virtualPet else { return }
        pet.hunger = min(1.0, pet.hunger + 0.3)
        pet.lastFed = Date()
        family.virtualPet = pet
        currentFamily = family
        saveFamilyData()
    }
    
    func playWithPet() {
        guard var family = currentFamily, var pet = family.virtualPet else { return }
        pet.happiness = min(1.0, pet.happiness + 0.2)
        pet.energy = max(0.0, pet.energy - 0.1)
        pet.lastPlayed = Date()
        family.virtualPet = pet
        currentFamily = family
        saveFamilyData()
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