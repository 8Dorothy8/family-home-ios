import SwiftUI

struct HouseView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var showingLocationSetup = false
    @State private var showingActivityUpdate = false
    @State private var showingPetCare = false
    @State private var showingFamilyActivities = false
    @State private var showingMessages = false
    @State private var showingCalendar = false
    @State private var showingCall = false
    @State private var selectedRoom: RoomType? = nil
    @State private var showingRoomDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gather Town style background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.90, green: 0.94, blue: 0.98)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Gather Town style house map
                    ScrollView([.horizontal, .vertical]) {
                        gatherTownMapView
                            .frame(minWidth: 600, minHeight: 800)
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
        .sheet(isPresented: $showingCalendar) {
            CalendarView()
        }
        .sheet(isPresented: $showingCall) {
            CallView()
        }
        .sheet(isPresented: $showingRoomDetail) {
            if let roomType = selectedRoom {
                RoomDetailView(roomType: roomType)
            }
        }
    }
    
    private var gatherTownMapView: some View {
        ZStack {
            // Large floor area (Gather Town style)
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.92, green: 0.90, blue: 0.85), // Warm wood
                            Color(red: 0.88, green: 0.86, blue: 0.81)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 550, height: 750)
                .overlay(
                    // Subtle grid pattern like Gather Town
                    Path { path in
                        for i in stride(from: 0, through: 550, by: 50) {
                            path.move(to: CGPoint(x: i, y: 0))
                            path.addLine(to: CGPoint(x: i, y: 750))
                        }
                        for i in stride(from: 0, through: 750, by: 50) {
                            path.move(to: CGPoint(x: 0, y: i))
                            path.addLine(to: CGPoint(x: 550, y: i))
                        }
                    }
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
            
            // Room icons positioned like Gather Town
            VStack(spacing: 80) {
                // Top row
                HStack(spacing: 100) {
                    // Living Room
                    GatherTownRoomIcon(
                        roomType: .livingRoom,
                        title: "Living Room",
                        subtitle: "TV & Games",
                        icon: "tv.fill",
                        color: .blue,
                        position: CGPoint(x: 150, y: 120)
                    ) {
                        selectedRoom = .livingRoom
                        showingRoomDetail = true
                    }
                    
                    // Kitchen
                    GatherTownRoomIcon(
                        roomType: .kitchen,
                        title: "Kitchen",
                        subtitle: "Cooking",
                        icon: "flame.fill",
                        color: .orange,
                        position: CGPoint(x: 400, y: 120)
                    ) {
                        selectedRoom = .kitchen
                        showingRoomDetail = true
                    }
                }
                
                // Middle row
                HStack(spacing: 100) {
                    // Dining Room
                    GatherTownRoomIcon(
                        roomType: .diningRoom,
                        title: "Dining Room",
                        subtitle: "Family Meals",
                        icon: "table.furniture",
                        color: .green,
                        position: CGPoint(x: 150, y: 300)
                    ) {
                        selectedRoom = .diningRoom
                        showingRoomDetail = true
                    }
                    
                    // Bedroom
                    GatherTownRoomIcon(
                        roomType: .bedroom,
                        title: "Bedroom",
                        subtitle: "Sleep & Rest",
                        icon: "bed.double.fill",
                        color: .purple,
                        position: CGPoint(x: 400, y: 300)
                    ) {
                        selectedRoom = .bedroom
                        showingRoomDetail = true
                    }
                }
                
                // Bottom row
                HStack(spacing: 100) {
                    // Office
                    GatherTownRoomIcon(
                        roomType: .office,
                        title: "Office",
                        subtitle: "Work & Study",
                        icon: "desktopcomputer",
                        color: .gray,
                        position: CGPoint(x: 150, y: 480)
                    ) {
                        selectedRoom = .office
                        showingRoomDetail = true
                    }
                    
                    // Playroom
                    GatherTownRoomIcon(
                        roomType: .playroom,
                        title: "Playroom",
                        subtitle: "Games & Fun",
                        icon: "gamecontroller.fill",
                        color: .pink,
                        position: CGPoint(x: 400, y: 480)
                    ) {
                        selectedRoom = .playroom
                        showingRoomDetail = true
                    }
                }
            }
            
            // Family members as avatars (like Gather Town)
            ForEach(appState.familyMembers, id: \.id) { member in
                FamilyMemberAvatar(member: member)
                    .position(memberAvatarPosition(for: member))
            }
            
            // Virtual pet
            if let pet = appState.virtualPet {
                VirtualPetAvatar(pet: pet)
                    .position(CGPoint(x: 500, y: 200))
            }
            
            // Activity indicators
            ForEach(appState.familyMembers.filter { $0.currentActivity != nil }, id: \.id) { member in
                if let activity = member.currentActivity {
                    ActivityBubble(activity: activity)
                        .position(activityBubblePosition(for: member))
                }
            }
        }
        .frame(width: 550, height: 750)
    }
    
    private func memberAvatarPosition(for member: User) -> CGPoint {
        // Position family members near their current activity room
        let basePositions: [CGPoint] = [
            CGPoint(x: 150, y: 120), // Living room
            CGPoint(x: 400, y: 120), // Kitchen
            CGPoint(x: 150, y: 300), // Dining room
            CGPoint(x: 400, y: 300), // Bedroom
            CGPoint(x: 150, y: 480), // Office
            CGPoint(x: 400, y: 480)  // Playroom
        ]
        
        let index = member.id.uuidString.hashValue % basePositions.count
        let basePosition = basePositions[index]
        
        // Add some random offset for natural positioning
        let offsetX = CGFloat(member.id.uuidString.hashValue % 60) - 30
        let offsetY = CGFloat(member.id.uuidString.hashValue % 40) - 20
        
        return CGPoint(x: basePosition.x + offsetX, y: basePosition.y + offsetY)
    }
    
    private func activityBubblePosition(for member: User) -> CGPoint {
        let memberPos = memberAvatarPosition(for: member)
        return CGPoint(x: memberPos.x, y: memberPos.y - 50)
    }
    
    private var bottomToolbar: some View {
        HStack(spacing: 0) {
            ToolbarButton(icon: "phone.fill", title: "Call", color: .green) {
                showingCall = true
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
                showingCalendar = true
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

// Gather Town style room icon
struct GatherTownRoomIcon: View {
    let roomType: RoomType
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let position: CGPoint
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Room icon with background
                ZStack {
                    // Background circle
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(0.9),
                                    color.opacity(0.7)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    // Icon
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                }
                .scaleEffect(isPressed ? 0.95 : (isHovered ? 1.05 : 1.0))
                .animation(.easeInOut(duration: 0.2), value: isPressed)
                .animation(.easeInOut(duration: 0.3), value: isHovered)
                
                // Room title
                VStack(spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .position(position)
        .onHover { hovering in
            isHovered = hovering
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// Family member avatar for Gather Town style
struct FamilyMemberAvatar: View {
    let member: User
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 6) {
            // Avatar circle
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                member.isOnline ? Color.green.opacity(0.8) : Color.gray.opacity(0.6),
                                member.isOnline ? Color.green.opacity(0.6) : Color.gray.opacity(0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                // Avatar image or initials
                if member.avatar.useBitmoji, let bitmojiUrl = member.avatar.bitmojiAvatarUrl {
                    AsyncImage(url: URL(string: bitmojiUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Text(String(member.name.prefix(1)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                } else {
                    Text(String(member.name.prefix(1)))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                // Online indicator
                if member.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .offset(x: 18, y: -18)
                }
            }
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
            
            // Name
            Text(member.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// Virtual pet avatar
struct VirtualPetAvatar: View {
    let pet: VirtualPet
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 6) {
            // Pet icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.orange.opacity(0.8),
                                Color.orange.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 45, height: 45)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Image(systemName: petIcon)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            // Pet name
            Text(pet.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                )
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private var petIcon: String {
        switch pet.type {
        case .cat: return "pawprint.fill"
        case .dog: return "pawprint.fill"
        case .bird: return "bird.fill"
        case .fish: return "fish.fill"
        case .rabbit: return "hare.fill"
        case .hamster: return "pawprint.fill"
        case .turtle: return "tortoise.fill"
        }
    }
}

// Activity bubble
struct ActivityBubble: View {
    let activity: Activity
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: activityIcon)
                .font(.caption)
                .foregroundColor(.white)
            
            Text(activity.title)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.7))
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
        )
    }
    
    private var activityIcon: String {
        switch activity.type {
        case .watching: return "tv"
        case .shopping: return "cart"
        case .working: return "laptopcomputer"
        case .exercising: return "figure.run"
        case .eating: return "fork.knife"
        case .relaxing: return "bed.double"
        case .other: return "ellipsis"
        }
    }
}

// Room detail view
struct RoomDetailView: View {
    let roomType: RoomType
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Room header
                VStack(spacing: 12) {
                    Image(systemName: roomIcon)
                        .font(.system(size: 60))
                        .foregroundColor(roomColor)
                    
                    Text(roomTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(roomDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                
                // Room features
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(roomFeatures, id: \.self) { feature in
                        FeatureCard(feature: feature)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Room Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private var roomIcon: String {
        switch roomType {
        case .livingRoom: return "tv.fill"
        case .kitchen: return "flame.fill"
        case .diningRoom: return "table.furniture"
        case .bedroom: return "bed.double.fill"
        case .bathroom: return "shower.fill"
        case .office: return "desktopcomputer"
        case .playroom: return "gamecontroller.fill"
        }
    }
    
    private var roomColor: Color {
        switch roomType {
        case .livingRoom: return .blue
        case .kitchen: return .orange
        case .diningRoom: return .green
        case .bedroom: return .purple
        case .bathroom: return .cyan
        case .office: return .gray
        case .playroom: return .pink
        }
    }
    
    private var roomTitle: String {
        switch roomType {
        case .livingRoom: return "Living Room"
        case .kitchen: return "Kitchen"
        case .diningRoom: return "Dining Room"
        case .bedroom: return "Bedroom"
        case .bathroom: return "Bathroom"
        case .office: return "Office"
        case .playroom: return "Playroom"
        }
    }
    
    private var roomDescription: String {
        switch roomType {
        case .livingRoom: return "The heart of the home where family gathers for entertainment, games, and relaxation."
        case .kitchen: return "Where delicious meals are prepared and family cooking adventures happen."
        case .diningRoom: return "The perfect place for family meals, conversations, and celebrations."
        case .bedroom: return "A peaceful retreat for rest, sleep, and personal time."
        case .bathroom: return "Essential space for daily routines and self-care."
        case .office: return "Dedicated workspace for productivity, study, and focused activities."
        case .playroom: return "Fun-filled space for games, creativity, and family entertainment."
        }
    }
    
    private var roomFeatures: [String] {
        switch roomType {
        case .livingRoom: return ["TV & Entertainment", "Comfortable Seating", "Family Games", "Relaxation Space"]
        case .kitchen: return ["Cooking Equipment", "Family Meals", "Recipe Sharing", "Kitchen Activities"]
        case .diningRoom: return ["Family Dinners", "Conversations", "Celebrations", "Meal Planning"]
        case .bedroom: return ["Rest & Sleep", "Personal Space", "Storage", "Privacy"]
        case .bathroom: return ["Daily Routines", "Self-Care", "Hygiene", "Relaxation"]
        case .office: return ["Work Space", "Study Area", "Productivity", "Focus Time"]
        case .playroom: return ["Games & Toys", "Creative Activities", "Family Fun", "Entertainment"]
        }
    }
}

// Feature card for room details
struct FeatureCard: View {
    let feature: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: featureIcon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(feature)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var featureIcon: String {
        switch feature {
        case let f where f.contains("TV"): return "tv"
        case let f where f.contains("Seating"): return "sofa.fill"
        case let f where f.contains("Games"): return "gamecontroller.fill"
        case let f where f.contains("Cooking"): return "flame.fill"
        case let f where f.contains("Meals"): return "fork.knife"
        case let f where f.contains("Sleep"): return "bed.double.fill"
        case let f where f.contains("Work"): return "laptopcomputer"
        case let f where f.contains("Games"): return "gamecontroller.fill"
        default: return "star.fill"
        }
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
    @State private var isAnimating = false
    @State private var blinkState = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Status levels above the pet
            HStack(spacing: 8) {
                StatusIndicator(value: pet.hunger, color: .orange, icon: "fork.knife")
                StatusIndicator(value: pet.happiness, color: .pink, icon: "heart.fill")
                StatusIndicator(value: pet.energy, color: .blue, icon: "bolt.fill")
                StatusIndicator(value: pet.health, color: .green, icon: "cross.fill")
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6).opacity(0.8))
            )
            
            // Animated cat graphic
            ZStack {
                // Cat body
                Ellipse()
                    .fill(catBodyColor)
                    .frame(width: 60, height: 40)
                    .offset(y: 2)
                
                // Cat head
                Circle()
                    .fill(catHeadColor)
                    .frame(width: 50, height: 50)
                
                // Cat ears
                HStack(spacing: 20) {
                    Triangle()
                        .fill(catEarColor)
                        .frame(width: 12, height: 8)
                        .offset(x: -8, y: -15)
                    
                    Triangle()
                        .fill(catEarColor)
                        .frame(width: 12, height: 8)
                        .offset(x: 8, y: -15)
                }
                
                // Cat eyes
                HStack(spacing: 12) {
                    // Left eye
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 12, height: 12)
                        
                        Circle()
                            .fill(.black)
                            .frame(width: 6, height: 6)
                            .offset(x: -1, y: -1)
                        
                        // Blinking animation
                        if blinkState {
                            Rectangle()
                                .fill(.black)
                                .frame(width: 12, height: 2)
                                .offset(y: -1)
                        }
                    }
                    
                    // Right eye
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 12, height: 12)
                        
                        Circle()
                            .fill(.black)
                            .frame(width: 6, height: 6)
                            .offset(x: -1, y: -1)
                        
                        // Blinking animation
                        if blinkState {
                            Rectangle()
                                .fill(.black)
                                .frame(width: 12, height: 2)
                                .offset(y: -1)
                        }
                    }
                }
                .offset(y: -2)
                
                // Cat nose
                Triangle()
                    .fill(.pink)
                    .frame(width: 4, height: 3)
                    .offset(y: 4)
                    .rotationEffect(.degrees(180))
                
                // Cat mouth
                Path { path in
                    path.move(to: CGPoint(x: -4, y: 8))
                    path.addQuadCurve(to: CGPoint(x: 4, y: 8), control: CGPoint(x: 0, y: 12))
                }
                .stroke(Color.black, lineWidth: 1)
                .offset(y: 6)
                
                // Cat whiskers
                HStack(spacing: 20) {
                    // Left whiskers
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 8, height: 1)
                            .offset(x: -4)
                        Rectangle()
                            .fill(.white)
                            .frame(width: 6, height: 1)
                            .offset(x: -3, y: 1)
                        Rectangle()
                            .fill(.white)
                            .frame(width: 6, height: 1)
                            .offset(x: -3, y: -1)
                    }
                    
                    // Right whiskers
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 8, height: 1)
                            .offset(x: 4)
                        Rectangle()
                            .fill(.white)
                            .frame(width: 6, height: 1)
                            .offset(x: 3, y: 1)
                        Rectangle()
                            .fill(.white)
                            .frame(width: 6, height: 1)
                            .offset(x: 3, y: -1)
                    }
                }
                .offset(y: 2)
                
                // Tail (animated)
                Path { path in
                    path.move(to: CGPoint(x: 25, y: 0))
                    path.addCurve(
                        to: CGPoint(x: 35, y: -10),
                        control1: CGPoint(x: 30, y: -5),
                        control2: CGPoint(x: 35, y: -10)
                    )
                }
                .stroke(catTailColor, lineWidth: 3)
                .rotationEffect(.degrees(isAnimating ? 10 : -10))
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
            }
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isAnimating)
            
            // Pet name
            Text(pet.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6).opacity(0.8))
                )
        }
        .position(CGPoint(x: 380, y: 120))
        .onAppear {
            isAnimating = true
            startBlinking()
        }
    }
    
    private func startBlinking() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.1)) {
                blinkState = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    blinkState = false
                }
            }
        }
    }
    
    // Cat color variations based on pet type
    private var catHeadColor: Color {
        switch pet.type {
        case .cat:
            return Color(red: 0.9, green: 0.6, blue: 0.3) // Orange cat
        case .dog:
            return Color(red: 0.6, green: 0.4, blue: 0.2) // Brown dog
        case .bird:
            return Color(red: 0.3, green: 0.6, blue: 0.9) // Blue bird
        case .fish:
            return Color(red: 0.4, green: 0.8, blue: 0.9) // Cyan fish
        case .rabbit:
            return Color(red: 0.7, green: 0.7, blue: 0.7) // Gray rabbit
        case .hamster:
            return Color(red: 0.8, green: 0.5, blue: 0.2) // Orange-brown hamster
        case .turtle:
            return Color(red: 0.3, green: 0.7, blue: 0.3) // Green turtle
        }
    }
    
    private var catBodyColor: Color {
        catHeadColor.opacity(0.8)
    }
    
    private var catEarColor: Color {
        catHeadColor.opacity(0.7)
    }
    
    private var catTailColor: Color {
        catHeadColor.opacity(0.9)
    }
}

