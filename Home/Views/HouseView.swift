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
    
    private var houseLayoutView: some View {
        ZStack {
            // Floor
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.95, green: 0.93, blue: 0.88), // Warm wood
                            Color(red: 0.92, green: 0.90, blue: 0.85)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 400, height: 600)
                .overlay(
                    // Wood grain pattern
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    Color.black.opacity(0.05)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Walls
            VStack(spacing: 0) {
                // Top wall
                Rectangle()
                    .fill(Color(red: 0.98, green: 0.96, blue: 0.94))
                    .frame(width: 400, height: 20)
                
                HStack(spacing: 0) {
                    // Left wall
                    Rectangle()
                        .fill(Color(red: 0.98, green: 0.96, blue: 0.94))
                        .frame(width: 20, height: 560)
                    
                    // Main living space
                    ZStack {
                        // Living Room (top left)
                        livingRoomView
                        
                        // Kitchen (top right)
                        kitchenView
                        
                        // Dining Room (bottom left)
                        diningRoomView
                        
                        // Bedroom (bottom right)
                        bedroomView
                    }
                    .frame(width: 360, height: 560)
                    
                    // Right wall
                    Rectangle()
                        .fill(Color(red: 0.98, green: 0.96, blue: 0.94))
                        .frame(width: 20, height: 560)
                }
                
                // Bottom wall
                Rectangle()
                    .fill(Color(red: 0.98, green: 0.96, blue: 0.94))
                    .frame(width: 400, height: 20)
            }
        }
        .frame(width: 400, height: 600)
    }
    
    private var livingRoomView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.95, green: 0.97, blue: 1.0),
                            Color(red: 0.90, green: 0.94, blue: 0.98)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 180, height: 280)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                )
            
            VStack(spacing: 8) {
                Text("Living Room")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white.opacity(0.9))
                    )
                
                // Furniture
                HStack(spacing: 15) {
                    // Couch
                    VStack {
                        Image(systemName: "sofa.fill")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.2))
                        Text("Couch")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    // TV
                    VStack {
                        Image(systemName: "tv.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                        Text("TV")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 8)
        }
        .position(x: 90, y: 140)
    }
    
    private var kitchenView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.95, blue: 0.90),
                            Color(red: 0.98, green: 0.93, blue: 0.88)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 180, height: 280)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                )
            
            VStack(spacing: 8) {
                Text("Kitchen")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white.opacity(0.9))
                    )
                
                // Kitchen furniture
                HStack(spacing: 15) {
                    // Stove
                    VStack {
                        Image(systemName: "flame.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                        Text("Stove")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    // Sink
                    VStack {
                        Image(systemName: "drop.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("Sink")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 8)
        }
        .position(x: 270, y: 140)
    }
    
    private var diningRoomView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.90, green: 0.95, blue: 0.90),
                            Color(red: 0.85, green: 0.92, blue: 0.87)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 180, height: 280)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green.opacity(0.3), lineWidth: 2)
                )
            
            VStack(spacing: 8) {
                Text("Dining Room")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white.opacity(0.9))
                    )
                
                // Dining furniture
                VStack(spacing: 8) {
                    Image(systemName: "table.furniture")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.5, green: 0.3, blue: 0.1))
                    Text("Dining Table")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.top, 8)
        }
        .position(x: 90, y: 420)
    }
    
    private var bedroomView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.95, green: 0.90, blue: 0.95),
                            Color(red: 0.92, green: 0.87, blue: 0.92)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 180, height: 280)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                )
            
            VStack(spacing: 8) {
                Text("Bedroom")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white.opacity(0.9))
                    )
                
                // Bedroom furniture
                VStack(spacing: 8) {
                    Image(systemName: "bed.double.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.9))
                    Text("Bed")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.top, 8)
        }
        .position(x: 270, y: 420)
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