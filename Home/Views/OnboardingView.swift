import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var currentStep = 0
    @State private var name = ""
    @State private var email = ""
    @State private var avatar = Avatar()
    
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
                            Text("Step \(currentStep + 1) of 4")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        ProgressView(value: Double(currentStep), total: 3)
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
                            if currentStep == 3 {
                                appState.createAccount(name: name, email: email, avatar: avatar)
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentStep += 1
                                }
                            }
                        }) {
                            HStack {
                                Text(currentStep == 3 ? "Complete Setup" : "Next")
                                    .fontWeight(.semibold)
                                Image(systemName: currentStep == 3 ? "checkmark" : "chevron.right")
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
                .padding()
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
        GatherTownAvatarCreator(avatar: $avatar)
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

// MARK: - Gather Town Style Avatar Creator

struct GatherTownAvatarCreator: View {
    @Binding var avatar: Avatar
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedCategory: AvatarCategory = .hair
    @State private var selectedColor: Color = .blue
    @State private var showingColorPicker = false
    @State private var isRandomizing = false
    
    private let categories: [AvatarCategory] = [
        .hair, .eyes, .outfit, .accessories, .expression, .body
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("Create Your Avatar")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Customize your character to represent you in your family home")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            
            // Main content area
            HStack(spacing: 20) {
                // Left side - Avatar preview
                VStack(spacing: 20) {
                    // Large avatar preview
                    ZStack {
                        // Background
                        RoundedRectangle(cornerRadius: 20)
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
                            .frame(width: 280, height: 320)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        // Avatar
                        GatherTownAvatarPreview(avatar: avatar)
                            .frame(width: 200, height: 240)
                    }
                    
                    // Color picker section
                    if showingColorPicker {
                        VStack(spacing: 12) {
                            Text("Color")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            HStack(spacing: 12) {
                                ForEach(avatarColors, id: \.self) { color in
                                    Button(action: {
                                        selectedColor = color
                                        updateAvatarColor()
                                    }) {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                            )
                                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                    }
                                    .scaleEffect(selectedColor == color ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedColor)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                    }
                }
                .frame(width: 320)
                
                // Right side - Customization options
                VStack(spacing: 20) {
                    // Category tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryTab(
                                    category: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedCategory = category
                                        showingColorPicker = category.hasColorOptions
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Options grid
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                            ForEach(optionsForCategory(selectedCategory), id: \.self) { option in
                                OptionThumbnail(
                                    option: option,
                                    category: selectedCategory,
                                    isSelected: isOptionSelected(option, category: selectedCategory)
                                ) {
                                    selectOption(option, category: selectedCategory)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 400)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            
            // Footer buttons
            HStack(spacing: 20) {
                Button(action: randomizeAvatar) {
                    HStack {
                        Image(systemName: "shuffle")
                            .font(.title3)
                        Text("Randomize")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .purple.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .scaleEffect(isRandomizing ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isRandomizing)
                }
                
                Spacer()
                
                Button("Confirm Avatar") {
                    // Avatar is already updated in real-time
                    // Just dismiss or continue
                }
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.90, green: 0.94, blue: 0.98)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private var avatarColors: [Color] {
        switch selectedCategory {
        case .hair:
            return [
                Color(red: 0.6, green: 0.4, blue: 0.2), // Brown
                Color.black,
                Color(red: 0.9, green: 0.8, blue: 0.6), // Blonde
                Color(red: 0.8, green: 0.4, blue: 0.2), // Red
                Color(red: 0.5, green: 0.5, blue: 0.5), // Gray
                Color(red: 0.3, green: 0.6, blue: 0.9)  // Blue
            ]
        case .eyes:
            return [
                Color(red: 0.6, green: 0.4, blue: 0.2), // Brown
                Color(red: 0.3, green: 0.6, blue: 0.9), // Blue
                Color(red: 0.3, green: 0.7, blue: 0.4), // Green
                Color(red: 0.7, green: 0.6, blue: 0.3), // Hazel
                Color.black,
                Color(red: 0.8, green: 0.8, blue: 0.8)  // Gray
            ]
        case .outfit:
            return [
                Color.blue,
                Color.red,
                Color.green,
                Color.purple,
                Color.orange,
                Color(red: 0.2, green: 0.2, blue: 0.2)  // Black
            ]
        default:
            return [.blue, .red, .green, .purple, .orange, .pink]
        }
    }
    
    private func optionsForCategory(_ category: AvatarCategory) -> [String] {
        switch category {
        case .hair:
            return ["short", "long", "curly", "straight", "wavy", "spiky", "bald", "bob", "ponytail"]
        case .eyes:
            return ["normal", "happy", "sad", "angry", "surprised", "wink", "sleepy", "cool", "glasses"]
        case .outfit:
            return ["casual", "formal", "sporty", "elegant", "business", "party", "pajamas", "uniform", "costume"]
        case .accessories:
            return ["none", "hat", "glasses", "earrings", "necklace", "watch", "scarf", "bag", "umbrella"]
        case .expression:
            return ["happy", "sad", "excited", "calm", "surprised", "angry", "confused", "wink", "laugh"]
        case .body:
            return ["average", "tall", "short", "slim", "athletic", "curvy", "muscular", "petite", "plus"]
        }
    }
    
    private func isOptionSelected(_ option: String, category: AvatarCategory) -> Bool {
        switch category {
        case .hair:
            return avatar.hairStyle == option
        case .eyes:
            return avatar.eyeColor == option
        case .outfit:
            return avatar.outfit == option
        case .accessories:
            // Handle "none" option specially
            if option == "none" {
                return avatar.accessories.isEmpty
            }
            return avatar.accessories.contains(option)
        case .expression:
            return avatar.expression == option
        case .body:
            return avatar.bodyType == option
        }
    }
    
    private func selectOption(_ option: String, category: AvatarCategory) {
        withAnimation(.easeInOut(duration: 0.2)) {
            switch category {
            case .hair:
                avatar.hairStyle = option
            case .eyes:
                avatar.eyeColor = option
            case .outfit:
                avatar.outfit = option
            case .accessories:
                // Handle "none" option specially
                if option == "none" {
                    avatar.accessories.removeAll()
                } else {
                    // Toggle the accessory
                    if avatar.accessories.contains(option) {
                        avatar.accessories.removeAll { $0 == option }
                    } else {
                        // Ensure we don't add duplicates
                        if !avatar.accessories.contains(option) {
                            avatar.accessories.append(option)
                        }
                    }
                }
            case .expression:
                avatar.expression = option
            case .body:
                avatar.bodyType = option
            }
        }
    }
    
    private func updateAvatarColor() {
        // Update the appropriate color property based on selected category
        // This would need to be implemented based on your Avatar model structure
    }
    
    private func randomizeAvatar() {
        isRandomizing = true
        
        // Get safe arrays with fallbacks
        let hairOptions = optionsForCategory(.hair)
        let eyeOptions = optionsForCategory(.eyes)
        let outfitOptions = optionsForCategory(.outfit)
        let expressionOptions = optionsForCategory(.expression)
        let bodyOptions = optionsForCategory(.body)
        let hairColors = ["brown", "black", "blonde", "red"]
        let skinTones = ["light", "medium", "dark"]
        
        // Randomize all avatar properties with safe array access
        withAnimation(.easeInOut(duration: 0.5)) {
            avatar.hairStyle = hairOptions.isEmpty ? "short" : (hairOptions.randomElement() ?? "short")
            avatar.hairColor = hairColors.isEmpty ? "brown" : (hairColors.randomElement() ?? "brown")
            avatar.eyeColor = eyeOptions.isEmpty ? "normal" : (eyeOptions.randomElement() ?? "normal")
            avatar.outfit = outfitOptions.isEmpty ? "casual" : (outfitOptions.randomElement() ?? "casual")
            avatar.expression = expressionOptions.isEmpty ? "happy" : (expressionOptions.randomElement() ?? "happy")
            avatar.bodyType = bodyOptions.isEmpty ? "average" : (bodyOptions.randomElement() ?? "average")
            avatar.skinTone = skinTones.isEmpty ? "light" : (skinTones.randomElement() ?? "light")
            
            // Clear accessories and add 1-2 random ones
            avatar.accessories.removeAll()
            let accessoryOptions = optionsForCategory(.accessories).filter { $0 != "none" }
            if !accessoryOptions.isEmpty {
                let numAccessories = Int.random(in: 0...min(2, accessoryOptions.count))
                for _ in 0..<numAccessories {
                    if let randomAccessory = accessoryOptions.randomElement() {
                        avatar.accessories.append(randomAccessory)
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isRandomizing = false
        }
    }
}

// MARK: - Supporting Views

struct CategoryTab: View {
    let category: AvatarCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(category.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? 
                          LinearGradient(gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]), startPoint: .leading, endPoint: .trailing) :
                          LinearGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray6)]), startPoint: .leading, endPoint: .trailing)
                    )
                    .shadow(color: isSelected ? .blue.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct OptionThumbnail: View {
    let option: String
    let category: AvatarCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Thumbnail preview
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: thumbnailIcon)
                        .font(.title2)
                        .foregroundColor(isSelected ? .white : .primary)
                }
                
                Text(option.capitalized)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                    .lineLimit(1)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? 
                          LinearGradient(gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]), startPoint: .leading, endPoint: .trailing) :
                          LinearGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray6)]), startPoint: .leading, endPoint: .trailing)
                    )
                    .shadow(color: isSelected ? .blue.opacity(0.3) : .clear, radius: 3, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private var thumbnailIcon: String {
        switch category {
        case .hair:
            switch option {
            case "short": return "scissors"
            case "long": return "person.fill"
            case "curly": return "waveform.path"
            case "straight": return "line.diagonal"
            case "wavy": return "waveform"
            case "spiky": return "flame"
            case "bald": return "circle"
            case "bob": return "person.crop.circle"
            case "ponytail": return "arrow.up"
            default: return "person.fill"
            }
        case .eyes:
            switch option {
            case "normal": return "eye"
            case "happy": return "face.smiling"
            case "sad": return "face.dashed"
            case "angry": return "flame"
            case "surprised": return "exclamationmark.circle"
            case "wink": return "eye.slash"
            case "sleepy": return "bed.double"
            case "cool": return "sunglasses"
            case "glasses": return "eyeglasses"
            default: return "eye"
            }
        case .outfit:
            switch option {
            case "casual": return "tshirt"
            case "formal": return "person.fill"
            case "sporty": return "figure.run"
            case "elegant": return "crown"
            case "business": return "briefcase"
            case "party": return "party.popper"
            case "pajamas": return "bed.double"
            case "uniform": return "person.badge.plus"
            case "costume": return "theatermasks"
            default: return "tshirt"
            }
        case .accessories:
            switch option {
            case "none": return "minus.circle"
            case "hat": return "crown"
            case "glasses": return "eyeglasses"
            case "earrings": return "circle"
            case "necklace": return "heart"
            case "watch": return "clock"
            case "scarf": return "rectangle"
            case "bag": return "bag"
            case "umbrella": return "umbrella"
            default: return "minus.circle"
            }
        case .expression:
            switch option {
            case "happy": return "face.smiling"
            case "sad": return "face.dashed"
            case "excited": return "star.fill"
            case "calm": return "leaf.fill"
            case "surprised": return "exclamationmark.circle"
            case "angry": return "flame"
            case "confused": return "questionmark.circle"
            case "wink": return "eye.slash"
            case "laugh": return "face.smiling.inverse"
            default: return "face.smiling"
            }
        case .body:
            return "person.fill"
        }
    }
}

