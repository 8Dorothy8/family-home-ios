import SwiftUI

struct PetCareView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingCreatePet = false
    @State private var petName = ""
    @State private var selectedPetType: PetType = .dog
    @State private var selectedPersonality: PetPersonality = .friendly
    @State private var showingPetDetails = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let pet = appState.currentFamily?.virtualPet {
                    enhancedPetCareView(pet: pet)
                } else {
                    createPetView
                }
            }
            .navigationTitle("Virtual Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                if appState.currentFamily?.virtualPet != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Details") {
                            showingPetDetails = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreatePet) {
            enhancedCreatePetSheet
        }
        .sheet(isPresented: $showingPetDetails) {
            if let pet = appState.currentFamily?.virtualPet {
                PetDetailsView(pet: pet)
            }
        }
    }
    
    private var createPetView: some View {
        VStack(spacing: 30) {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 80))
                .foregroundColor(.orange)
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: selectedPetType)
            
            Text("No Family Pet Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Create a virtual pet for your family to care for together!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Create Pet") {
                showingCreatePet = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func enhancedPetCareView(pet: VirtualPet) -> some View {
        VStack(spacing: 0) {
            // Pet display with personality
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    petColor(for: pet.type).opacity(0.2),
                                    petColor(for: pet.type).opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: petIcon(for: pet.type))
                        .font(.system(size: 60))
                        .foregroundColor(petColor(for: pet.type))
                        .scaleEffect(pet.happiness > 0.7 ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.5), value: pet.happiness)
                }
                
                VStack(spacing: 5) {
                    Text(pet.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 8) {
                        Text(pet.type.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(petColor(for: pet.type).opacity(0.2))
                            .cornerRadius(8)
                        
                        Text(pet.personality.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.purple.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    Text("Age: \(pet.age) days")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            
            // Tab selector
            Picker("Pet Care", selection: $selectedTab) {
                Text("Status").tag(0)
                Text("Care").tag(1)
                Text("Training").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Tab content
            TabView(selection: $selectedTab) {
                petStatusView(pet: pet)
                    .tag(0)
                
                petCareActionsView(pet: pet)
                    .tag(1)
                
                petTrainingView(pet: pet)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    
    private func petStatusView(pet: VirtualPet) -> some View {
        VStack(spacing: 20) {
            // Overall health indicator
            VStack(spacing: 10) {
                Text("Overall Health")
                    .font(.headline)
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: overallHealth(pet: pet))
                        .stroke(healthColor(pet: pet), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1), value: overallHealth(pet: pet))
                    
                    Text("\(Int(overallHealth(pet: pet) * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            
            // Detailed status bars
            VStack(spacing: 15) {
                EnhancedStatusBar(title: "Hunger", value: pet.hunger, color: .orange, icon: "fork.knife")
                EnhancedStatusBar(title: "Happiness", value: pet.happiness, color: .pink, icon: "heart.fill")
                EnhancedStatusBar(title: "Energy", value: pet.energy, color: .blue, icon: "bolt.fill")
                EnhancedStatusBar(title: "Health", value: pet.health, color: .green, icon: "cross.fill")
                EnhancedStatusBar(title: "Training", value: pet.training, color: .purple, icon: "star.fill")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray6))
            )
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func petCareActionsView(pet: VirtualPet) -> some View {
        VStack(spacing: 20) {
            Text("Care Actions")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                EnhancedCareActionButton(
                    title: "Feed",
                    subtitle: pet.favoriteFood,
                    icon: "fork.knife",
                    color: .orange
                ) {
                    appState.feedPet()
                }
                
                EnhancedCareActionButton(
                    title: "Play",
                    subtitle: pet.favoriteToy,
                    icon: "gamecontroller.fill",
                    color: .pink
                ) {
                    appState.playWithPet()
                }
                
                EnhancedCareActionButton(
                    title: "Train",
                    subtitle: "Learn tricks",
                    icon: "star.fill",
                    color: .purple
                ) {
                    appState.trainPet()
                }
                
                EnhancedCareActionButton(
                    title: "Rest",
                    subtitle: "Take a nap",
                    icon: "bed.double.fill",
                    color: .blue
                ) {
                    appState.restPet()
                }
            }
            .padding(.horizontal)
            
            // Pet mood indicator
            VStack(spacing: 10) {
                Text("Pet's Mood")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(petMood(pet: pet))
                    .font(.title3)
                    .foregroundColor(moodColor(pet: pet))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(moodColor(pet: pet).opacity(0.2))
                    .cornerRadius(20)
            }
        }
        .padding()
    }
    
    private func petTrainingView(pet: VirtualPet) -> some View {
        VStack(spacing: 20) {
            Text("Training Progress")
                .font(.headline)
            
            VStack(spacing: 15) {
                TrainingProgressCard(
                    title: "Basic Commands",
                    progress: min(pet.training, 0.3),
                    maxProgress: 0.3,
                    color: .blue
                )
                
                TrainingProgressCard(
                    title: "Advanced Tricks",
                    progress: max(0, pet.training - 0.3),
                    maxProgress: 0.4,
                    color: .purple
                )
                
                TrainingProgressCard(
                    title: "Special Skills",
                    progress: max(0, pet.training - 0.7),
                    maxProgress: 0.3,
                    color: .orange
                )
            }
            .padding(.horizontal)
            
            if pet.training < 1.0 {
                Button("Practice Training") {
                    appState.trainPet()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "star.fill")
                        .font(.title)
                        .foregroundColor(.yellow)
                    
                    Text("Fully Trained!")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                .padding()
            }
        }
        .padding()
    }
    
    private var enhancedCreatePetSheet: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Create Your Family Pet")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    // Pet name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pet Name")
                            .font(.headline)
                        
                        TextField("Enter pet name", text: $petName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Pet type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pet Type")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(PetType.allCases, id: \.self) { petType in
                                Button(action: {
                                    selectedPetType = petType
                                }) {
                                    VStack(spacing: 8) {
                                        Image(systemName: petIcon(for: petType))
                                            .font(.title2)
                                            .foregroundColor(selectedPetType == petType ? .white : petColor(for: petType))
                                        
                                        Text(petType.rawValue)
                                            .font(.caption)
                                            .foregroundColor(selectedPetType == petType ? .white : .primary)
                                    }
                                    .frame(height: 60)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(selectedPetType == petType ? petColor(for: petType) : Color(.systemGray6))
                                    )
                                }
                            }
                        }
                    }
                    
                    // Pet personality
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Personality")
                            .font(.headline)
                        
                        Picker("Personality", selection: $selectedPersonality) {
                            ForEach(PetPersonality.allCases, id: \.self) { personality in
                                Text(personality.rawValue).tag(personality)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button("Create Pet") {
                    appState.createPet(name: petName, type: selectedPetType, personality: selectedPersonality)
                    showingCreatePet = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(petName.isEmpty)
                .padding()
            }
            .navigationTitle("New Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        showingCreatePet = false
                    }
                }
            }
        }
    }
    
    // Helper functions
    private func overallHealth(pet: VirtualPet) -> Double {
        return (pet.hunger + pet.happiness + pet.energy + pet.health) / 4.0
    }
    
    private func healthColor(pet: VirtualPet) -> Color {
        let health = overallHealth(pet: pet)
        if health > 0.7 { return .green }
        if health > 0.4 { return .orange }
        return .red
    }
    
    private func petMood(pet: VirtualPet) -> String {
        let health = overallHealth(pet: pet)
        if health > 0.8 { return "😊 Very Happy" }
        if health > 0.6 { return "🙂 Happy" }
        if health > 0.4 { return "😐 Okay" }
        if health > 0.2 { return "😕 Sad" }
        return "😢 Very Sad"
    }
    
    private func moodColor(pet: VirtualPet) -> Color {
        let health = overallHealth(pet: pet)
        if health > 0.8 { return .green }
        if health > 0.6 { return .blue }
        if health > 0.4 { return .orange }
        return .red
    }
    
    private func petIcon(for type: PetType) -> String {
        switch type {
        case .dog: return "dog.fill"
        case .cat: return "cat.fill"
        case .bird: return "bird.fill"
        case .fish: return "fish.fill"
        case .rabbit: return "hare.fill"
        case .hamster: return "circle.fill" // Using circle as placeholder
        case .turtle: return "circle.fill" // Using circle as placeholder
        }
    }
    
    private func petColor(for type: PetType) -> Color {
        switch type {
        case .dog: return Color(red: 0.6, green: 0.4, blue: 0.2)
        case .cat: return Color(red: 0.9, green: 0.6, blue: 0.3)
        case .bird: return Color(red: 0.3, green: 0.6, blue: 0.9)
        case .fish: return Color(red: 0.4, green: 0.8, blue: 0.9)
        case .rabbit: return Color(red: 0.7, green: 0.7, blue: 0.7)
        case .hamster: return Color(red: 0.8, green: 0.5, blue: 0.2)
        case .turtle: return Color(red: 0.3, green: 0.7, blue: 0.3)
        }
    }
}

