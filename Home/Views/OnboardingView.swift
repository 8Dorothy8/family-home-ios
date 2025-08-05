import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var currentStep = 0
    @State private var name = ""
    @State private var email = ""
    @State private var avatar = Avatar()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Beautiful gradient background
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
                            Text("Step \(currentStep + 1) of 3")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        ProgressView(value: Double(currentStep), total: 2)
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
                    default:
                        EmptyView()
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
                            if currentStep == 2 {
                                appState.createAccount(name: name, email: email, avatar: avatar)
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentStep += 1
                                }
                            }
                        }) {
                            HStack {
                                Text(currentStep == 2 ? "Create Account" : "Next")
                                    .fontWeight(.semibold)
                                Image(systemName: currentStep == 2 ? "checkmark" : "chevron.right")
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
            VStack(spacing: 15) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Customize Your Avatar")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // Avatar preview with beautiful design
            AvatarPreviewView(avatar: avatar)
                .frame(width: 150, height: 150)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
                )
                .padding(.horizontal)
            
            // Customization options
            VStack(spacing: 20) {
                CustomizationRow(title: "Skin Tone", selection: $avatar.skinTone, options: ["light", "medium", "dark"], icon: "paintbrush.fill")
                CustomizationRow(title: "Hair Style", selection: $avatar.hairStyle, options: ["short", "long", "curly", "straight"], icon: "scissors")
                CustomizationRow(title: "Hair Color", selection: $avatar.hairColor, options: ["brown", "black", "blonde", "red"], icon: "paintpalette.fill")
                CustomizationRow(title: "Eye Color", selection: $avatar.eyeColor, options: ["brown", "blue", "green", "hazel"], icon: "eye.fill")
                CustomizationRow(title: "Clothing", selection: $avatar.clothing, options: ["casual", "formal", "sporty", "elegant"], icon: "tshirt.fill")
            }
            .padding(.horizontal)
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

#Preview {
    OnboardingView()
        .environmentObject(AppStateManager())
} 