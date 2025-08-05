import SwiftUI

struct FamilyActivitiesView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingCreateActivity = false
    @State private var selectedActivityType: FamilyActivityType = .dinner
    @State private var activityTitle = ""
    @State private var activityDescription = ""
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.purple)
                    
                    Text("Family Activities")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Plan and enjoy activities together")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                // Current activities
                if let family = appState.currentFamily, !family.activities.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Upcoming Activities")
                            .font(.headline)
                        
                        ForEach(family.activities.filter { !$0.isCompleted }) { activity in
                            ActivityRow(activity: activity)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Quick activity suggestions
                VStack(alignment: .leading, spacing: 15) {
                    Text("Quick Activities")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                        QuickActivityCard(
                            title: "Virtual Dinner",
                            description: "Eat together virtually",
                            icon: "fork.knife",
                            color: .orange
                        ) {
                            createQuickActivity(.dinner, "Virtual Dinner", "Let's have dinner together!")
                        }
                        
                        QuickActivityCard(
                            title: "Puzzle Time",
                            description: "Solve puzzles together",
                            icon: "puzzlepiece.fill",
                            color: .blue
                        ) {
                            createQuickActivity(.puzzle, "Family Puzzle", "Let's solve a puzzle together!")
                        }
                        
                        QuickActivityCard(
                            title: "Movie Night",
                            description: "Watch a movie together",
                            icon: "tv.fill",
                            color: .purple
                        ) {
                            createQuickActivity(.movie, "Movie Night", "Let's watch a movie together!")
                        }
                        
                        QuickActivityCard(
                            title: "Game Night",
                            description: "Play games together",
                            icon: "gamecontroller.fill",
                            color: .green
                        ) {
                            createQuickActivity(.game, "Game Night", "Let's play some games!")
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button("Create Custom Activity") {
                    showingCreateActivity = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Activities")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreateActivity) {
            createActivitySheet
        }
    }
    
    private func createQuickActivity(_ type: FamilyActivityType, _ title: String, _ description: String) {
        guard let user = appState.currentUser else { return }
        
        let activity = FamilyActivity(
            type: type,
            title: title,
            description: description,
            participants: [user],
            startTime: Date().addingTimeInterval(3600) // 1 hour from now
        )
        
        appState.createFamilyActivity(activity)
    }
    
    private var createActivitySheet: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Create Family Activity")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    Picker("Activity Type", selection: $selectedActivityType) {
                        ForEach(FamilyActivityType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: activityIcon(for: type))
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    TextField("Activity Title", text: $activityTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Description", text: $activityDescription, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                    
                    DatePicker("Start Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                }
                .padding()
                
                Spacer()
                
                Button("Create Activity") {
                    createCustomActivity()
                }
                .buttonStyle(.borderedProminent)
                .disabled(activityTitle.isEmpty || activityDescription.isEmpty)
                .padding()
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        showingCreateActivity = false
                    }
                }
            }
        }
    }
    
    private func createCustomActivity() {
        guard let user = appState.currentUser else { return }
        
        let activity = FamilyActivity(
            type: selectedActivityType,
            title: activityTitle,
            description: activityDescription,
            participants: [user],
            startTime: selectedDate
        )
        
        appState.createFamilyActivity(activity)
        showingCreateActivity = false
        
        // Reset form
        activityTitle = ""
        activityDescription = ""
        selectedDate = Date()
    }
    
    private func activityIcon(for type: FamilyActivityType) -> String {
        switch type {
        case .dinner:
            return "fork.knife"
        case .puzzle:
            return "puzzlepiece.fill"
        case .movie:
            return "tv.fill"
        case .game:
            return "gamecontroller.fill"
        case .petCare:
            return "pawprint.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
}

struct ActivityRow: View {
    let activity: FamilyActivity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: activityIcon(for: activity.type))
                    .foregroundColor(.blue)
                
                Text(activity.title)
                    .font(.headline)
                
                Spacer()
                
                Text(activity.startTime, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(activity.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                Text("\(activity.participants.count) participants")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Join") {
                    // Handle joining activity
                }
                .buttonStyle(.bordered)
                .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func activityIcon(for type: FamilyActivityType) -> String {
        switch type {
        case .dinner:
            return "fork.knife"
        case .puzzle:
            return "puzzlepiece.fill"
        case .movie:
            return "tv.fill"
        case .game:
            return "gamecontroller.fill"
        case .petCare:
            return "pawprint.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
}

struct QuickActivityCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FamilyActivitiesView()
        .environmentObject(AppStateManager())
} 