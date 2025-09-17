import SwiftUI
import CallKit
import AVFoundation

struct CallView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var selectedCallType: CallType = .phone
    @State private var showingScheduleCall = false
    @State private var showingCallHistory = false
    @State private var showingAddContact = false
    @State private var isInCall = false
    @State private var currentCall: ActiveCall?
    
    private let callTypes: [CallType] = [.phone, .facetime, .facetimeAudio]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Call Type Selector
                callTypeSelector
                
                // Search Bar
                searchBar
                
                // Content
                if isInCall {
                    activeCallView
                } else {
                    mainContentView
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingScheduleCall) {
            ScheduleCallView()
        }
        .sheet(isPresented: $showingCallHistory) {
            CallHistoryView()
        }
        .sheet(isPresented: $showingAddContact) {
            AddContactView()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.blue)
                
                Spacer()
                
                Text("Calls")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("History") {
                    showingCallHistory = true
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            // Quick Actions
            HStack(spacing: 20) {
                QuickActionButton(
                    icon: "phone.fill",
                    title: "Phone",
                    color: .green,
                    action: { initiateCall(type: .phone) }
                )
                
                QuickActionButton(
                    icon: "video.fill",
                    title: "FaceTime",
                    color: .blue,
                    action: { initiateCall(type: .facetime) }
                )
                
                QuickActionButton(
                    icon: "calendar.badge.plus",
                    title: "Schedule",
                    color: .orange,
                    action: { showingScheduleCall = true }
                )
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Call Type Selector
    private var callTypeSelector: some View {
        HStack(spacing: 0) {
            ForEach(callTypes, id: \.self) { callType in
                Button(action: {
                    selectedCallType = callType
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: callType.icon)
                            .font(.system(size: 20))
                            .foregroundColor(selectedCallType == callType ? .white : callType.color)
                        
                        Text(callType.displayName)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(selectedCallType == callType ? .white : callType.color)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedCallType == callType ? callType.color : Color.clear)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search contacts...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button("Clear") {
                    searchText = ""
                }
                .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    // MARK: - Main Content
    private var mainContentView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Favorites Section
                if !appState.familyMembers.isEmpty {
                    favoritesSection
                }
                
                // Recent Calls
                recentCallsSection
                
                // All Contacts
                allContactsSection
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Favorites Section
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Favorites")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Edit") {
                    // Handle edit favorites
                }
                .foregroundColor(.blue)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                ForEach(appState.familyMembers.prefix(8), id: \.id) { member in
                    FavoriteContactView(member: member) {
                        let contact = Contact(
                            id: member.id,
                            name: member.name,
                            phoneNumber: "555-0000", // Default phone number
                            email: member.email,
                            color: .blue, // Default color
                            isFavorite: true
                        )
                        initiateCall(to: contact, type: selectedCallType)
                    }
                }
            }
        }
    }
    
    // MARK: - Recent Calls Section
    private var recentCallsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Calls")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("See All") {
                    showingCallHistory = true
                }
                .foregroundColor(.blue)
            }
            
            LazyVStack(spacing: 8) {
                ForEach(recentCalls.prefix(5), id: \.id) { call in
                    RecentCallRow(call: call) {
                        initiateCall(to: call.contact, type: call.callType)
                    }
                }
            }
        }
    }
    
    // MARK: - All Contacts Section
    private var allContactsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("All Contacts")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Add") {
                    showingAddContact = true
                }
                .foregroundColor(.blue)
            }
            
            LazyVStack(spacing: 8) {
                ForEach(filteredContacts, id: \.id) { contact in
                    ContactRow(contact: contact) {
                        initiateCall(to: contact, type: selectedCallType)
                    }
                }
            }
        }
    }
    
    // MARK: - Active Call View
    private var activeCallView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Caller Info
            VStack(spacing: 16) {
                if let call = currentCall {
                    Circle()
                        .fill(call.contact.color)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Text(String(call.contact.name.prefix(1)))
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    Text(call.contact.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(call.callType.displayName)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text(call.status.displayText)
                        .font(.headline)
                        .foregroundColor(call.status.color)
                }
            }
            
            Spacer()
            
            // Call Controls
            HStack(spacing: 40) {
                CallControlButton(
                    icon: "phone.down.fill",
                    title: "End",
                    color: .red,
                    action: endCall
                )
                
                if selectedCallType == .facetime {
                    CallControlButton(
                        icon: "camera.rotate",
                        title: "Flip",
                        color: .blue,
                        action: flipCamera
                    )
                }
                
                CallControlButton(
                    icon: "mic.slash.fill",
                    title: "Mute",
                    color: .gray,
                    action: toggleMute
                )
            }
            .padding(.bottom, 50)
        }
        .padding()
    }
    
    // MARK: - Helper Methods
    private var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return allContacts
        } else {
            return allContacts.filter { contact in
                contact.name.localizedCaseInsensitiveContains(searchText) ||
                contact.phoneNumber.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private var allContacts: [Contact] {
        // Combine family members with additional contacts
        var contacts: [Contact] = appState.familyMembers.map { member in
            Contact(
                id: member.id,
                name: member.name,
                phoneNumber: "555-0000", // Default phone number
                email: member.email,
                color: .blue, // Default color
                isFavorite: true
            )
        }
        
        // Add sample contacts for demonstration
        contacts.append(contentsOf: Contact.sampleContacts)
        return contacts
    }
    
    private var recentCalls: [CallRecord] {
        return CallRecord.sampleCalls
    }
    
    private func initiateCall(type: CallType) {
        // This would typically open the phone app or FaceTime
        print("Initiating \(type.displayName) call")
    }
    
    private func initiateCall(to contact: Contact, type: CallType) {
        // Start the call
        currentCall = ActiveCall(
            contact: contact,
            callType: type,
            status: .connecting
        )
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isInCall = true
        }
        
        // Simulate call connection
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let call = currentCall {
                currentCall = ActiveCall(
                    contact: call.contact,
                    callType: call.callType,
                    status: .connected
                )
            }
        }
    }
    
    private func endCall() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isInCall = false
            currentCall = nil
        }
    }
    
    private func flipCamera() {
        // Handle camera flip for FaceTime
        print("Flipping camera")
    }
    
    private func toggleMute() {
        // Handle mute toggle
        print("Toggling mute")
    }
}