// Enhanced components
struct EnhancedStatusBar: View {
    let title: String
    let value: Double
    let color: Color
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(Int(value * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1))
        )
    }
}

struct EnhancedCareActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct TrainingProgressCard: View {
    let title: String
    let progress: Double
    let maxProgress: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(Int((progress / maxProgress) * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: progress, total: maxProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
}

struct PetDetailsView: View {
    let pet: VirtualPet
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Pet avatar
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        petColor(for: pet.type).opacity(0.3),
                                        petColor(for: pet.type).opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 150, height: 150)
                        
                        Image(systemName: petIcon(for: pet.type))
                            .font(.system(size: 80))
                            .foregroundColor(petColor(for: pet.type))
                    }
                    
                    // Pet info
                    VStack(spacing: 15) {
                        Text(pet.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 15) {
                            InfoBadge(title: "Type", value: pet.type.rawValue, color: .blue)
                            InfoBadge(title: "Personality", value: pet.personality.rawValue, color: .purple)
                        }
                        
                        HStack(spacing: 15) {
                            InfoBadge(title: "Age", value: "\(pet.age) days", color: .green)
                            InfoBadge(title: "Training", value: "\(Int(pet.training * 100))%", color: .orange)
                        }
                    }
                    
                    // Pet preferences
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Preferences")
                            .font(.headline)
                        
