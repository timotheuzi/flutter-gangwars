# Gangwar

![Gangwar Logo](assets/images/logo.png)

A cross-platform Flutter adaptation of the classic Gangwar game, now available on Android, iOS, Linux, Windows, macOS, and Web.

## 🎮 About the Game

Gangwar is a strategic street gang simulation game where you build your criminal empire, trade drugs, acquire weapons, and battle rival gangs to dominate the city streets.

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.0.0 or higher)
- **Dart SDK** (3.0.0 or higher)
- **Platform-specific requirements**:
  - **Android**: Android Studio, Java JDK
  - **iOS**: Xcode, macOS
  - **Linux**: Clang, CMake, Ninja, GTK development libraries
  - **Windows**: Visual Studio 2022
  - **Web**: Chrome or Firefox

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/timotheuzi/flutter-gangwars.git
   cd flutter-gangwars
   ```

2. **Install dependencies**:
   ```bash
   make install-deps
   ```
   or manually:
   ```bash
   flutter pub get
   ```

3. **Run the game**:
   ```bash
   make run
   ```

## 📱 Platform-Specific Builds

### Android Build (Google Play Ready)
Build the App Bundle for Google Play:
```bash
flutter build appbundle
```
Output: `build/app/outputs/bundle/release/app-release.aab`

Or build the APK:
```bash
make build-android
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Linux Build
```bash
make build-linux
```
Output: `build/linux/x64/release/bundle/`

### iOS Build
```bash
make build-ios
```
Output: `build/ios/iphoneos/Runner.app`

### Web Build
```bash
make build-web
```
Output: `build/web/`

## 📖 User Guide

For detailed gameplay instructions, check out the [USER_GUIDE.md](USER_GUIDE.md).

## 🎯 Game Features

### Core Gameplay
- **Gang Management**: Recruit members, build reputation, expand your empire
- **Drug Trading**: Buy and sell 6 different drug types with dynamic pricing
- **Weapon System**: Acquire 20+ weapons including pistols, uzis, grenades, and more
- **Combat System**: Turn-based battles with critical hits and gang participation
- **Random Events**: Dynamic street encounters with various outcomes

### Locations
- **Crackhouse**: Buy and sell drugs
- **Gun Shack**: Purchase weapons and ammunition
- **Bank**: Manage finances and take loans
- **Bar**: Gather information and recruit members
- **Info Booth**: Purchase special items and IDs
- **Alleyway**: Explore hidden areas and find surprises
- **Pick n Save**: Manage your gang and buy supplies

### Progression
- **Day/Night Cycle**: Each day brings new challenges and opportunities
- **Reputation System**: Gain street cred to unlock new possibilities
- **Final Battle**: Challenge the Squidie Army when you're strong enough
- **Persistent Saves**: Save your progress and continue later

## 🏗️ Development

### Project Structure

```
gangwar/
├── lib/
│   ├── main.dart                  # App entry point
│   ├── models/                    # Game state & data models
│   ├── providers/                 # State management
│   ├── screens/                   # UI screens
│   └── widgets/                   # Reusable UI components
├── assets/                        # Game assets
├── android/                       # Android configuration (com.gangwar.gangwars)
├── Makefile                       # Build system
├── pubspec.yaml                   # Dependencies
├── README.md                      # Documentation
└── USER_GUIDE.md                  # Gameplay instructions
```

## 🤝 Contributing

Contributions are welcome! Please follow the existing code style and include screenshots for UI changes.

## 🏆 License

This project is licensed under the **MaggotCorp Proprietary License**. See [LICENSE](LICENSE) for details.

**© 2025 MaggotCorp. All rights reserved.**
**Original Game: timotheuzi@hotmail.com**
