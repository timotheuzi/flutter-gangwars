import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/procedural_pixel_art.dart';
import '../widgets/procedural_renderer.dart';
import 'dart:math';

class ProceduralDemoScreen extends StatelessWidget {
  const ProceduralDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final generator = ProceduralPixelArt(seed: gameProvider.gameState.day);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Procedural Pixel Art Demo'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => gameProvider.navigateToScreen('city'),
          ),
        ],
      ),
      body: ProceduralRenderer(
        generator: generator,
        pixelSize: 6,
        showGrid: true,
        gridColor: Colors.white12,
      ),
    );
  }
}

/// Procedural Pixel Art Demo Widget
/// Shows how the procedural system can be integrated into game screens
class ProceduralGameDemo extends StatelessWidget {
  final ProceduralPixelArt generator;

  const ProceduralGameDemo({super.key, required this.generator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Procedural Game Demo'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Procedural Cityscape
              const Text(
                'Procedural Cityscape',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildCityscapeDemo(),

              const SizedBox(height: 30),

              // Procedural Characters
              const Text(
                'Procedural Characters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildCharacterDemo(),

              const SizedBox(height: 30),

              // Procedural Buildings
              const Text(
                'Procedural Buildings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildBuildingDemo(),

              const SizedBox(height: 30),

              // Procedural Combat
              const Text(
                'Procedural Combat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildCombatDemo(),

              const SizedBox(height: 30),

              // Procedural Events
              const Text(
                'Procedural Events',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildEventDemo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityscapeDemo() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Generated City: Day ${DateTime.now().day}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              height: 200,
              child: CustomPaint(
                painter: CityscapePainter(generator: generator, pixelSize: 4),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Each day generates a unique city layout with different building arrangements, colors, and details.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterDemo() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Character Variants',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCharacterVariant(CharacterType.gangster, 'Gangster'),
                _buildCharacterVariant(CharacterType.dealer, 'Dealer'),
                _buildCharacterVariant(CharacterType.prostitute, 'Prostitute'),
                _buildCharacterVariant(CharacterType.victim, 'Victim'),
                _buildCharacterVariant(CharacterType.police, 'Police'),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Each character type has unique animations and visual characteristics.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuildingDemo() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Building Types',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBuildingVariant(BuildingType.crackhouse, 'Crackhouse'),
                _buildBuildingVariant(BuildingType.gunshack, 'Gun Shack'),
                _buildBuildingVariant(BuildingType.bank, 'Bank'),
                _buildBuildingVariant(BuildingType.bar, 'Bar'),
                _buildBuildingVariant(BuildingType.alleyway, 'Alleyway'),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Each building type has unique architecture and interactive elements.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatDemo() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Combat Animations',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCombatVariant(WeaponType.pistol, 'Pistol Fight'),
                _buildCombatVariant(WeaponType.uzi, 'Uzi Fight'),
                _buildCombatVariant(WeaponType.knife, 'Knife Fight'),
                _buildCombatVariant(WeaponType.bat, 'Bat Fight'),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Dynamic combat animations with weapon-specific movements and effects.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDemo() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Random Events',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEventCard('Drug Deal', Icons.local_drink, Colors.green),
                _buildEventCard('Prostitution', Icons.local_bar, Colors.purple),
                _buildEventCard('Mugging', Icons.warning, Colors.orange),
                _buildEventCard('Police Raid', Icons.security, Colors.blue),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Procedurally generated events with unique animations and outcomes.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterVariant(CharacterType type, String name) {
    final character = generator.generateCharacter(type: type);
    return Column(
      children: [
        Text(name, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        SizedBox(
          width: 64,
          height: 64,
          child: CustomPaint(
            painter: CharacterPainter(character: character, pixelSize: 4),
          ),
        ),
      ],
    );
  }

  Widget _buildBuildingVariant(BuildingType type, String name) {
    final building = generator.generateBuilding(type: type);
    return Column(
      children: [
        Text(name, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        SizedBox(
          width: 64,
          height: 64,
          child: CustomPaint(
            painter: BuildingPainter(building: building, pixelSize: 4),
          ),
        ),
      ],
    );
  }

  Widget _buildCombatVariant(WeaponType type, String name) {
    final weapon = generator.generateWeapon(type: type);
    return Column(
      children: [
        Text(name, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        SizedBox(
          width: 64,
          height: 64,
          child: CustomPaint(
            painter: WeaponPainter(weapon: weapon, pixelSize: 4),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(String title, IconData icon, Color color) {
    return Card(
      color: color.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 5),
            Text(title, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}

// Custom painters for the demo

class CityscapePainter extends CustomPainter {
  final ProceduralPixelArt generator;
  final int pixelSize;

  CityscapePainter({required this.generator, required this.pixelSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Generate cityscape
    final environment = generator.generateEnvironment(
      type: EnvironmentType.city,
      variant: DateTime.now().day,
    );

    // Draw background
    for (int y = 0; y < environment.pixels.length; y++) {
      for (int x = 0; x < environment.pixels[y].length; x++) {
        if (environment.pixels[y][x] != Colors.transparent) {
          paint.color = environment.pixels[y][x];
          canvas.drawRect(
            Rect.fromLTWH(
              x * pixelSize.toDouble(),
              y * pixelSize.toDouble(),
              pixelSize.toDouble(),
              pixelSize.toDouble(),
            ),
            paint,
          );
        }
      }
    }

    // Add some animated elements
    final time = DateTime.now().millisecondsSinceEpoch / 1000;
    final offsetX = (sin(time) * 20).toInt();

    // Draw some moving characters
    final character = generator.generateCharacter(
      type: CharacterType.gangster,
      variant: 1,
    );

    for (int i = 0; i < 3; i++) {
      final charX = (i * 50 + offsetX) % 350;
      final charY = 150;

      for (int y = 0; y < character.pixels.length; y++) {
        for (int x = 0; x < character.pixels[y].length; x++) {
          if (character.pixels[y][x] != Colors.transparent) {
            paint.color = character.pixels[y][x];
            canvas.drawRect(
              Rect.fromLTWH(
                (charX + x) * pixelSize.toDouble(),
                (charY + y) * pixelSize.toDouble(),
                pixelSize.toDouble(),
                pixelSize.toDouble(),
              ),
              paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CityscapePainter oldDelegate) =>
      oldDelegate.generator != generator || oldDelegate.pixelSize != pixelSize;
}

class CharacterPainter extends CustomPainter {
  final ProceduralCharacter character;
  final int pixelSize;

  CharacterPainter({required this.character, required this.pixelSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int y = 0; y < character.pixels.length; y++) {
      for (int x = 0; x < character.pixels[y].length; x++) {
        if (character.pixels[y][x] != Colors.transparent) {
          paint.color = character.pixels[y][x];
          canvas.drawRect(
            Rect.fromLTWH(
              x * pixelSize.toDouble(),
              y * pixelSize.toDouble(),
              pixelSize.toDouble(),
              pixelSize.toDouble(),
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CharacterPainter oldDelegate) =>
      oldDelegate.character != character || oldDelegate.pixelSize != pixelSize;
}

class BuildingPainter extends CustomPainter {
  final ProceduralBuilding building;
  final int pixelSize;

  BuildingPainter({required this.building, required this.pixelSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int y = 0; y < building.pixels.length; y++) {
      for (int x = 0; x < building.pixels[y].length; x++) {
        if (building.pixels[y][x] != Colors.transparent) {
          paint.color = building.pixels[y][x];
          canvas.drawRect(
            Rect.fromLTWH(
              x * pixelSize.toDouble(),
              y * pixelSize.toDouble(),
              pixelSize.toDouble(),
              pixelSize.toDouble(),
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant BuildingPainter oldDelegate) =>
      oldDelegate.building != building || oldDelegate.pixelSize != pixelSize;
}

class WeaponPainter extends CustomPainter {
  final ProceduralWeapon weapon;
  final int pixelSize;

  WeaponPainter({required this.weapon, required this.pixelSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int y = 0; y < weapon.pixels.length; y++) {
      for (int x = 0; x < weapon.pixels[y].length; x++) {
        if (weapon.pixels[y][x] != Colors.transparent) {
          paint.color = weapon.pixels[y][x];
          canvas.drawRect(
            Rect.fromLTWH(
              x * pixelSize.toDouble(),
              y * pixelSize.toDouble(),
              pixelSize.toDouble(),
              pixelSize.toDouble(),
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant WeaponPainter oldDelegate) =>
      oldDelegate.weapon != weapon || oldDelegate.pixelSize != pixelSize;
}