                        VStack(spacing: 10) {
                            PreferenceRow(title: "Favorite Food", value: pet.favoriteFood, icon: "fork.knife")
                            PreferenceRow(title: "Favorite Toy", value: pet.favoriteToy, icon: "gamecontroller.fill")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Pet history
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Care History")
                            .font(.headline)
                        
                        VStack(spacing: 10) {
                            HistoryRow(title: "Last Fed", date: pet.lastFed, icon: "fork.knife")
                            HistoryRow(title: "Last Played", date: pet.lastPlayed, icon: "gamecontroller.fill")
                            HistoryRow(title: "Last Trained", date: pet.lastTrained, icon: "star.fill")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("Pet Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func petIcon(for type: PetType) -> String {
        switch type {
        case .dog: return "dog.fill"
        case .cat: return "cat.fill"
        case .bird: return "bird.fill"
        case .fish: return "fish.fill"
        case .rabbit: return "hare.fill"
        case .hamster: return "circle.fill"
        case .turtle: return "circle.fill"
        }
    }
    
    private func petColor(for type: PetType) -> Color {
        switch type {
        case .dog: return Color(red: 0.6, green: 0.4, blue: 0.2)
        case .cat: return Color(red: 0.9, green: 0.6, blue: 0.3)
        case .bird: return Color(red: 0.3, green: 0.6, blue: 0.9)
        case .fish: return Color(red: 0.4, green: 0.8, blue: 0.9)
        case .rabbit: return Color(red: 0.7, green: 0.7, blue: 0.7)
        case .hamster: return Color(red: 0.8, green: 0.5, blue: 0.2)
        case .turtle: return Color(red: 0.3, green: 0.7, blue: 0.3)
        }
    }
}

struct InfoBadge: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct PreferenceRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct HistoryRow: View {
    let title: String
    let date: Date
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(date, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// Legacy components for backward compatibility
struct StatusBar: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(Int(value * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1))
        )
    }
}

struct CareActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    PetCareView()
        .environmentObject(AppStateManager())
} 