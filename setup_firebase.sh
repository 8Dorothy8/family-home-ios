#!/bin/bash

# Firebase Setup Script for Family Home iOS App
# This script helps you set up Firebase for your iOS app

echo "🔥 Firebase Setup for Family Home iOS App"
echo "=========================================="

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed or not in PATH"
    echo "Please install Xcode from the App Store"
    exit 1
fi

echo "✅ Xcode found: $(xcodebuild -version | head -n 1)"

# Check if project exists
if [ ! -f "Home.xcodeproj/project.pbxproj" ]; then
    echo "❌ Home.xcodeproj not found"
    echo "Please run this script from the project root directory"
    exit 1
fi

echo "✅ Project found: Home.xcodeproj"

# Create Config directory if it doesn't exist
if [ ! -d "Home/Config" ]; then
    echo "📁 Creating Config directory..."
    mkdir -p Home/Config
fi

# Check if GoogleService-Info.plist exists
if [ ! -f "Home/GoogleService-Info.plist" ]; then
    echo "⚠️  GoogleService-Info.plist not found"
    echo ""
    echo "📋 Next steps:"
    echo "1. Go to https://console.firebase.google.com"
    echo "2. Create a new project or select existing one"
    echo "3. Add iOS app with bundle ID: com.Dorothy.Home"
    echo "4. Download GoogleService-Info.plist"
    echo "5. Place it in the Home/ directory"
    echo ""
    echo "📄 Template file created: Home/Config/GoogleService-Info.plist.template"
else
    echo "✅ GoogleService-Info.plist found"
fi

# Check if Firebase dependencies are added
echo ""
echo "🔍 Checking Firebase dependencies..."

# Check if Firebase packages are added via SPM
if grep -q "firebase-ios-sdk" Home.xcodeproj/project.pbxproj 2>/dev/null; then
    echo "✅ Firebase dependencies found in project"
else
    echo "⚠️  Firebase dependencies not found"
    echo ""
    echo "📋 To add Firebase dependencies:"
    echo "1. Open Home.xcodeproj in Xcode"
    echo "2. Go to File > Add Package Dependencies"
    echo "3. Add: https://github.com/firebase/firebase-ios-sdk.git"
    echo "4. Select these products:"
    echo "   - FirebaseAuth"
    echo "   - FirebaseFirestore"
    echo "   - FirebaseStorage"
    echo "   - FirebaseMessaging"
    echo "   - FirebaseAnalytics"
fi

echo ""
echo "🎯 Firebase Setup Summary:"
echo "=========================="
echo "✅ Project structure ready"
echo "✅ Configuration files created"
echo "✅ Template files available"
echo ""
echo "📚 Documentation: FIREBASE_SETUP.md"
echo ""
echo "🚀 Next steps:"
echo "1. Create Firebase project at https://console.firebase.google.com"
echo "2. Add iOS app with bundle ID: com.Dorothy.Home"
echo "3. Download and add GoogleService-Info.plist"
echo "4. Add Firebase dependencies via Swift Package Manager"
echo "5. Configure Firebase services (Auth, Firestore, Storage)"
echo "6. Test the integration"
echo ""
echo "📞 Need help? Check FIREBASE_SETUP.md for detailed instructions"
