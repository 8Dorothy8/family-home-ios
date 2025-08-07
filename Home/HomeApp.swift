//
//  HomeApp.swift
//  Home
//
//  Created by Dorothy Zhang on 8/3/25.
//

import SwiftUI
// import FirebaseCore

@main
struct HomeApp: App {
    // @StateObject private var firebaseManager = FirebaseManager.shared
    
    init() {
        // Initialize Firebase
        // FirebaseManager.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // .environmentObject(firebaseManager)
        }
    }
}
