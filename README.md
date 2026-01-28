# Droid Gangwar Flutter

![Droid Gangwar Logo](assets/images/logo.png)

A cross-platform Flutter adaptation of the classic Gangwar game, now available on Android, iOS, Linux, Windows, macOS, and Web.

## 🎮 About the Game

Droid Gangwar is a strategic street gang simulation game where you build your criminal empire, trade drugs, acquire weapons, and battle rival gangs to dominate the city streets.

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

### Linux Build
```bash
make build-linux
```
Output: `build/linux/x64/release/bundle/`

### Android Build
```bash
make build-android
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

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

### Build All Platforms
```bash
make build-all
```

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

### Available Makefile Commands

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make install-deps` | Install dependencies |
| `make upgrade-deps` | Upgrade dependencies |
| `make run` | Run app in debug mode |
| `make run-linux` | Run Linux version |
| `make run-android` | Run Android version |
| `make run-ios` | Run iOS version |
| `make build-linux` | Build Linux release |
| `make build-android` | Build Android APK |
| `make build-ios` | Build iOS app |
| `make build-web` | Build web version |
| `make build-all` | Build all platforms |
| `make test` | Run all tests |
| `make analyze` | Run static code analysis |
| `make format` | Format code |
| `make clean` | Clean build artifacts |
| `make clean-all` | Deep clean all files |
| `make kill` | Kill all Flutter processes |
| `make doctor` | Check Flutter installation |
| `make version` | Show Flutter version |

### Project Structure

```
droid_gangwar_flutter/
├── lib/
│   ├── main.dart                  # App entry point
│   ├── models/                    # Game state & data models
│   │   ├── combat_result.dart
│   │   ├── combat_system.dart
│   │   ├── game_state.dart
│   │   ├── random_event.dart
│   │   └── random_event_data.dart
│   ├── providers/                 # State management
│   │   └── game_provider.dart
│   ├── screens/                   # UI screens
│   │   ├── alleyway_screen.dart
│   │   ├── bank_screen.dart
│   │   ├── bar_screen.dart
│   │   ├── city_screen.dart
│   │   ├── crackhouse_screen.dart
│   │   ├── credits_screen.dart
│   │   ├── gunshack_screen.dart
│   │   ├── infobooth_screen.dart
│   │   ├── main_menu_screen.dart
│   │   ├── main_screen.dart
│   │   ├── mud_fight_screen.dart
│   │   └── picknsave_screen.dart
│   └── widgets/                   # Reusable UI components
│       ├── blood_drop_icon.dart
│       ├── event_animation.dart
│       ├── fight_animation.dart
│       ├── game_button.dart
│       ├── location_card.dart
│       ├── main_menu_background.dart
│       ├── pixel_art_icon.dart
│       ├── pixel_art_location.dart
│       └── pixel_art_member.dart
├── assets/                        # Game assets
│   ├── audio/                     # Sound effects and music
│   ├── data/                      # Game data files
│   ├── fonts/                     # Custom fonts
│   └── images/                    # Images and icons
├── Makefile                       # Build system
├── pubspec.yaml                   # Dependencies
├── README.md                      # Documentation
└── LICENSE                        # License information
```

### Code Style

- Follow **Dart style guide** conventions
- Use **lowerCamelCase** for variables and functions
- Use **UpperCamelCase** for classes and types
- Use **snake_case** for file names
- Keep lines under **80 characters** when possible
- Use **trailing commas** for collections

### Testing

Run tests with:
```bash
make test
```

Run static analysis:
```bash
make analyze
```

Format code:
```bash
make format
```

## 🔧 Configuration

### pubspec.yaml

The project uses the following main dependencies:

- `flutter`: SDK for cross-platform development
- `provider`: State management solution
- `shared_preferences`: Cross-platform persistence
- `flame`: Game engine (optional for future enhancements)
- `audioplayers`: Audio playback
- `flutter_svg`: SVG support

### Platform-Specific Configuration

**Android**: `android/app/build.gradle`
**iOS**: `ios/Runner/Info.plist`
**Linux**: `linux/flutter/generated_plugin_registrant.cc`
**Windows**: `windows/flutter/generated_plugin_registrant.cc`
**macOS**: `macos/Runner/Info.plist`
**Web**: `web/index.html`

## 📦 Deployment

### Android Deployment

1. Build APK:
   ```bash
   make build-android
   ```

2. Build App Bundle:
   ```bash
   make build-android-bundle
   ```

3. Install on device:
   ```bash
   flutter install
   ```

### iOS Deployment

1. Build for release:
   ```bash
   make build-ios
   ```

2. Archive for App Store:
   ```bash
   cd ios && xcodebuild archive && cd ..
   ```

### Linux Deployment

1. Build Linux app:
   ```bash
   make build-linux
   ```

2. Create AppImage:
   ```bash
   appimagetool ./build/linux/x64/release/bundle
   ```

### Windows Deployment

1. Build Windows app:
   ```bash
   flutter build windows --release
   ```

2. Create installer (using NSIS):
   ```bash
   makensis windows_installer.nsi
   ```

### macOS Deployment

1. Build macOS app:
   ```bash
   make build-macos
   ```

2. Create DMG:
   ```bash
   create-dmg ./build/macos/Build/Products/Release
   ```

### Web Deployment

1. Build web app:
   ```bash
   make build-web
   ```

2. Deploy to Firebase:
   ```bash
   firebase deploy
   ```

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature`
3. **Commit your changes**: `git commit -am 'Add some feature'`
4. **Push to the branch**: `git push origin feature/your-feature`
5. **Submit a pull request**

### Contribution Guidelines

- Follow existing code style
- Write tests for new features
- Update documentation
- Keep commits focused and descriptive
- Include screenshots for UI changes

## 📚 Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

## 📝 Changelog

### Version 1.0.0 (Current)
- Complete migration from Android to Flutter
- Cross-platform support for 6 platforms
- All original game features implemented
- Modern UI with Material Design
- Comprehensive build system

## 🎓 Credits

- **Original Game**: Gang War MUD by timotheuzi@hotmail.com
- **Flutter Adaptation**: Built with Flutter for cross-platform support
- **Special Thanks**: Original Gang War community and beta testers

## 📞 Support

For issues, questions, or suggestions:
- **Email**: timotheuzi@hotmail.com
- **GitHub Issues**: https://github.com/timotheuzi/flutter-gangwars/issues

## 🏆 License

This project is licensed under the **MaggotCorp Proprietary License**. See [LICENSE](LICENSE) for details.

**© 2025 MaggotCorp. All rights reserved.**
**Original Game: timotheuzi@hotmail.com**

---

**The streets are now open on all platforms!** 💰🔫🏙️
