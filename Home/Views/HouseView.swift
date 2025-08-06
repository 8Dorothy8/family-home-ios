import SwiftUI

struct HouseView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var showingLocationSetup = false
    @State private var showingActivityUpdate = false
    @State private var showingPetCare = false
    @State private var showingFamilyActivities = false
    @State private var showingMessages = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Beautiful gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.98, green: 0.98, blue: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // House layout
                    ScrollView([.horizontal, .vertical]) {
                        houseLayoutView
                            .frame(minWidth: 450, minHeight: 700)
                            .padding()
                    }
                    
                    // Bottom toolbar
                    bottomToolbar
                }
            }
            .navigationTitle("Family Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingLocationSetup = true
                    }) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .font(.title3)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingActivityUpdate = true
                    }) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                            .font(.title3)
                    }
                }
            }
        }
        .sheet(isPresented: $showingLocationSetup) {
            LocationSetupView()
        }
        .sheet(isPresented: $showingActivityUpdate) {
            ActivityUpdateView()
        }
        .sheet(isPresented: $showingPetCare) {
            PetCareView()
        }
        .sheet(isPresented: $showingFamilyActivities) {
            FamilyActivitiesView()
        }
        .sheet(isPresented: $showingMessages) {
            MessagesView()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 15) {
            if let family = appState.currentFamily {
                Text(family.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 25) {
                    ForEach(family.members) { member in
                        VStack(spacing: 8) {
                            AvatarView(user: member)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(member.isOnline ? Color.green : Color.gray.opacity(0.3), lineWidth: 3)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            
                            Text(member.name)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    private var houseLayoutView: some View {
        ZStack {
            // House background with realistic floor and walls
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.98, green: 0.96, blue: 0.92), // Warm wall color
                            Color(red: 0.95, green: 0.93, blue: 0.89)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    // Floor pattern
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.85, green: 0.75, blue: 0.65), // Wood floor
                                    Color(red: 0.80, green: 0.70, blue: 0.60)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 200)
                        .position(x: 225, y: 350)
                )
                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
            
            // Rooms with realistic styling
            ForEach(appState.currentFamily?.house.rooms ?? [], id: \.id) { room in
                RoomView(room: room)
            }
            
            // Furniture with realistic styling
            ForEach(appState.currentFamily?.house.furniture ?? [], id: \.id) { furniture in
                FurnitureView(furniture: furniture)
            }
            
            // Family members with improved positioning
            ForEach(appState.currentFamily?.members ?? [], id: \.id) { member in
                FamilyMemberView(member: member)
            }
            
            // Virtual pet
            if let pet = appState.currentFamily?.virtualPet {
                VirtualPetView(pet: pet)
            }
        }
    }
    
    private var bottomToolbar: some View {
        HStack(spacing: 0) {
            ToolbarButton(icon: "phone.fill", title: "Call", color: .green) {
                // Handle call
            }
            
            ToolbarButton(icon: "message.fill", title: "Messages", color: .blue) {
                showingMessages = true
            }
            
            ToolbarButton(icon: "pawprint.fill", title: "Pet", color: .orange) {
                showingPetCare = true
            }
            
            ToolbarButton(icon: "gamecontroller.fill", title: "Activities", color: .purple) {
                showingFamilyActivities = true
            }
            
            ToolbarButton(icon: "calendar", title: "Calendar", color: .red) {
                // Handle calendar
            }
        }
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

struct RoomView: View {
    let room: Room
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(roomGradient)
            .frame(width: room.size.width, height: room.size.height)
            .position(room.position)
            .overlay(
                VStack {
                    Text(room.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.3))
                        )
                }
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var roomGradient: LinearGradient {
        switch room.type {
        case .livingRoom:
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.4, green: 0.6, blue: 0.8), Color(red: 0.3, green: 0.5, blue: 0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .kitchen:
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.9, green: 0.7, blue: 0.5), Color(red: 0.8, green: 0.6, blue: 0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .bedroom:
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.7, green: 0.5, blue: 0.8), Color(red: 0.6, green: 0.4, blue: 0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .bathroom:
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.5, green: 0.8, blue: 0.9), Color(red: 0.4, green: 0.7, blue: 0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .diningRoom:
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.6, green: 0.8, blue: 0.6), Color(red: 0.5, green: 0.7, blue: 0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .office:
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.8, green: 0.7, blue: 0.6), Color(red: 0.7, green: 0.6, blue: 0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .playroom:
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.9, green: 0.6, blue: 0.8), Color(red: 0.8, green: 0.5, blue: 0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct FurnitureView: View {
    let furniture: Furniture
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: furnitureIcon)
                .font(.title)
                .foregroundColor(furnitureColor)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            
            if let activity = furniture.activity {
                Text(activity.title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.black.opacity(0.6))
                    )
            }
        }
        .frame(width: 70, height: 70)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .position(furniture.position)
    }
    
    private var furnitureIcon: String {
        switch furniture.type {
        case .couch:
            return "sofa.fill"
        case .tv:
            return "tv.fill"
        case .diningTable:
            return "table.furniture"
        case .bed:
            return "bed.double.fill"
        case .desk:
            return "desktopcomputer"
        case .chair:
            return "chair.fill"
        case .bookshelf:
            return "books.vertical.fill"
        case .kitchenCounter:
            return "countertop"
        }
    }
    
    private var furnitureColor: Color {
        switch furniture.type {
        case .couch:
            return Color(red: 0.6, green: 0.4, blue: 0.2) // Brown
        case .tv:
            return Color(red: 0.2, green: 0.2, blue: 0.2) // Dark gray
        case .diningTable:
            return Color(red: 0.5, green: 0.3, blue: 0.1) // Wood
        case .bed:
            return Color(red: 0.8, green: 0.8, blue: 0.9) // Light blue
        case .desk:
            return Color(red: 0.4, green: 0.3, blue: 0.2) // Dark wood
        case .chair:
            return Color(red: 0.7, green: 0.5, blue: 0.3) // Light brown
        case .bookshelf:
            return Color(red: 0.3, green: 0.2, blue: 0.1) // Dark wood
        case .kitchenCounter:
            return Color(red: 0.9, green: 0.9, blue: 0.9) // White
        }
    }
}

