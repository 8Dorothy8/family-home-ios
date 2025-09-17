import SwiftUI
import EventKit

struct CalendarView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    @State private var showingGoogleCalendarAuth = false
    @State private var isGoogleCalendarConnected = false
    @State private var events: [CalendarEvent] = []
    @State private var isLoading = false
    @State private var showingAddEvent = false
    @State private var selectedEvent: CalendarEvent?
    @State private var calendarViewMode: CalendarViewMode = .month
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with Google Calendar connection
                headerView
                
                // Calendar view mode selector
                calendarModeSelector
                
                // Main calendar content
                calendarContentView
                
                // Event list for selected date
                eventListView
            }
            .navigationTitle("Family Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddEvent = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
            }
        }
        .sheet(isPresented: $showingGoogleCalendarAuth) {
            GoogleCalendarAuthView(isConnected: $isGoogleCalendarConnected)
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventView(events: $events)
        }
        .sheet(item: $selectedEvent) { event in
            EventDetailView(event: event)
        }
        .onAppear {
            loadEvents()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            // Google Calendar connection status
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Google Calendar")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(isGoogleCalendarConnected ? "Connected" : "Not Connected")
                        .font(.caption)
                        .foregroundColor(isGoogleCalendarConnected ? .green : .red)
                }
                
                Spacer()
                
                Button(action: {
                    if isGoogleCalendarConnected {
                        disconnectGoogleCalendar()
                    } else {
                        showingGoogleCalendarAuth = true
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: isGoogleCalendarConnected ? "link.badge.minus" : "link.badge.plus")
                        Text(isGoogleCalendarConnected ? "Disconnect" : "Connect")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isGoogleCalendarConnected ? .red : .blue)
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            
            // Family members status
            if !appState.familyMembers.isEmpty {
                HStack {
                    Text("Family Members")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(appState.familyMembers.prefix(4)) { member in
                            Circle()
                                .fill(memberColor(for: member))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Text(String(member.name.prefix(1)))
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                        }
                        
                        if appState.familyMembers.count > 4 {
                            Text("+\(appState.familyMembers.count - 4)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var calendarModeSelector: some View {
        HStack(spacing: 0) {
            ForEach(CalendarViewMode.allCases, id: \.self) { mode in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        calendarViewMode = mode
                    }
                }) {
                    Text(mode.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(calendarViewMode == mode ? .white : .primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(calendarViewMode == mode ? .blue : Color.clear)
                        )
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var calendarContentView: some View {
        Group {
            switch calendarViewMode {
            case .month:
                MonthCalendarView(selectedDate: $selectedDate, events: events)
            case .week:
                WeekCalendarView(selectedDate: $selectedDate, events: events)
            case .day:
                DayCalendarView(selectedDate: $selectedDate, events: events)
            }
        }
        .padding(.horizontal)
    }
    
    private var eventListView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Events for \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(eventsForSelectedDate.count) events")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            if eventsForSelectedDate.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("No events scheduled")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Tap the + button to add an event")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(eventsForSelectedDate) { event in
                            EventRowView(event: event) {
                                selectedEvent = event
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }
    
    private var eventsForSelectedDate: [CalendarEvent] {
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return events.filter { event in
            event.startDate >= startOfDay && event.startDate < endOfDay
        }.sorted { $0.startDate < $1.startDate }
    }
    
    private func memberColor(for member: User) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red]
        let index = member.id.hashValue % colors.count
        return colors[index]
    }
    
    private func loadEvents() {
        isLoading = true
        
        // Simulate loading events from Google Calendar
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.events = CalendarEvent.sampleEvents
            self.isLoading = false
        }
    }
    
    private func disconnectGoogleCalendar() {
        isGoogleCalendarConnected = false
        events.removeAll()
    }
}

// MARK: - Calendar View Modes

enum CalendarViewMode: CaseIterable {
    case month, week, day
    
    var title: String {
        switch self {
        case .month: return "Month"
        case .week: return "Week"
        case .day: return "Day"
        }
    }
}

// MARK: - Month Calendar View

struct MonthCalendarView: View {
    @Binding var selectedDate: Date
    let events: [CalendarEvent]
    
    private let calendar = Calendar.current
    private let daysInWeek = 7
    
    var body: some View {
        VStack(spacing: 8) {
            // Day headers
            HStack(spacing: 0) {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: daysInWeek), spacing: 4) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        DayCellView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            events: eventsForDate(date),
                            onTap: {
                                selectedDate = date
                            }
                        )
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
        }
    }
    
    private var daysInMonth: [Date?] {
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedDate)?.start ?? selectedDate
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: selectedDate)?.count ?? 30
        
        var days: [Date?] = []
        
        // Add empty cells for days before the first day of the month
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        // Add all days in the month
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        // Add empty cells to complete the last week
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
    
    private func eventsForDate(_ date: Date) -> [CalendarEvent] {
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return events.filter { event in
            event.startDate >= startOfDay && event.startDate < endOfDay
        }
    }
}

