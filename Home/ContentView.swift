//
//  ContentView.swift
//  Home
//
//  Created by Dorothy Zhang on 8/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppStateManager()
    
    var body: some View {
        Group {
            if appState.isLoading {
                LoadingView()
            } else if appState.isOnboarding {
                OnboardingView()
            } else if !appState.isAuthenticated {
                SignInView()
            } else if appState.currentFamily == nil {
                FamilySetupView()
            } else {
                HouseView()
            }
        }
        .environmentObject(appState)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading...")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

struct SignInView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 15) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Welcome Back")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Sign in to your family home")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Sign in form
                VStack(spacing: 20) {
                    TextField("Email Address", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    Button("Sign In") {
                        appState.signIn(email: email)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(email.isEmpty)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Demo sign in
                Button("Demo Sign In") {
                    appState.signIn(email: "demo@example.com")
                }
                .font(.body)
                .foregroundColor(.secondary)
            }
            .navigationTitle("Sign In")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
