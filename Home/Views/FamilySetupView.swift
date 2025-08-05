import SwiftUI

struct FamilySetupView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var showingCreateFamily = false
    @State private var showingJoinFamily = false
    @State private var familyName = ""
    @State private var familyCode = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 15) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Connect with Your Family")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Create a new family or join an existing one to start sharing your virtual home")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                
                // Options
                VStack(spacing: 20) {
                    // Create family option
                    Button(action: {
                        showingCreateFamily = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Create New Family")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                Text("Start a new family and invite members")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Join family option
                    Button(action: {
                        showingJoinFamily = true
                    }) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                                .font(.title2)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Join Existing Family")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                Text("Join a family using an invitation code")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Skip option
                Button("Skip for now") {
                    // Create a default family for demo
                    appState.createFamily(name: "My Family")
                }
                .font(.body)
                .foregroundColor(.secondary)
            }
            .navigationTitle("Family Setup")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingCreateFamily) {
            createFamilySheet
        }
        .sheet(isPresented: $showingJoinFamily) {
            joinFamilySheet
        }
    }
    
    private var createFamilySheet: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Create New Family")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    TextField("Family Name", text: $familyName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("This will be the name of your virtual home")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                Spacer()
                
                Button("Create Family") {
                    appState.createFamily(name: familyName)
                    showingCreateFamily = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(familyName.isEmpty)
                .padding()
            }
            .navigationTitle("New Family")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        showingCreateFamily = false
                    }
                }
            }
        }
    }
    
    private var joinFamilySheet: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Join Family")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    TextField("Family Code", text: $familyCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    Text("Enter the invitation code provided by your family member")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                Spacer()
                
                Button("Join Family") {
                    appState.joinFamily(familyId: familyCode)
                    showingJoinFamily = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(familyCode.isEmpty)
                .padding()
            }
            .navigationTitle("Join Family")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        showingJoinFamily = false
                    }
                }
            }
        }
    }
}

#Preview {
    FamilySetupView()
        .environmentObject(AppStateManager())
} 