// MARK: - Supporting Views

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FavoriteContactView: View {
    let member: User
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Circle()
                    .fill(.blue) // Default color for family members
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(member.name.prefix(1)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                Text(member.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecentCallRow: View {
    let call: CallRecord
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Circle()
                    .fill(call.contact.color)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(call.contact.name.prefix(1)))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(call.contact.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: call.callType.icon)
                            .font(.caption)
                            .foregroundColor(call.callType.color)
                        
                        Text(call.date, style: .relative)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: call.direction.icon)
                    .font(.caption)
                    .foregroundColor(call.direction.color)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ContactRow: View {
    let contact: Contact
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Circle()
                    .fill(contact.color)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(contact.name.prefix(1)))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(contact.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(contact.phoneNumber)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if contact.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CallControlButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                    )
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Models

enum CallType: String, CaseIterable {
    case phone = "phone"
    case facetime = "facetime"
    case facetimeAudio = "facetimeAudio"
    
    var displayName: String {
        switch self {
        case .phone: return "Phone"
        case .facetime: return "FaceTime"
        case .facetimeAudio: return "FaceTime Audio"
        }
    }
    
    var icon: String {
        switch self {
        case .phone: return "phone.fill"
        case .facetime: return "video.fill"
        case .facetimeAudio: return "mic.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .phone: return .green
        case .facetime: return .blue
        case .facetimeAudio: return .purple
        }
    }
}

enum CallStatus {
    case connecting
    case connected
    case onHold
    case ended
    
    var displayText: String {
        switch self {
        case .connecting: return "Connecting..."
        case .connected: return "Connected"
        case .onHold: return "On Hold"
        case .ended: return "Call Ended"
        }
    }
    
    var color: Color {
        switch self {
        case .connecting: return .orange
        case .connected: return .green
        case .onHold: return .yellow
        case .ended: return .red
        }
    }
}

enum CallDirection {
    case incoming
    case outgoing
    case missed
    
    var icon: String {
        switch self {
        case .incoming: return "arrow.down.circle.fill"
        case .outgoing: return "arrow.up.circle.fill"
        case .missed: return "arrow.down.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .incoming: return .green
        case .outgoing: return .blue
        case .missed: return .red
        }
    }
}

struct Contact: Identifiable {
    let id: UUID
    let name: String
    let phoneNumber: String
    let email: String?
    let color: Color
    let isFavorite: Bool
    
    static var sampleContacts: [Contact] {
        [
            Contact(id: UUID(), name: "John Smith", phoneNumber: "+1-555-0123", email: "john@example.com", color: .blue, isFavorite: false),
            Contact(id: UUID(), name: "Sarah Johnson", phoneNumber: "+1-555-0124", email: "sarah@example.com", color: .purple, isFavorite: false),
            Contact(id: UUID(), name: "Mike Davis", phoneNumber: "+1-555-0125", email: "mike@example.com", color: .orange, isFavorite: false)
        ]
    }
}

struct CallRecord: Identifiable {
    let id: UUID
    let contact: Contact
    let callType: CallType
    let direction: CallDirection
    let date: Date
    let duration: TimeInterval?
    
    static var sampleCalls: [CallRecord] {
        let now = Date()
        let calendar = Calendar.current
        
        return [
            CallRecord(id: UUID(), contact: Contact.sampleContacts[0], callType: .phone, direction: .outgoing, date: calendar.date(byAdding: .minute, value: -5, to: now) ?? now, duration: 120),
            CallRecord(id: UUID(), contact: Contact.sampleContacts[1], callType: .facetime, direction: .incoming, date: calendar.date(byAdding: .hour, value: -2, to: now) ?? now, duration: 300),
            CallRecord(id: UUID(), contact: Contact.sampleContacts[2], callType: .phone, direction: .missed, date: calendar.date(byAdding: .hour, value: -4, to: now) ?? now, duration: nil)
        ]
    }
}

struct ActiveCall {
    let contact: Contact
    let callType: CallType
    let status: CallStatus
}

// MARK: - Schedule Call View

struct ScheduleCallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var selectedContact: Contact?
    @State private var selectedCallType: CallType = .phone
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Call Details") {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    
                    Picker("Call Type", selection: $selectedCallType) {
                        ForEach(CallType.allCases, id: \.self) { callType in
                            Text(callType.displayName).tag(callType)
                        }
                    }
                }
                
                Section("Contact") {
                    if let contact = selectedContact {
                        HStack {
                            Circle()
                                .fill(contact.color)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Text(String(contact.name.prefix(1)))
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                            
                            Text(contact.name)
                            
                            Spacer()
                            
                            Button("Change") {
                                selectedContact = nil
                            }
                            .foregroundColor(.blue)
                        }
                    } else {
                        Button("Select Contact") {
                            // Show contact picker
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                Section("Notes") {
                    TextField("Add notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Schedule Call")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Schedule") {
                        scheduleCall()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func scheduleCall() {
        // Handle scheduling the call
        print("Scheduling call with \(selectedContact?.name ?? "Unknown")")
        dismiss()
    }
}

// MARK: - Call History View

struct CallHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search calls...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Call history list
                List {
                    ForEach(CallRecord.sampleCalls, id: \.id) { call in
                        RecentCallRow(call: call) {
                            // Handle call initiation
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Call History")
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
}

// MARK: - Add Contact View

struct AddContactView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var selectedColor: Color = .blue
    
    private let colors: [Color] = [.blue, .green, .orange, .purple, .red, .pink, .yellow, .mint]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Contact Information") {
                    TextField("Name", text: $name)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 12) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: selectedColor == color ? 3 : 0)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Add Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveContact()
                    }
                    .fontWeight(.semibold)
                    .disabled(name.isEmpty || phoneNumber.isEmpty)
                }
            }
        }
    }
    
    private func saveContact() {
        // Handle saving the contact
        print("Saving contact: \(name)")
        dismiss()
    }
}

#Preview {
    CallView()
        .environmentObject(AppStateManager())
}
