import SwiftUI

struct FirebaseTestView: View {
    @StateObject private var firebaseManager = FirebaseManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Firebase Integration Test")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                VStack(spacing: 15) {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                
                VStack(spacing: 10) {
                    Button("Test Sign Up") {
                        testSignUp()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(email.isEmpty || password.isEmpty || name.isEmpty)
                    
                    Button("Test Sign In") {
                        testSignIn()
                    }
                    .buttonStyle(.bordered)
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    Button("Test Family Creation") {
                        testFamilyCreation()
                    }
                    .buttonStyle(.bordered)
                    .disabled(firebaseManager.currentUser == nil)
                }
                .padding()
                
                if firebaseManager.isLoading {
                    ProgressView("Loading...")
                        .padding()
                }
                
                if let error = firebaseManager.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                }
                
                if let user = firebaseManager.currentUser {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Current User:")
                            .fontWeight(.bold)
                        Text("Name: \(user.name)")
                        Text("Email: \(user.email)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                if let family = firebaseManager.currentFamily {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Current Family:")
                            .fontWeight(.bold)
                        Text("Name: \(family.name)")
                        Text("Members: \(family.members.count)")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Firebase Test")
            .alert("Test Result", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func testSignUp() {
        firebaseManager.signUp(name: name, email: email, password: password, avatar: Avatar()) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    alertMessage = "Sign up successful! Welcome \(user.name)"
                    showingAlert = true
                case .failure(let error):
                    alertMessage = "Sign up failed: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
    
    private func testSignIn() {
        firebaseManager.signIn(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    alertMessage = "Sign in successful! Welcome back \(user.name)"
                    showingAlert = true
                case .failure(let error):
                    alertMessage = "Sign in failed: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
    
    private func testFamilyCreation() {
        firebaseManager.createFamily(name: "Test Family") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let family):
                    alertMessage = "Family created successfully! Name: \(family.name)"
                    showingAlert = true
                case .failure(let error):
                    alertMessage = "Family creation failed: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
}

#Preview {
    FirebaseTestView()
}