// Custom triangle shape for cat ears and nose
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct StatusIndicator: View {
    let value: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            
            // Progress bar
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 12, height: 3)
                .overlay(
                    Rectangle()
                        .fill(value > 0.3 ? color : Color.gray.opacity(0.5))
                        .frame(width: 12 * value, height: 3)
                        .animation(.easeInOut(duration: 0.5), value: value)
                )
                .cornerRadius(1.5)
        }
    }
}

struct AvatarView: View {
    let user: User
    @State private var isAnimating = false
    @State private var currentPose: String = "standing"
    
    var body: some View {
        VStack(spacing: 4) {
            // Full body avatar
            ZStack {
                // Avatar body
                fullBodyAvatar
                
                // Activity indicator
                if let activity = user.currentActivity {
                    activityIndicator(for: activity)
                }
                
                // Online status indicator
                if user.isOnline {
                    onlineIndicator
                }
            }
            
            // User name
            Text(user.name)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray6).opacity(0.8))
                )
        }
        .onAppear {
            startIdleAnimation()
        }
    }
    
    @ViewBuilder
    private var fullBodyAvatar: some View {
        if user.avatar.useBitmoji, let bitmojiUrl = user.avatar.bitmojiAvatarUrl {
            // Bitmoji avatar
            AsyncImage(url: URL(string: bitmojiUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 80)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
            } placeholder: {
                customAvatar
            }
        } else {
            // Custom full-body avatar
            customAvatar
        }
    }
    
    @ViewBuilder
    private var customAvatar: some View {
        VStack(spacing: 0) {
            // Head
            ZStack {
                Circle()
                    .fill(skinColor)
                    .frame(width: 24, height: 24)
                
                // Hair
                hairView
                
                // Eyes
                HStack(spacing: 4) {
                    Circle()
                        .fill(.black)
                        .frame(width: 4, height: 4)
                    Circle()
                        .fill(.black)
                        .frame(width: 4, height: 4)
                }
                .offset(y: -2)
                
                // Mouth
                Circle()
                    .fill(.black)
                    .frame(width: 6, height: 3)
                    .offset(y: 4)
            }
            
            // Body
            Rectangle()
                .fill(outfitColor)
                .frame(width: 32, height: 40)
                .overlay(
                    // Arms
                    HStack {
                        Rectangle()
                            .fill(skinColor)
                            .frame(width: 6, height: 20)
                            .offset(x: -4, y: -5)
                            .rotationEffect(.degrees(user.avatar.isWaving ? 45 : 0))
                            .animation(.easeInOut(duration: 0.5), value: user.avatar.isWaving)
                        
                        Spacer()
                        
                        Rectangle()
                            .fill(skinColor)
                            .frame(width: 6, height: 20)
                            .offset(x: 4, y: -5)
                            .rotationEffect(.degrees(user.avatar.isPointing ? -30 : 0))
                            .animation(.easeInOut(duration: 0.5), value: user.avatar.isPointing)
                    }
                )
            
            // Legs
            HStack(spacing: 8) {
                Rectangle()
                    .fill(pantsColor)
                    .frame(width: 8, height: 25)
                
                Rectangle()
                    .fill(pantsColor)
                    .frame(width: 8, height: 25)
            }
            .offset(y: -2)
            
            // Shoes
            HStack(spacing: 8) {
                Ellipse()
                    .fill(shoesColor)
                    .frame(width: 10, height: 6)
                
                Ellipse()
                    .fill(shoesColor)
                    .frame(width: 10, height: 6)
            }
            .offset(y: -4)
        }
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isAnimating)
    }
    
    @ViewBuilder
    private var hairView: some View {
        switch user.avatar.hairStyle {
        case "short":
            Rectangle()
                .fill(hairColor)
                .frame(width: 20, height: 8)
                .offset(y: -8)
        case "long":
            Rectangle()
                .fill(hairColor)
                .frame(width: 18, height: 12)
                .offset(y: -6)
        case "curly":
            Circle()
                .fill(hairColor)
                .frame(width: 22, height: 10)
                .offset(y: -8)
        default:
            Rectangle()
                .fill(hairColor)
                .frame(width: 20, height: 8)
                .offset(y: -8)
        }
    }
    
    @ViewBuilder
    private func activityIndicator(for activity: Activity) -> some View {
        VStack {
            HStack {
                Spacer()
                
                VStack(spacing: 2) {
                    Image(systemName: activityIcon(for: activity.type))
                        .font(.caption2)
                        .foregroundColor(.white)
                    
                    Text(activity.title)
                        .font(.caption2)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.7))
                )
            }
            
            Spacer()
        }
        .offset(y: -40)
    }
    
    private var onlineIndicator: some View {
        VStack {
            HStack {
                Spacer()
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            
            Spacer()
        }
        .offset(x: 20, y: -30)
    }
    
    private func startIdleAnimation() {
        isAnimating = true
        
        // Random idle animations
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                // Random pose changes
                let poses = ["standing", "sitting", "waving"]
                currentPose = poses.randomElement() ?? "standing"
            }
        }
    }
    
    private func activityIcon(for type: ActivityType) -> String {
        switch type {
        case .watching: return "tv"
        case .shopping: return "cart"
        case .working: return "laptopcomputer"
        case .exercising: return "figure.run"
        case .eating: return "fork.knife"
        case .relaxing: return "bed.double"
        case .other: return "ellipsis"
        }
    }
    
    // Color properties
    private var skinColor: Color {
        switch user.avatar.skinTone {
        case "light": return Color(red: 0.95, green: 0.85, blue: 0.75)
        case "medium": return Color(red: 0.85, green: 0.65, blue: 0.45)
        case "dark": return Color(red: 0.45, green: 0.25, blue: 0.15)
        default: return Color(red: 0.95, green: 0.85, blue: 0.75)
        }
    }
    
    private var hairColor: Color {
        switch user.avatar.hairColor {
        case "brown": return Color(red: 0.4, green: 0.2, blue: 0.1)
        case "black": return Color.black
        case "blonde": return Color(red: 0.9, green: 0.8, blue: 0.4)
        case "red": return Color(red: 0.8, green: 0.3, blue: 0.1)
        default: return Color(red: 0.4, green: 0.2, blue: 0.1)
        }
    }
    
    private var outfitColor: Color {
        switch user.avatar.outfit {
        case "casual": return Color(red: 0.3, green: 0.6, blue: 0.9)
        case "formal": return Color(red: 0.2, green: 0.2, blue: 0.2)
        case "sporty": return Color(red: 0.9, green: 0.3, blue: 0.3)
        default: return Color(red: 0.3, green: 0.6, blue: 0.9)
        }
    }
    
    private var pantsColor: Color {
        Color(red: 0.2, green: 0.2, blue: 0.4)
    }
    
    private var shoesColor: Color {
        switch user.avatar.shoes {
        case "sneakers": return Color(red: 0.8, green: 0.8, blue: 0.8)
        case "formal": return Color.black
        case "sporty": return Color(red: 0.9, green: 0.3, blue: 0.3)
        default: return Color(red: 0.8, green: 0.8, blue: 0.8)
        }
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