struct FamilyMemberView: View {
    let member: User
    
    var body: some View {
        VStack(spacing: 6) {
            AvatarView(user: member)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(member.isOnline ? Color.green : Color.gray.opacity(0.3), lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
            
            Text(member.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            if let activity = member.currentActivity {
                Text(activity.title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.1))
                    )
            }
        }
        .position(memberPosition)
    }
    
    private var memberPosition: CGPoint {
        // Better positioning for family members
        let index = member.id.uuidString.hashValue % 4
        switch index {
        case 0:
            return CGPoint(x: 120, y: 180)
        case 1:
            return CGPoint(x: 280, y: 180)
        case 2:
            return CGPoint(x: 120, y: 320)
        default:
            return CGPoint(x: 280, y: 320)
        }
    }
}

struct VirtualPetView: View {
    let pet: VirtualPet
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: petIcon)
                .font(.title)
                .foregroundColor(petColor)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            
            Text(pet.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            // Pet status indicators
            HStack(spacing: 6) {
                StatusIndicator(value: pet.hunger, color: .orange, icon: "fork.knife")
                StatusIndicator(value: pet.happiness, color: .pink, icon: "heart.fill")
                StatusIndicator(value: pet.energy, color: .blue, icon: "bolt.fill")
            }
        }
        .frame(width: 80, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        )
        .position(CGPoint(x: 380, y: 120))
    }
    
    private var petIcon: String {
        switch pet.type {
        case .dog:
            return "dog.fill"
        case .cat:
            return "cat.fill"
        case .bird:
            return "bird.fill"
        case .fish:
            return "fish.fill"
        case .rabbit:
            return "hare.fill"
        case .hamster:
            return "circle.fill" // Using circle as placeholder
        case .turtle:
            return "circle.fill" // Using circle as placeholder
        }
    }
    
    private var petColor: Color {
        switch pet.type {
        case .dog:
            return Color(red: 0.6, green: 0.4, blue: 0.2) // Brown
        case .cat:
            return Color(red: 0.9, green: 0.6, blue: 0.3) // Orange
        case .bird:
            return Color(red: 0.3, green: 0.6, blue: 0.9) // Blue
        case .fish:
            return Color(red: 0.4, green: 0.8, blue: 0.9) // Cyan
        case .rabbit:
            return Color(red: 0.7, green: 0.7, blue: 0.7) // Gray
        case .hamster:
            return Color(red: 0.8, green: 0.5, blue: 0.2) // Orange-brown
        case .turtle:
            return Color(red: 0.3, green: 0.7, blue: 0.3) // Green
        }
    }
}

struct StatusIndicator: View {
    let value: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
            
            Circle()
                .fill(value > 0.3 ? color : Color.gray.opacity(0.3))
                .frame(width: 6, height: 6)
        }
    }
}

struct AvatarView: View {
    let user: User
    
    var body: some View {
        ZStack {
            Circle()
                .fill(avatarGradient)
            
            Image(systemName: "person.fill")
                .font(.title2)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
        }
    }
    
    private var avatarGradient: LinearGradient {
        let colors: [Color] = [
            Color(red: 0.4, green: 0.6, blue: 0.9), // Blue
            Color(red: 0.3, green: 0.8, blue: 0.6), // Green
            Color(red: 0.9, green: 0.6, blue: 0.3), // Orange
            Color(red: 0.8, green: 0.4, blue: 0.8), // Purple
            Color(red: 0.9, green: 0.4, blue: 0.6), // Pink
            Color(red: 0.8, green: 0.3, blue: 0.3)  // Red
        ]
        let index = abs(user.id.uuidString.hashValue) % colors.count
        let color = colors[index]
        
        return LinearGradient(
            gradient: Gradient(colors: [color, color.opacity(0.7)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct ToolbarButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    HouseView()
        .environmentObject(AppStateManager())
} 