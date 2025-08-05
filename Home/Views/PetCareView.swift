import SwiftUI

struct PetCareView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingCreatePet = false
    @State private var petName = ""
    @State private var selectedPetType: PetType = .dog
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let pet = appState.currentFamily?.virtualPet {
                    petCareView(pet: pet)
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
            }
        }
        .sheet(isPresented: $showingCreatePet) {
            createPetSheet
        }
    }
    
    private var createPetView: some View {
        VStack(spacing: 30) {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
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
    
    private func petCareView(pet: VirtualPet) -> some View {
        VStack(spacing: 25) {
            // Pet display
            VStack(spacing: 15) {
                Image(systemName: petIcon(for: pet.type))
                    .font(.system(size: 80))
                    .foregroundColor(petColor(for: pet.type))
                
                Text(pet.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(pet.type.rawValue)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            // Pet status
            VStack(spacing: 15) {
                Text("Pet Status")
                    .font(.headline)
                
                StatusBar(title: "Hunger", value: pet.hunger, color: .orange)
                StatusBar(title: "Happiness", value: pet.happiness, color: .pink)
                StatusBar(title: "Energy", value: pet.energy, color: .blue)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            
            // Care actions
            VStack(spacing: 15) {
                Text("Care Actions")
                    .font(.headline)
                
                HStack(spacing: 20) {
                    CareActionButton(
                        title: "Feed",
                        icon: "fork.knife",
                        color: .orange
                    ) {
                        appState.feedPet()
                    }
                    
                    CareActionButton(
                        title: "Play",
                        icon: "gamecontroller.fill",
                        color: .green
                    ) {
                        appState.playWithPet()
                    }
                }
            }
            
            // Pet info
            VStack(spacing: 10) {
                Text("Last Fed: \(pet.lastFed, style: .relative) ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Last Played: \(pet.lastPlayed, style: .relative) ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var createPetSheet: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Create Your Family Pet")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    TextField("Pet Name", text: $petName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("Pet Type", selection: $selectedPetType) {
                        ForEach(PetType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: petIcon(for: type))
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    // Pet preview
                    VStack(spacing: 10) {
                        Image(systemName: petIcon(for: selectedPetType))
                            .font(.system(size: 60))
                            .foregroundColor(petColor(for: selectedPetType))
                        
                        Text(petName.isEmpty ? "Your Pet" : petName)
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                }
                .padding()
                
                Spacer()
                
                Button("Create Pet") {
                    appState.createVirtualPet(name: petName, type: selectedPetType)
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
    
    private func petIcon(for type: PetType) -> String {
        switch type {
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
        }
    }
    
    private func petColor(for type: PetType) -> Color {
        switch type {
        case .dog:
            return .brown
        case .cat:
            return .orange
        case .bird:
            return .blue
        case .fish:
            return .cyan
        case .rabbit:
            return .gray
        }
    }
}

struct StatusBar: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                    .font(.body)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: value)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
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
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PetCareView()
        .environmentObject(AppStateManager())
} 