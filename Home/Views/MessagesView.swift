import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    @State private var newMessage = ""
    @State private var showingNotifications = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Header with notifications
                HStack {
                    Text("Family Messages")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        showingNotifications = true
                    }) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.blue)
                    }
                    .overlay(
                        Group {
                            if !appState.notifications.filter({ !$0.isRead }).isEmpty {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 8, y: -8)
                            }
                        }
                    )
                }
                .padding()
                
                // Messages list
                if appState.messages.isEmpty {
                    emptyMessagesView
                } else {
                    messagesList
                }
                
                // Message input
                messageInputView
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingNotifications) {
            NotificationsView()
        }
    }
    
    private var emptyMessagesView: some View {
        VStack(spacing: 20) {
            Image(systemName: "message.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Messages Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Start a conversation with your family!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var messagesList: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(appState.messages) { message in
                    MessageRow(message: message)
                }
            }
            .padding()
        }
    }
    
    private var messageInputView: some View {
        HStack {
            TextField("Type a message...", text: $newMessage, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(1...3)
            
            Button("Send") {
                sendMessage()
            }
            .buttonStyle(.borderedProminent)
            .disabled(newMessage.isEmpty)
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    private func sendMessage() {
        guard let user = appState.currentUser, !newMessage.isEmpty else { return }
        
        let message = Message(
            sender: user,
            content: newMessage,
            type: .text
        )
        
        appState.messages.append(message)
        newMessage = ""
    }
}

struct MessageRow: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AvatarView(user: message.sender)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(message.sender.name)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(message.content)
                    .font(.body)
                
                if let location = message.location {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                        Text("At \(location.name)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                if let activity = message.activity {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.green)
                        Text(activity.title)
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct NotificationsView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if appState.notifications.isEmpty {
                    emptyNotificationsView
                } else {
                    notificationsList
                }
            }
            .navigationTitle("Notifications")
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
    
    private var emptyNotificationsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Notifications")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("You're all caught up!")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var notificationsList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(appState.notifications) { notification in
                    NotificationRow(notification: notification)
                }
            }
            .padding()
        }
    }
}

struct NotificationRow: View {
    let notification: Notification
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: notificationIcon)
                .foregroundColor(notificationColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(notification.title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(notification.body)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("From \(notification.sender.name)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(notification.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(notification.isRead ? Color(.systemGray6) : Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(notification.isRead ? Color.clear : Color.blue, lineWidth: 1)
        )
    }
    
    private var notificationIcon: String {
        switch notification.type {
        case .locationUpdate:
            return "location.fill"
        case .activityUpdate:
            return "person.fill"
        case .familyInvite:
            return "person.badge.plus"
        case .petCare:
            return "pawprint.fill"
        case .familyActivity:
            return "gamecontroller.fill"
        case .arrival:
            return "house.fill"
        case .departure:
            return "arrow.up.right"
        }
    }
    
    private var notificationColor: Color {
        switch notification.type {
        case .locationUpdate:
            return .blue
        case .activityUpdate:
            return .green
        case .familyInvite:
            return .orange
        case .petCare:
            return .purple
        case .familyActivity:
            return .pink
        case .arrival:
            return .green
        case .departure:
            return .red
        }
    }
}

#Preview {
    MessagesView()
        .environmentObject(AppStateManager())
} 