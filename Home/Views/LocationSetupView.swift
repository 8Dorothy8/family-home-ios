import SwiftUI
import CoreLocation

struct LocationSetupView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var locationName = ""
    @State private var selectedLocationType: LocationType = .home
    @State private var showingLocationPicker = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Set Up Your Locations")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Add key locations to help your family know where you are")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                // Current locations
                if let user = appState.currentUser, !user.keyLocations.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Locations")
                            .font(.headline)
                        
                        ForEach(user.keyLocations) { location in
                            LocationRow(location: location)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Add new location
                VStack(spacing: 15) {
                    Text("Add New Location")
                        .font(.headline)
                    
                    TextField("Location Name", text: $locationName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("Location Type", selection: $selectedLocationType) {
                        ForEach(LocationType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Button("Select Location on Map") {
                        showingLocationPicker = true
                    }
                    .buttonStyle(.bordered)
                    
                    if let coordinate = selectedCoordinate {
                        Text("Selected: \(coordinate.latitude, specifier: "%.4f"), \(coordinate.longitude, specifier: "%.4f")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Add Location") {
                        addLocation()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(locationName.isEmpty || selectedCoordinate == nil)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Location Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingLocationPicker) {
            LocationPickerView(selectedCoordinate: $selectedCoordinate)
        }
    }
    
    private func addLocation() {
        guard let coordinate = selectedCoordinate else { return }
        
        let newLocation = KeyLocation(
            name: locationName,
            type: selectedLocationType,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        appState.addKeyLocation(newLocation)
        
        // Reset form
        locationName = ""
        selectedLocationType = .home
        selectedCoordinate = nil
    }
}

struct LocationRow: View {
    let location: KeyLocation
    
    var body: some View {
        HStack {
            Image(systemName: locationIcon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(location.name)
                    .fontWeight(.medium)
                Text(location.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(location.latitude, specifier: "%.2f"), \(location.longitude, specifier: "%.2f")")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var locationIcon: String {
        switch location.type {
        case .home:
            return "house.fill"
        case .work:
            return "briefcase.fill"
        case .gym:
            return "dumbbell.fill"
        case .store:
            return "cart.fill"
        case .restaurant:
            return "fork.knife"
        case .other:
            return "mappin.circle.fill"
        }
    }
}

struct LocationPickerView: View {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Location Picker")
                    .font(.title)
                    .padding()
                
                Text("This would integrate with MapKit to allow users to select locations")
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Simulate location selection
                Button("Select Current Location") {
                    selectedCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .navigationTitle("Pick Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    LocationSetupView()
        .environmentObject(AppStateManager())
} 