// MARK: - Day Cell View

struct DayCellView: View {
    let date: Date
    let isSelected: Bool
    let events: [CalendarEvent]
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(isSelected ? .white : .primary)
                
                // Event indicators
                if !events.isEmpty {
                    HStack(spacing: 2) {
                        ForEach(events.prefix(3)) { event in
                            Circle()
                                .fill(event.memberColor)
                                .frame(width: 4, height: 4)
                        }
                        
                        if events.count > 3 {
                            Text("+\(events.count - 3)")
                                .font(.system(size: 8))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .blue : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Week Calendar View

struct WeekCalendarView: View {
    @Binding var selectedDate: Date
    let events: [CalendarEvent]
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 8) {
            // Time slots
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<24, id: \.self) { hour in
                        HStack(spacing: 0) {
                            // Time label
                            Text(timeString(for: hour))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .frame(width: 40, alignment: .trailing)
                                .padding(.trailing, 8)
                            
                            // Day columns
                            HStack(spacing: 0) {
                                ForEach(daysInWeek, id: \.self) { date in
                                    Rectangle()
                                        .fill(Color(.systemGray5))
                                        .frame(height: 60)
                                        .overlay(
                                            eventsForTimeSlot(date: date, hour: hour)
                                        )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var daysInWeek: [Date] {
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
        return (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: startOfWeek)
        }
    }
    
    private func timeString(for hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
        return formatter.string(from: date)
    }
    
    private func eventsForTimeSlot(date: Date, hour: Int) -> some View {
        let startTime = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date) ?? date
        let endTime = calendar.date(byAdding: .hour, value: 1, to: startTime) ?? date
        
        let timeSlotEvents = events.filter { event in
            event.startDate >= startTime && event.startDate < endTime &&
            calendar.isDate(event.startDate, inSameDayAs: date)
        }
        
        return VStack(spacing: 2) {
            ForEach(timeSlotEvents) { event in
                Text(event.title)
                    .font(.system(size: 8))
                    .lineLimit(1)
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(event.memberColor.opacity(0.3))
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Day Calendar View

struct DayCalendarView: View {
    @Binding var selectedDate: Date
    let events: [CalendarEvent]
    
    private let calendar = Calendar.current
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(0..<24, id: \.self) { hour in
                    HStack(spacing: 0) {
                        // Time label
                        Text(timeString(for: hour))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .frame(width: 60, alignment: .trailing)
                            .padding(.trailing, 16)
                        
                        // Events for this hour
                        VStack(spacing: 4) {
                            let hourEvents = eventsForHour(hour)
                            ForEach(hourEvents) { event in
                                EventBlockView(event: event)
                            }
                            
                            if hourEvents.isEmpty {
                                Rectangle()
                                    .fill(Color(.systemGray6))
                                    .frame(height: 60)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color(.systemGray4), lineWidth: 0.5)
                                    )
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func timeString(for hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
        return formatter.string(from: date)
    }
    
    private func eventsForHour(_ hour: Int) -> [CalendarEvent] {
        let startTime = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: selectedDate) ?? selectedDate
        let endTime = calendar.date(byAdding: .hour, value: 1, to: startTime) ?? selectedDate
        
        return events.filter { event in
            event.startDate >= startTime && event.startDate < endTime
        }.sorted { $0.startDate < $1.startDate }
    }
}

// MARK: - Event Block View

struct EventBlockView: View {
    let event: CalendarEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
            
            Text(event.memberName)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(event.memberColor.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(event.memberColor, lineWidth: 1)
                )
        )
    }
}

// MARK: - Event Row View

struct EventRowView: View {
    let event: CalendarEvent
    let onTap: () -> Void
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Time
                VStack(alignment: .trailing, spacing: 2) {
                    Text(timeFormatter.string(from: event.startDate))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(timeFormatter.string(from: event.endDate))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(width: 50, alignment: .trailing)
                
                // Event details
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    HStack {
                        // Member indicator
                        Circle()
                            .fill(event.memberColor)
                            .frame(width: 12, height: 12)
                        
                        Text(event.memberName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if !event.location.isEmpty {
                            Text("•")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(event.location)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Google Calendar Auth View

struct GoogleCalendarAuthView: View {
    @Binding var isConnected: Bool
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAuthenticating = false
    @State private var authError: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Google Calendar icon
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
                
                VStack(spacing: 16) {
                    Text("Connect Google Calendar")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Sync your family's events and see everyone's schedule in one place")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Benefits
                VStack(alignment: .leading, spacing: 12) {
                    BenefitRow(icon: "calendar.badge.clock", text: "Real-time event synchronization")
                    BenefitRow(icon: "person.2.fill", text: "See family members' schedules")
                    BenefitRow(icon: "location.fill", text: "Location-aware event planning")
                    BenefitRow(icon: "bell.fill", text: "Smart notifications and reminders")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                
                Spacer()
                
                // Connect button
                Button(action: authenticateGoogleCalendar) {
                    HStack(spacing: 12) {
                        if isAuthenticating {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "link.badge.plus")
                        }
                        
                        Text(isAuthenticating ? "Connecting..." : "Connect Google Calendar")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue)
                    )
                }
                .disabled(isAuthenticating)
                
                if let error = authError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .navigationTitle("Google Calendar")
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
    
    private func authenticateGoogleCalendar() {
        isAuthenticating = true
        authError = nil
        
        // Simulate Google Calendar authentication
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isAuthenticating = false
            isConnected = true
            dismiss()
        }
    }
}

// MARK: - Benefit Row

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

// MARK: - Add Event View

struct AddEventView: View {
    @Binding var events: [CalendarEvent]
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600)
    @State private var location = ""
    @State private var notes = ""
    @State private var selectedMember: User? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section("Event Details") {
                    TextField("Event Title", text: $title)
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                    
                    TextField("Location", text: $location)
                    
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Family Member") {
                    if let member = selectedMember {
                        HStack {
                            Circle()
                                .fill(memberColor(for: member))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Text(String(member.name.prefix(1)))
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                            
                            Text(member.name)
                            
                            Spacer()
                            
                            Button("Change") {
                                selectedMember = nil
                            }
                            .font(.caption)
                        }
                    } else {
                        ForEach(AppStateManager().familyMembers) { member in
                            Button(action: {
                                selectedMember = member
                            }) {
                                HStack {
                                    Circle()
                                        .fill(memberColor(for: member))
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Text(String(member.name.prefix(1)))
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        )
                                    
                                    Text(member.name)
                                    
                                    Spacer()
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Add Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEvent()
                    }
                    .disabled(title.isEmpty || selectedMember == nil)
                }
            }
        }
    }
    
    private func memberColor(for member: User) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red]
        let index = member.id.hashValue % colors.count
        return colors[index]
    }
    
    private func saveEvent() {
        guard let member = selectedMember else { return }
        
        let newEvent = CalendarEvent(
            id: UUID(),
            title: title,
            startDate: startDate,
            endDate: endDate,
            location: location,
            notes: notes,
            memberId: member.id,
            memberName: member.name,
            memberColor: memberColor(for: member)
        )
        
        events.append(newEvent)
        dismiss()
    }
}

// MARK: - Event Detail View

struct EventDetailView: View {
    let event: CalendarEvent
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Event header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Circle()
                                .fill(event.memberColor)
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Text(String(event.memberName.prefix(1)))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(event.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(event.memberName)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        
                        if !event.location.isEmpty {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                                Text(event.location)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Event details
                    VStack(alignment: .leading, spacing: 16) {
                        DetailRow(icon: "calendar", title: "Date & Time", value: "\(dateFormatter.string(from: event.startDate)) - \(dateFormatter.string(from: event.endDate))")
                        
                        if !event.notes.isEmpty {
                            DetailRow(icon: "note.text", title: "Notes", value: event.notes)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Event Details")
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

// MARK: - Detail Row

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Calendar Event Model

struct CalendarEvent: Identifiable {
    let id: UUID
    let title: String
    let startDate: Date
    let endDate: Date
    let location: String
    let notes: String
    let memberId: UUID
    let memberName: String
    let memberColor: Color
    
    static var sampleEvents: [CalendarEvent] {
        let calendar = Calendar.current
        let now = Date()
        
        return [
            CalendarEvent(
                id: UUID(),
                title: "Family Dinner",
                startDate: calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now) ?? now,
                endDate: calendar.date(bySettingHour: 19, minute: 30, second: 0, of: now) ?? now,
                location: "Home",
                notes: "Weekly family dinner",
                memberId: UUID(),
                memberName: "Mom",
                memberColor: .blue
            ),
            CalendarEvent(
                id: UUID(),
                title: "Soccer Practice",
                startDate: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: now) ?? now,
                endDate: calendar.date(bySettingHour: 17, minute: 30, second: 0, of: now) ?? now,
                location: "Community Center",
                notes: "Bring water bottle",
                memberId: UUID(),
                memberName: "Dad",
                memberColor: .green
            ),
            CalendarEvent(
                id: UUID(),
                title: "Movie Night",
                startDate: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now) ?? now,
                endDate: calendar.date(bySettingHour: 22, minute: 0, second: 0, of: now) ?? now,
                location: "Living Room",
                notes: "Watch the new Marvel movie",
                memberId: UUID(),
                memberName: "Kids",
                memberColor: .orange
            )
        ]
    }
}

#Preview {
    CalendarView()
        .environmentObject(AppStateManager())
}
