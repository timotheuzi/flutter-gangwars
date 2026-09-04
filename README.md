# Gangwar 🎮

![Gangwar Logo](assets/images/logo.png)

A high-fidelity, cross-platform Flutter adaptation of the classic Gangwar game, featuring a modern **Flame-powered procedural 3D isometric world**. Available on Android, iOS, Linux, Windows, macOS, and Web.

## 🏙️ Project Overview

Gangwar is a strategic simulation of street life and criminal empire building. Navigate a procedurally generated city, trade in a volatile underground economy, recruit a loyal gang, and defend your turf against rival factions and law enforcement. This adaptation brings the classic gameplay into a high-performance, cross-platform environment with enhanced visual effects and depth.

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.0.0 or higher)
- **Dart SDK** (3.0.0 or higher)
- **Platform Requirements**:
  - **Linux**: `libgtk-3-dev`, `libgstreamer1.0-dev`, `ninja-build`, `libgbm-dev` (Run `make install-linux-deps` on Ubuntu/Debian)
  - **Android**: Android SDK & NDK
  - **iOS/macOS**: Xcode (macOS only)

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

3. **Run the game**:
   ```bash
   make run
   ```

## 📱 Build System & Platform Support

The project includes a robust `Makefile` for automated cross-platform development:

| Target | Command | Description |
|--------|---------|-------------|
| **Debug Run** | `make run` | Runs the app with device auto-detection |
| **Android APK** | `make build-android` | Builds a debug APK |
| **Android Bundle** | `make build-android-bundle` | Builds a release AAB for Google Play |
| **Linux** | `make build-linux` | Builds the Linux desktop bundle |
| **Web** | `make build-web` | Builds the release web version |
| **Windows** | `make build-windows` | Builds the Windows desktop version |
| **Format & Lint** | `make format` / `make lint` | Runs code quality tools |

## 🎯 Key Features

### 💎 Advanced Technical Features
- **Procedural 3D World**: An isometric open world generated in real-time using the **Flame engine**.
- **Noise-Based Terrain**: Custom terrain generation using Simplex-like noise for unique city layouts every play.
- **Dynamic Weather System**: Immersive environmental effects including rain, fog, and day/night transitions.
- **Cinematic Cutscenes**: Tactical gang fight visualizations and story-driven transitions via a dedicated `CutSceneManager`.
- **Procedural Pixel Art**: Dynamic rendering of sprites and UI elements for a consistent retro aesthetic.

### 💰 Core Gameplay
- **Dynamic Economy**: Trade 6 substances (Weed, Crack, Coke, Ice, Percs, Pixie Dust) with prices that fluctuate based on daily events and market trends.
- **Arsenal**: 20+ weapons including pistols, Uzis, grenades, and experimental weaponry like Flamethrowers and Rocket Launchers.
- **Specialized Ammo**: Equip **Hollow Point** or **Exploding Bullets** to gain a tactical edge in combat.
- **Gang Management**: Recruit members, manage morale at the **Pick n Save**, and heal at the **Info Booth**.
- **Financial Strategy**: Use the **Bank** to secure your wealth or take high-risk loans from sharks.
- **Turn-Based Combat**: A robust combat system featuring weapon-specific accuracy, gang participation, and critical hits.

## 🛠️ Technical Stack

- **UI Framework**: Flutter (Material 3)
- **Game Engine**: [Flame](https://flame-engine.org/) (Isometric Rendering & Game Loop)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Persistence**: [SharedPreferences](https://pub.dev/packages/shared_preferences)
- **Graphics**: Custom SVG rendering and Pixel Art typography
- **Logic**: Custom 3D procedural terrain system and combat simulators

## 🏗️ Project Structure

```
lib/
├── models/       # Game state, Combat logic, & Procedural data models
├── providers/    # GameProvider (Global state & Business logic)
├── screens/      # UI Screens (City, Crackhouse, 3D Open World)
├── widgets/      # Procedural renderers, Sprites, & Advanced animations
└── main.dart     # Application entry & Provider initialization
```

## 📖 Documentation

For detailed gameplay instructions and mechanics, please refer to the [USER_GUIDE.md](USER_GUIDE.md).

## 🤝 Contributing

Contributions are welcome! Please follow the existing code style and ensure that all new features include appropriate documentation.

## 🎬 Credits & Support

**Original Game**: Gang War MUD by timotheuzi@hotmail.com

If you enjoy the game and want to support its development, crypto donations are welcome:
- **LTC**: `ltc1qcx3xsrpxqm7q7gpkxhxhtaeqgdqpmq0jdrw7vh`
- **SOL**: `4sAaizpXmFS4yedakv7mLN1Z2myGh2CWnes3YJBhF1Hb`
- **BTC**: `bc1qfv69rux98r7u3sr786j2qpsenmkskvkf58ynkk`
- **ETH**: `0xD1A6b95958dE597c2D9478A3b4212adF0789BF81`

## 🏆 License

This project is licensed under the **MaggotCorp Proprietary License**. See [LICENSE](LICENSE) for details.

**© 2025 MaggotCorp. All rights reserved.**
**Original Game: timotheuzi@hotmail.com**
