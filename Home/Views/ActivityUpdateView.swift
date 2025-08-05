import SwiftUI

struct ActivityUpdateView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedActivityType: ActivityType = .relaxing
    @State private var activityTitle = ""
    @State private var activityDetails = ""
    @State private var shareWithFamily = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    
                    Text("What are you up to?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Let your family know what you're doing")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                // Activity form
                VStack(spacing: 15) {
                    Picker("Activity Type", selection: $selectedActivityType) {
                        ForEach(ActivityType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: activityIcon(for: type))
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    TextField("What are you doing?", text: $activityTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Details (optional)", text: $activityDetails, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                    
                    Toggle("Share with family", isOn: $shareWithFamily)
                        .padding(.vertical)
                    
                    // Quick activity buttons
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Quick Activities")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                            QuickActivityButton(title: "Watching TV", type: .watching, icon: "tv.fill")
                            QuickActivityButton(title: "Shopping", type: .shopping, icon: "cart.fill")
                            QuickActivityButton(title: "Working", type: .working, icon: "laptopcomputer")
                            QuickActivityButton(title: "Exercising", type: .exercising, icon: "dumbbell.fill")
                            QuickActivityButton(title: "Eating", type: .eating, icon: "fork.knife")
                            QuickActivityButton(title: "Relaxing", type: .relaxing, icon: "bed.double.fill")
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Update button
                Button("Update Activity") {
                    updateActivity()
                }
                .buttonStyle(.borderedProminent)
                .disabled(activityTitle.isEmpty)
                .padding()
            }
            .navigationTitle("Activity Update")
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
    
    private func updateActivity() {
        let activity = Activity(
            type: selectedActivityType,
            title: activityTitle,
            details: activityDetails.isEmpty ? nil : activityDetails
        )
        
        appState.updateActivity(activity)
        dismiss()
    }
    
    private func activityIcon(for type: ActivityType) -> String {
        switch type {
        case .watching:
            return "tv.fill"
        case .shopping:
            return "cart.fill"
        case .working:
            return "laptopcomputer"
        case .exercising:
            return "dumbbell.fill"
        case .eating:
            return "fork.knife"
        case .relaxing:
            return "bed.double.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
}

struct QuickActivityButton: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    let type: ActivityType
    let icon: String
    
    var body: some View {
        Button(action: {
            let activity = Activity(type: type, title: title)
            appState.updateActivity(activity)
            dismiss()
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ActivityUpdateView()
        .environmentObject(AppStateManager())
} 