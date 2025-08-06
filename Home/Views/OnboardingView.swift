import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var currentStep = 0
    @State private var name = ""
    @State private var email = ""
    @State private var avatar = Avatar()
    
    // Family member setup
    @State private var familyMembers: [User] = []
    @State private var newMemberName = ""
    @State private var newMemberEmail = ""
    @State private var showingAddMember = false
    
    // Permissions
    @State private var locationPermission = false
    @State private var notificationPermission = false
    @State private var photoPermission = false
    @State private var spotifyPermission = false
    @State private var messagesPermission = false
    @State private var facetimePermission = false
    
    // Picker state variables
    @State private var showingSkinTonePicker = false
    @State private var showingHairStylePicker = false
    @State private var showingHairColorPicker = false
    @State private var showingOutfitPicker = false
    @State private var showingShoesPicker = false
    @State private var showingExpressionPicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.98, green: 0.98, blue: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Progress indicator
                    VStack(spacing: 10) {
                        HStack {
                            Text("Step \(currentStep + 1) of 5")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        ProgressView(value: Double(currentStep), total: 4)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .scaleEffect(y: 2)
                    }
                    .padding(.horizontal)
                    
                    // Step content
                    switch currentStep {
                    case 0:
                        welcomeStep
                    case 1:
                        accountCreationStep
                    case 2:
                        avatarCustomizationStep
                    case 3:
                        familySetupStep
                    case 4:
                        permissionsStep
                    default:
                        welcomeStep
                    }
                    
                    Spacer()
                    
                    // Navigation buttons
                    HStack {
                        if currentStep > 0 {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentStep -= 1
                                }
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .font(.caption)
                                    Text("Back")
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.blue)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                )
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if currentStep == 4 {
                                appState.createAccount(name: name, email: email, avatar: avatar)
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentStep += 1
                                }
                            }
                        }) {
                            HStack {
                                Text(currentStep == 4 ? "Complete Setup" : "Next")
                                    .fontWeight(.semibold)
                                Image(systemName: currentStep == 4 ? "checkmark" : "chevron.right")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                        .disabled(currentStep == 1 && (name.isEmpty || email.isEmpty))
                        .opacity(currentStep == 1 && (name.isEmpty || email.isEmpty) ? 0.6 : 1.0)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Welcome to Family Home")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSkinTonePicker) {
            PickerSheet(title: "Skin Tone", options: ["light", "medium", "dark"], selection: $avatar.skinTone)
        }
        .sheet(isPresented: $showingHairStylePicker) {
            PickerSheet(title: "Hair Style", options: ["short", "long", "curly", "straight"], selection: $avatar.hairStyle)
        }
        .sheet(isPresented: $showingHairColorPicker) {
            PickerSheet(title: "Hair Color", options: ["brown", "black", "blonde", "red"], selection: $avatar.hairColor)
        }
        .sheet(isPresented: $showingOutfitPicker) {
            PickerSheet(title: "Outfit", options: ["casual", "formal", "sporty", "elegant"], selection: $avatar.outfit)
        }
        .sheet(isPresented: $showingShoesPicker) {
            PickerSheet(title: "Shoes", options: ["sneakers", "formal", "sporty"], selection: $avatar.shoes)
        }
        .sheet(isPresented: $showingExpressionPicker) {
            PickerSheet(title: "Expression", options: ["happy", "sad", "excited", "calm"], selection: $avatar.expression)
        }
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 30) {
            // Animated icon
            Image(systemName: "house.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: currentStep)
            
            VStack(spacing: 20) {
                Text("Welcome to Family Home")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("Stay connected with your family through a virtual home where everyone can share their daily activities, locations, and create lasting memories together.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 20) {
                FeatureRow(icon: "person.2.fill", title: "Family Connection", description: "Create a virtual home for your family", color: .blue)
                FeatureRow(icon: "location.fill", title: "Location Sharing", description: "Share your whereabouts with loved ones", color: .green)
                FeatureRow(icon: "gamecontroller.fill", title: "Activities", description: "Enjoy virtual activities together", color: .purple)
                FeatureRow(icon: "pawprint.fill", title: "Virtual Pet", description: "Care for a family pet together", color: .orange)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal)
        }
    }
    
    private var accountCreationStep: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Create Your Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            VStack(spacing: 25) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your full name", text: $name)
                        .textFieldStyle(CustomTextFieldStyle())
                        .autocapitalization(.words)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email Address")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
            .padding(.horizontal)
            
            Text("This information will be shared with your family members")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var avatarCustomizationStep: some View {
        VStack(spacing: 25) {
            Text("Create Your Avatar")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Avatar preview
            AvatarPreviewView(avatar: avatar)
                .frame(height: 120)
                .padding()
            
            // Bitmoji integration
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Use Bitmoji")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Connect with your iPhone Bitmoji for a personalized avatar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Connect") {
                        connectBitmoji()
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue)
                    )
                    .foregroundColor(.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
            }
            
            // Custom avatar options
            VStack(spacing: 15) {
                Text("Or Customize Your Own")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                    CustomizationRow(title: "Skin Tone", value: avatar.skinTone) {
                        showingSkinTonePicker = true
                    }
                    
                    CustomizationRow(title: "Hair Style", value: avatar.hairStyle) {
                        showingHairStylePicker = true
                    }
                    
                    CustomizationRow(title: "Hair Color", value: avatar.hairColor) {
                        showingHairColorPicker = true
                    }
                    
                    CustomizationRow(title: "Outfit", value: avatar.outfit) {
                        showingOutfitPicker = true
                    }
                    
                    CustomizationRow(title: "Shoes", value: avatar.shoes) {
                        showingShoesPicker = true
                    }
                    
                    CustomizationRow(title: "Expression", value: avatar.expression) {
                        showingExpressionPicker = true
                    }
                }
            }
            
            Spacer()
            
            // Navigation buttons
            HStack {
                Button("Back") {
                    withAnimation {
                        currentStep -= 1
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Spacer()
                
                Button("Continue") {
                    withAnimation {
                        currentStep += 1
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding()
    }
    
    private func connectBitmoji() {
        // In a real app, this would integrate with Bitmoji's SDK
        // For now, we'll simulate the connection
        let mockBitmojiId = "bitmoji_\(UUID().uuidString.prefix(8))"
        appState.createBitmojiAvatar(avatarId: mockBitmojiId)
        
        // Show success message
        // You could add a toast or alert here
    }
    
    private func showSkinTonePicker() {
        showingSkinTonePicker = true
    }
    
    private func showHairStylePicker() {
        showingHairStylePicker = true
    }
    
    private func showHairColorPicker() {
        showingHairColorPicker = true
    }
    
    private func showOutfitPicker() {
        showingOutfitPicker = true
    }
    
    private func showShoesPicker() {
        showingShoesPicker = true
    }
    
    private func showExpressionPicker() {
        showingExpressionPicker = true
    }
    
    private var familySetupStep: some View {
        VStack(spacing: 25) {
            Text("Add Family Members")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Invite your family members to join your virtual home")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Family members list
            if !familyMembers.isEmpty {
                VStack(spacing: 12) {
                    Text("Family Members")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(familyMembers, id: \.id) { member in
                        HStack {
                            AvatarView(user: member)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(member.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                                Text(member.email)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if let index = familyMembers.firstIndex(where: { $0.id == member.id }) {
                                    familyMembers.remove(at: index)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                    }
                }
            }
            
            // Add member button
            Button(action: {
                showingAddMember = true
            }) {
                HStack {
                    Image(systemName: "person.badge.plus")
                        .font(.title2)
                    Text("Add Family Member")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 2)
                        .background(Color.blue.opacity(0.1))
                )
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showingAddMember) {
            addMemberSheet
        }
    }
    
    private var addMemberSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Add Family Member")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("Name", text: $newMemberName)
                        .textFieldStyle(CustomTextFieldStyle())
                    
                    TextField("Email", text: $newMemberEmail)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Button(action: {
                    if !newMemberName.isEmpty && !newMemberEmail.isEmpty {
                        let newMember = User(
                            name: newMemberName,
                            email: newMemberEmail,
                            avatar: Avatar(),
                            keyLocations: []
                        )
                        familyMembers.append(newMember)
                        newMemberName = ""
                        newMemberEmail = ""
                        showingAddMember = false
                    }
                }) {
                    Text("Add Member")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .disabled(newMemberName.isEmpty || newMemberEmail.isEmpty)
                .opacity(newMemberName.isEmpty || newMemberEmail.isEmpty ? 0.6 : 1.0)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                showingAddMember = false
            })
        }
    }
    
    private var permissionsStep: some View {
        VStack(spacing: 25) {
            Text("Enable Permissions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Allow Family Home to access features that help you stay connected")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                PermissionRow(
                    title: "Location",
                    description: "Share your location with family members",
                    icon: "location.fill",
                    color: .blue,
                    isEnabled: $locationPermission
                )
                
                PermissionRow(
                    title: "Notifications",
                    description: "Receive updates about family activities",
                    icon: "bell.fill",
                    color: .orange,
                    isEnabled: $notificationPermission
                )
                
                PermissionRow(
                    title: "Photos",
                    description: "Share family photos and memories",
                    icon: "photo.fill",
                    color: .green,
                    isEnabled: $photoPermission
                )
                
                PermissionRow(
                    title: "Spotify",
                    description: "Share what you're listening to",
                    icon: "music.note",
                    color: .purple,
                    isEnabled: $spotifyPermission
                )
                
                PermissionRow(
                    title: "Messages",
                    description: "Send quick messages to family",
                    icon: "message.fill",
                    color: .green,
                    isEnabled: $messagesPermission
                )
                
                PermissionRow(
                    title: "FaceTime",
                    description: "Start video calls with family",
                    icon: "video.fill",
                    color: .blue,
                    isEnabled: $facetimePermission
                )
            }
            
            Spacer()
            
            VStack(spacing: 10) {
                Text("You can change these permissions later in Settings")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

struct PermissionRow: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .toggleStyle(SwitchToggleStyle(tint: color))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct PickerSheet: View {
    let title: String
    let options: [String]
    @Binding var selection: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select \(title)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selection = option
                            dismiss()
                        }) {
                            VStack(spacing: 8) {
                                Text(option.capitalized)
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(selection == option ? .white : .primary)
                                
                                if title == "Skin Tone" {
                                    Circle()
                                        .fill(skinToneColor(for: option))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(selection == option ? Color.white : Color.clear, lineWidth: 3)
                                        )
                                } else if title == "Hair Color" {
                                    Circle()
                                        .fill(hairColor(for: option))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(selection == option ? Color.white : Color.clear, lineWidth: 3)
                                        )
                                } else {
                                    Image(systemName: iconForOption(option))
                                        .font(.title2)
                                        .foregroundColor(selection == option ? .white : .primary)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selection == option ? 
                                          LinearGradient(gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]), startPoint: .leading, endPoint: .trailing) :
                                          LinearGradient(gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray5)]), startPoint: .leading, endPoint: .trailing)
                                    )
                                    .shadow(color: selection == option ? .blue.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
    
    private func skinToneColor(for tone: String) -> Color {
        switch tone {
        case "light": return Color(red: 0.98, green: 0.9, blue: 0.8)
        case "medium": return Color(red: 0.9, green: 0.7, blue: 0.5)
        case "dark": return Color(red: 0.6, green: 0.4, blue: 0.3)
        default: return Color(red: 0.98, green: 0.9, blue: 0.8)
        }
    }
    
    private func hairColor(for color: String) -> Color {
        switch color {
        case "brown": return Color(red: 0.6, green: 0.4, blue: 0.2)
        case "black": return Color(red: 0.2, green: 0.2, blue: 0.2)
        case "blonde": return Color(red: 0.9, green: 0.8, blue: 0.6)
        case "red": return Color(red: 0.8, green: 0.4, blue: 0.2)
        default: return Color(red: 0.6, green: 0.4, blue: 0.2)
        }
    }
    
    private func iconForOption(_ option: String) -> String {
        switch title {
        case "Hair Style":
            switch option {
            case "short": return "scissors"
            case "long": return "person.fill"
            case "curly": return "waveform.path"
            case "straight": return "line.diagonal"
            default: return "person.fill"
            }
        case "Outfit":
            switch option {
            case "casual": return "tshirt"
            case "formal": return "person.fill"
            case "sporty": return "figure.run"
            case "elegant": return "crown"
            default: return "tshirt"
            }
        case "Shoes":
            switch option {
            case "sneakers": return "shoe"
            case "formal": return "person.fill"
            case "sporty": return "figure.run"
            default: return "shoe"
            }
        case "Expression":
            switch option {
            case "happy": return "face.smiling"
            case "sad": return "face.dashed"
            case "excited": return "star.fill"
            case "calm": return "leaf.fill"
            default: return "face.smiling"
            }
        default:
            return "circle.fill"
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            )
            .font(.body)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
                .padding(.vertical, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct CustomizationRow: View {
    let title: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(value.capitalized)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomizationRowOld: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 25)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selection = option
                        }
                    }) {
                        Text(option.capitalized)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selection == option ? 
                                          LinearGradient(gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]), startPoint: .leading, endPoint: .trailing) :
                                          LinearGradient(gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray5)]), startPoint: .leading, endPoint: .trailing)
                                    )
                                    .shadow(color: selection == option ? .blue.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
                            )
                            .foregroundColor(selection == option ? .white : .primary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct AvatarPreviewView: View {
    let avatar: Avatar
    
    var body: some View {
        ZStack {
            // Background gradient
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.9, green: 0.95, blue: 1.0),
                            Color(red: 0.85, green: 0.9, blue: 0.95)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Avatar representation
            VStack(spacing: 8) {
                ZStack {
                    // Head
                    Circle()
                        .fill(skinToneColor)
                        .frame(width: 60, height: 60)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    // Hair
                    if avatar.hairStyle != "bald" {
                        Circle()
                            .fill(hairColor)
                            .frame(width: 65, height: 65)
                            .offset(y: -5)
                            .mask(
                                Circle()
                                    .frame(width: 65, height: 65)
                                    .offset(y: -5)
                            )
                    }
                    
                    // Eyes
                    HStack(spacing: 8) {
                        Circle()
                            .fill(eyeColor)
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(eyeColor)
                            .frame(width: 8, height: 8)
                    }
                    .offset(y: 5)
                    
                    // Mouth
                    Circle()
                        .fill(Color.red.opacity(0.6))
                        .frame(width: 12, height: 6)
                        .offset(y: 15)
                }
                
                // Clothing indicator
                HStack(spacing: 4) {
                    Image(systemName: clothingIcon)
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text(avatar.clothing.capitalized)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.1))
                )
            }
        }
    }
    
    private var skinToneColor: Color {
        switch avatar.skinTone {
        case "light":
            return Color(red: 0.98, green: 0.9, blue: 0.8)
        case "medium":
            return Color(red: 0.9, green: 0.7, blue: 0.5)
        case "dark":
            return Color(red: 0.6, green: 0.4, blue: 0.3)
        default:
            return Color(red: 0.98, green: 0.9, blue: 0.8)
        }
    }
    
    private var hairColor: Color {
        switch avatar.hairColor {
        case "brown":
            return Color(red: 0.6, green: 0.4, blue: 0.2)
        case "black":
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        case "blonde":
            return Color(red: 0.9, green: 0.8, blue: 0.6)
        case "red":
            return Color(red: 0.8, green: 0.4, blue: 0.2)
        default:
            return Color(red: 0.6, green: 0.4, blue: 0.2)
        }
    }
    
    private var eyeColor: Color {
        switch avatar.eyeColor {
        case "brown":
            return Color(red: 0.6, green: 0.4, blue: 0.2)
        case "blue":
            return Color(red: 0.3, green: 0.6, blue: 0.9)
        case "green":
            return Color(red: 0.3, green: 0.7, blue: 0.4)
        case "hazel":
            return Color(red: 0.7, green: 0.6, blue: 0.3)
        default:
            return Color(red: 0.6, green: 0.4, blue: 0.2)
        }
    }
    
    private var clothingIcon: String {
        switch avatar.clothing {
        case "casual":
            return "tshirt"
        case "formal":
            return "person.fill"
        case "sporty":
            return "figure.run"
        case "elegant":
            return "person.fill"
        default:
            return "tshirt"
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.blue)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppStateManager())
} 