# Family Home - Virtual Family Connection App

A SwiftUI iOS app designed to help families maintain long-distance connections through a virtual "home" where family members can interact, share activities, and stay connected.

## Features

### 🏠 Virtual Home
- **2D House Layout**: Interactive living room with customizable rooms and furniture
- **Avatar System**: Personalized avatars for each family member
- **Real-time Updates**: See where family members are and what they're doing
- **Customizable House**: Add rooms, furniture, and personalize your virtual space

### 👥 Family Management
- **Account Creation**: Easy onboarding with avatar customization
- **Family Setup**: Create or join existing families
- **Member Invitations**: Invite family members via email or codes
- **Privacy Controls**: Choose what information to share with family

### 📍 Location Sharing
- **Key Locations**: Set up home, work, gym, store, and other important places
- **Automatic Updates**: Get notified when family members arrive/leave locations
- **Location History**: Track family movement patterns
- **Privacy Settings**: Control location sharing preferences

### 🎮 Family Activities
- **Virtual Dinner**: Eat together synchronously or asynchronously
- **Puzzle Games**: Solve puzzles together as a family
- **Movie Nights**: Watch content together virtually
- **Game Nights**: Play family-friendly games
- **Activity Planning**: Schedule and manage family activities

### 🐾 Virtual Pet
- **Family Pet**: Care for a virtual pet together
- **Pet Status**: Monitor hunger, happiness, and energy levels
- **Care Actions**: Feed, play, and interact with the pet
- **Shared Responsibility**: All family members can contribute to pet care

### 💬 Communication
- **Family Messages**: Real-time messaging between family members
- **Activity Updates**: Share what you're doing with the family
- **Notifications**: Get notified about family activities and updates
- **Location Messages**: Automatic messages when arriving/leaving places

### 📱 Bottom Toolbar Integration
- **Calling/FaceTime**: Integrated calling features
- **Messages**: Family chat and notifications
- **Life360-style**: Location sharing and tracking
- **Calendar**: Family event planning and scheduling

## Technical Architecture

### Data Models
- **User**: Avatar, location, activities, privacy settings
- **Family**: Members, house layout, virtual pet, activities
- **House**: Rooms, furniture, themes, customization
- **Messages**: Family communication and notifications
- **Activities**: Family bonding activities and events

### Key Components
- **AppStateManager**: Central state management and data persistence
- **OnboardingView**: Account creation and avatar customization
- **HouseView**: Main 2D house interface
- **LocationSetupView**: Location configuration
- **ActivityUpdateView**: Activity sharing interface
- **PetCareView**: Virtual pet management
- **FamilyActivitiesView**: Activity planning and management
- **MessagesView**: Family communication
- **FamilySetupView**: Family creation and joining

### Technologies Used
- **SwiftUI**: Modern iOS UI framework
- **CoreLocation**: Location services and tracking
- **UserDefaults**: Local data persistence
- **Combine**: Reactive programming for state management

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- macOS 14.0 or later (for development)

### Installation
1. Clone the repository
2. Open `Home.xcodeproj` in Xcode
3. Select your development team in project settings
4. Build and run the app on a simulator or device

### Configuration
1. **Location Permissions**: The app will request location access for family tracking
2. **Notifications**: Enable notifications for family updates and activities
3. **Camera/Microphone**: Required for calling and FaceTime features

## Usage Guide

### Getting Started
1. **Create Account**: Complete the onboarding process with avatar customization
2. **Set Up Family**: Create a new family or join an existing one
3. **Configure Locations**: Add your key locations (home, work, etc.)
4. **Invite Family**: Send invitations to family members

### Daily Use
1. **Check House**: View the virtual home to see family activity
2. **Update Status**: Share your current activity and location
3. **Care for Pet**: Feed and play with the family pet
4. **Plan Activities**: Schedule family activities and events
5. **Communicate**: Use the messaging system to stay in touch

### Privacy Features
- **Location Sharing**: Toggle location sharing on/off
- **Activity Sharing**: Choose what activities to share
- **Browsing Privacy**: Control browsing history sharing
- **Family Visibility**: Manage what family members can see

## Future Enhancements

### Planned Features
- **3D House**: Upgrade to 3D house visualization
- **Video Calling**: Integrated video chat within the app
- **Smart Notifications**: AI-powered activity suggestions
- **Family Calendar**: Integrated calendar with automatic scheduling
- **Pet Evolution**: Virtual pet growth and development
- **Family Challenges**: Gamified family bonding activities
- **Integration APIs**: Connect with other family apps and services

### Technical Improvements
- **Cloud Sync**: Real-time data synchronization across devices
- **Push Notifications**: Server-side notification delivery
- **Analytics**: Family activity insights and patterns
- **Accessibility**: Enhanced accessibility features
- **Performance**: Optimized rendering and data handling

## Contributing

This is a demonstration project showcasing family connection app concepts. The app is designed to be educational and inspirational for developers interested in building family-focused applications.

## License

This project is for educational purposes. Feel free to use the concepts and code structure for your own family connection applications.

## Support

For questions or feedback about the app concept or implementation, please refer to the code comments and documentation within the project files. 