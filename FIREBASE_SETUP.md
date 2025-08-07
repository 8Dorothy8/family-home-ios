# 🔥 Firebase Integration Setup Guide

This guide will help you set up Firebase for your Family Home iOS app.

## 📋 Prerequisites

1. **Firebase Account**: Create a free Firebase account at [firebase.google.com](https://firebase.google.com)
2. **Xcode 15.0+**: Latest version of Xcode
3. **iOS 17.0+**: Target iOS version
4. **Apple Developer Account**: For app distribution (optional for development)

## 🚀 Step 1: Create Firebase Project

### 1.1 Create New Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project" or "Add project"
3. Enter project name: `FamilyHome-iOS`
4. Enable Google Analytics (recommended)
5. Choose analytics account or create new one
6. Click "Create project"

### 1.2 Add iOS App
1. In Firebase Console, click the iOS icon (+ Add app)
2. Enter iOS bundle ID: `com.Dorothy.Home`
3. Enter app nickname: `Family Home`
4. Click "Register app"

## 📱 Step 2: Download Configuration File

### 2.1 Download GoogleService-Info.plist
1. Download the `GoogleService-Info.plist` file
2. **Important**: Add this file to your Xcode project:
   - Drag `GoogleService-Info.plist` into your Xcode project
   - Make sure it's added to your main target
   - Place it in the `Home` folder (same level as `HomeApp.swift`)

### 2.2 Verify Configuration
- The file should be visible in your Xcode project navigator
- Make sure it's included in your target's "Copy Bundle Resources"

## 🔧 Step 3: Add Firebase Dependencies

### 3.1 Using Swift Package Manager (Recommended)

1. **Open Xcode** and select your project
2. **Go to File > Add Package Dependencies**
3. **Add these Firebase packages**:

```
https://github.com/firebase/firebase-ios-sdk.git
```

4. **Select these Firebase products**:
   - ✅ FirebaseAuth
   - ✅ FirebaseFirestore
   - ✅ FirebaseStorage
   - ✅ FirebaseMessaging
   - ✅ FirebaseAnalytics

### 3.2 Alternative: Using CocoaPods

If you prefer CocoaPods, create a `Podfile` in your project root:

```ruby
platform :ios, '17.0'

target 'Home' do
  use_frameworks!

  # Firebase
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'

end
```

Then run:
```bash
pod install
```

## 🔐 Step 4: Configure Firebase Services

### 4.1 Authentication Setup
1. In Firebase Console, go to **Authentication**
2. Click **Get started**
3. Enable **Email/Password** authentication:
   - Click "Email/Password" in the Sign-in method tab
   - Enable "Email/Password"
   - Click "Save"

### 4.2 Firestore Database Setup
1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select a location (choose closest to your users)
5. Click **Done**

### 4.3 Storage Setup
1. In Firebase Console, go to **Storage**
2. Click **Get started**
3. Choose **Start in test mode** (for development)
4. Select a location (same as Firestore)
5. Click **Done**

### 4.4 Cloud Messaging Setup
1. In Firebase Console, go to **Cloud Messaging**
2. Click **Get started**
3. Upload your APNs authentication key (optional for now)

## 🏗️ Step 5: Update Your Code

### 5.1 Verify Firebase Configuration

Your `HomeApp.swift` should now look like this:

```swift
import SwiftUI
import FirebaseCore

@main
struct HomeApp: App {
    @StateObject private var firebaseManager = FirebaseManager.shared
    
    init() {
        // Initialize Firebase
        FirebaseManager.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseManager)
        }
    }
}
```

### 5.2 Update AppStateManager

The `AppStateManager` has been updated to work with Firebase. Key changes:

- Integration with `FirebaseManager`
- Real-time data synchronization
- Proper error handling
- Authentication state management

## 🧪 Step 6: Test Your Setup

### 6.1 Build and Run
1. Clean your project (Product > Clean Build Folder)
2. Build and run your app
3. Check Xcode console for any Firebase-related errors

### 6.2 Test Authentication
1. Try creating a new account
2. Try signing in with existing credentials
3. Check Firebase Console > Authentication to see users

### 6.3 Test Firestore
1. Create a family
2. Check Firebase Console > Firestore Database to see data

## 🔒 Step 7: Security Rules

### 7.1 Firestore Security Rules

Update your Firestore security rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Family members can read/write family data
    match /families/{familyId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.members;
    }
    
    // Family members can read/write messages
    match /families/{familyId}/messages/{messageId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in get(/databases/$(database)/documents/families/$(familyId)).data.members;
    }
  }
}
```

### 7.2 Storage Security Rules

Update your Storage security rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can upload their own avatars
    match /avatars/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Family members can upload family photos
    match /families/{familyId}/{allPaths=**} {
      allow read, write: if request.auth != null && 
        request.auth.uid in firestore.get(/databases/(default)/documents/families/$(familyId)).data.members;
    }
  }
}
```

## 🚨 Troubleshooting

### Common Issues

1. **"Firebase not configured" error**
   - Make sure `GoogleService-Info.plist` is added to your project
   - Verify it's included in your target

2. **Build errors with Firebase SDK**
   - Clean build folder (Product > Clean Build Folder)
   - Delete derived data (Window > Projects > Click arrow next to project > Delete)
   - Rebuild project

3. **Authentication not working**
   - Check Firebase Console > Authentication > Sign-in methods
   - Verify Email/Password is enabled
   - Check your security rules

4. **Firestore not working**
   - Check Firebase Console > Firestore Database
   - Verify database is created
   - Check security rules

### Debug Mode

Enable Firebase debug mode by adding this to your `AppDelegate` or `HomeApp`:

```swift
#if DEBUG
import FirebaseCore
FirebaseApp.configure()
#endif
```

## 📊 Step 8: Analytics and Monitoring

### 8.1 Enable Analytics
1. In Firebase Console, go to **Analytics**
2. Click **Get started**
3. Follow the setup instructions

### 8.2 Monitor Usage
1. Check **Authentication** for user sign-ups
2. Check **Firestore** for data usage
3. Check **Storage** for file uploads
4. Check **Analytics** for app usage

## 🎯 Next Steps

1. **Push Notifications**: Set up Firebase Cloud Messaging
2. **Crashlytics**: Add crash reporting
3. **Performance**: Monitor app performance
4. **A/B Testing**: Test different features
5. **Remote Config**: Configure app remotely

## 📞 Support

- **Firebase Documentation**: [firebase.google.com/docs](https://firebase.google.com/docs)
- **Firebase Community**: [firebase.google.com/community](https://firebase.google.com/community)
- **Stack Overflow**: Tag questions with `firebase` and `ios`

## 🔄 Version Control

Don't forget to:

1. **Add to .gitignore**:
   ```
   # Firebase
   GoogleService-Info.plist
   ```

2. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Add Firebase integration"
   git push origin main
   ```

---

**🎉 Congratulations!** Your Family Home app is now connected to Firebase and ready for real-time family interactions!