struct GatherTownAvatarPreview: View {
    let avatar: Avatar
    
    var body: some View {
        ZStack {
            // Body
            VStack(spacing: 0) {
                // Head
                ZStack {
                    Circle()
                        .fill(skinToneColor)
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    // Hair
                    if avatar.hairStyle != "bald" {
                        hairView
                    }
                    
                    // Eyes
                    eyesView
                    
                    // Mouth/Expression
                    expressionView
                    
                    // Accessories
                    accessoriesView
                }
                
                // Body
                Rectangle()
                    .fill(outfitColor)
                    .frame(width: 60, height: 80)
                    .overlay(
                        // Arms
                        HStack {
                            Rectangle()
                                .fill(skinToneColor)
                                .frame(width: 8, height: 30)
                                .offset(x: -8, y: -10)
                            
                            Spacer()
                            
                            Rectangle()
                                .fill(skinToneColor)
                                .frame(width: 8, height: 30)
                                .offset(x: 8, y: -10)
                        }
                    )
                
                // Legs
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(pantsColor)
                        .frame(width: 12, height: 40)
                    
                    Rectangle()
                        .fill(pantsColor)
                        .frame(width: 12, height: 40)
                }
                .offset(y: -2)
                
                // Shoes
                HStack(spacing: 8) {
                    Ellipse()
                        .fill(shoesColor)
                        .frame(width: 16, height: 8)
                    
                    Ellipse()
                        .fill(shoesColor)
                        .frame(width: 16, height: 8)
                }
                .offset(y: -4)
            }
        }
    }
    
    @ViewBuilder
    private var hairView: some View {
        switch avatar.hairStyle {
        case "short":
            Rectangle()
                .fill(hairColor)
                .frame(width: 70, height: 12)
                .offset(y: -35)
        case "long":
            Rectangle()
                .fill(hairColor)
                .frame(width: 60, height: 25)
                .offset(y: -25)
        case "curly":
            Circle()
                .fill(hairColor)
                .frame(width: 75, height: 20)
                .offset(y: -30)
        case "straight":
            Rectangle()
                .fill(hairColor)
                .frame(width: 50, height: 20)
                .offset(y: -30)
        case "wavy":
            Path { path in
                path.move(to: CGPoint(x: -25, y: -35))
                path.addCurve(to: CGPoint(x: 25, y: -35), control1: CGPoint(x: -10, y: -40), control2: CGPoint(x: 10, y: -40))
            }
            .stroke(hairColor, lineWidth: 8)
        case "spiky":
            ForEach(0..<5, id: \.self) { i in
                Triangle()
                    .fill(hairColor)
                    .frame(width: 8, height: 12)
                    .offset(x: CGFloat(i * 4 - 8), y: -35)
            }
        case "bob":
            Circle()
                .fill(hairColor)
                .frame(width: 65, height: 15)
                .offset(y: -30)
        case "ponytail":
            Circle()
                .fill(hairColor)
                .frame(width: 20, height: 25)
                .offset(x: 15, y: -25)
        default:
            Rectangle()
                .fill(hairColor)
                .frame(width: 70, height: 12)
                .offset(y: -35)
        }
    }
    
    @ViewBuilder
    private var eyesView: some View {
        switch avatar.eyeColor {
        case "normal":
            HStack(spacing: 12) {
                Circle()
                    .fill(.black)
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(.black)
                    .frame(width: 8, height: 8)
            }
            .offset(y: -5)
        case "happy":
            HStack(spacing: 12) {
                Path { path in
                    path.move(to: CGPoint(x: -4, y: -2))
                    path.addQuadCurve(to: CGPoint(x: 4, y: -2), control: CGPoint(x: 0, y: 2))
                }
                .stroke(.black, lineWidth: 2)
                
                Path { path in
                    path.move(to: CGPoint(x: -4, y: -2))
                    path.addQuadCurve(to: CGPoint(x: 4, y: -2), control: CGPoint(x: 0, y: 2))
                }
                .stroke(.black, lineWidth: 2)
            }
            .offset(y: -5)
        case "sad":
            HStack(spacing: 12) {
                Path { path in
                    path.move(to: CGPoint(x: -4, y: 2))
                    path.addQuadCurve(to: CGPoint(x: 4, y: 2), control: CGPoint(x: 0, y: -2))
                }
                .stroke(.black, lineWidth: 2)
                
                Path { path in
                    path.move(to: CGPoint(x: -4, y: 2))
                    path.addQuadCurve(to: CGPoint(x: 4, y: 2), control: CGPoint(x: 0, y: -2))
                }
                .stroke(.black, lineWidth: 2)
            }
            .offset(y: -5)
        case "wink":
            HStack(spacing: 12) {
                Path { path in
                    path.move(to: CGPoint(x: -4, y: -2))
                    path.addQuadCurve(to: CGPoint(x: 4, y: -2), control: CGPoint(x: 0, y: 2))
                }
                .stroke(.black, lineWidth: 2)
                
                Circle()
                    .fill(.black)
                    .frame(width: 8, height: 8)
            }
            .offset(y: -5)
        default:
            HStack(spacing: 12) {
                Circle()
                    .fill(.black)
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(.black)
                    .frame(width: 8, height: 8)
            }
            .offset(y: -5)
        }
    }
    
    @ViewBuilder
    private var expressionView: some View {
        switch avatar.expression {
        case "happy":
            Path { path in
                path.move(to: CGPoint(x: -8, y: 8))
                path.addQuadCurve(to: CGPoint(x: 8, y: 8), control: CGPoint(x: 0, y: 15))
            }
            .stroke(.black, lineWidth: 2)
        case "sad":
            Path { path in
                path.move(to: CGPoint(x: -8, y: 15))
                path.addQuadCurve(to: CGPoint(x: 8, y: 15), control: CGPoint(x: 0, y: 8))
            }
            .stroke(.black, lineWidth: 2)
        case "excited":
            Path { path in
                path.move(to: CGPoint(x: -8, y: 8))
                path.addQuadCurve(to: CGPoint(x: 8, y: 8), control: CGPoint(x: 0, y: 18))
            }
            .stroke(.black, lineWidth: 3)
        case "surprised":
            Circle()
                .fill(.black)
                .frame(width: 12, height: 12)
                .offset(y: 8)
        default:
            Path { path in
                path.move(to: CGPoint(x: -6, y: 8))
                path.addQuadCurve(to: CGPoint(x: 6, y: 8), control: CGPoint(x: 0, y: 12))
            }
            .stroke(.black, lineWidth: 2)
        }
    }
    
    private var accessoriesView: some View {
        ZStack {
            // Only render accessories if the array is not empty
            if !avatar.accessories.isEmpty {
                if avatar.accessories.contains("hat") {
                    Ellipse()
                        .fill(.red)
                        .frame(width: 60, height: 15)
                        .offset(y: -45)
                }
                
                if avatar.accessories.contains("glasses") {
                    HStack(spacing: 8) {
                        Circle()
                            .stroke(.black, lineWidth: 2)
                            .frame(width: 20, height: 20)
                        Circle()
                            .stroke(.black, lineWidth: 2)
                            .frame(width: 20, height: 20)
                    }
                    .offset(y: -5)
                }
                
                if avatar.accessories.contains("earrings") {
                    HStack(spacing: 50) {
                        Circle()
                            .fill(Color(red: 1.0, green: 0.84, blue: 0.0))
                            .frame(width: 6, height: 6)
                        Circle()
                            .fill(Color(red: 1.0, green: 0.84, blue: 0.0))
                            .frame(width: 6, height: 6)
                    }
                    .offset(y: 0)
                }
            }
        }
    }
    
    private var skinToneColor: Color {
        switch avatar.skinTone {
        case "light": return Color(red: 0.98, green: 0.9, blue: 0.8)
        case "medium": return Color(red: 0.9, green: 0.7, blue: 0.5)
        case "dark": return Color(red: 0.6, green: 0.4, blue: 0.3)
        default: return Color(red: 0.98, green: 0.9, blue: 0.8)
        }
    }
    
    private var hairColor: Color {
        switch avatar.hairColor {
        case "brown": return Color(red: 0.6, green: 0.4, blue: 0.2)
        case "black": return Color.black
        case "blonde": return Color(red: 0.9, green: 0.8, blue: 0.6)
        case "red": return Color(red: 0.8, green: 0.4, blue: 0.2)
        default: return Color(red: 0.6, green: 0.4, blue: 0.2)
        }
    }
    
    private var outfitColor: Color {
        switch avatar.outfit {
        case "casual": return Color.blue
        case "formal": return Color(red: 0.2, green: 0.2, blue: 0.2)
        case "sporty": return Color.red
        case "elegant": return Color.purple
        case "business": return Color(red: 0.3, green: 0.3, blue: 0.3)
        case "party": return Color.pink
        case "pajamas": return Color(red: 0.8, green: 0.8, blue: 0.9)
        case "uniform": return Color.green
        case "costume": return Color.orange
        default: return Color.blue
        }
    }
    
    private var pantsColor: Color {
        Color(red: 0.2, green: 0.2, blue: 0.4)
    }
    
    private var shoesColor: Color {
        switch avatar.shoes {
        case "sneakers": return Color(red: 0.8, green: 0.8, blue: 0.8)
        case "formal": return Color.black
        case "sporty": return Color.red
        default: return Color(red: 0.8, green: 0.8, blue: 0.8)
        }
    }
}

// MARK: - Supporting Types

enum AvatarCategory: String, CaseIterable {
    case hair = "Hair"
    case eyes = "Eyes"
    case outfit = "Outfit"
    case accessories = "Accessories"
    case expression = "Expression"
    case body = "Body"
    
    var title: String {
        return rawValue
    }
    
    var icon: String {
        switch self {
        case .hair: return "scissors"
        case .eyes: return "eye"
        case .outfit: return "tshirt"
        case .accessories: return "crown"
        case .expression: return "face.smiling"
        case .body: return "person.fill"
        }
    }
    
    var hasColorOptions: Bool {
        switch self {
        case .hair, .eyes, .outfit:
            return true
        default:
            return false
        }
    }
}

 