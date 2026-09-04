import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';
import '../widgets/comprehensive_sprites.dart';

class GenericLocationScreen extends StatelessWidget {
  final String locationType;

  const GenericLocationScreen({super.key, required this.locationType});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    //final gameState = gameProvider.gameState;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_capitalize(locationType)} - Gangwars'),
        backgroundColor: _getThemeColor(locationType),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _getThemeColor(locationType),
              _getThemeColor(locationType).withValues(alpha: 0.7),
              Colors.black,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                color: Colors.black45,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '🏢 ${_capitalize(locationType).toUpperCase()}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getThemeColor(locationType)
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ComprehensiveSprites.createBuildingSprite(
                        size: 80,
                        type: _mapToBuildingType(locationType),
                        state: BuildingState.idle,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _getLocationDescription(locationType),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Available actions at the $locationType:',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _buildActionButtons(context, gameProvider, locationType),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GameButton(
                text: 'Return to City',
                onPressed: () => gameProvider.navigateToScreen('city'),
                icon: Icons.arrow_back,
                backgroundColor: Colors.brown.shade800,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Color _getThemeColor(String type) {
    return switch (type) {
      'hospital' => Colors.red.shade900,
      'police' => Colors.blue.shade900,
      'store' => Colors.green.shade900,
      'gym' => Colors.orange.shade900,
      'warehouse' => Colors.blueGrey.shade900,
      'hideout' => Colors.indigo.shade900,
      'house' => Colors.brown.shade900,
      _ => Colors.grey.shade900,
    };
  }

  BuildingType _mapToBuildingType(String type) {
    return switch (type) {
      'bank' => BuildingType.bank,
      'bar' => BuildingType.bar,
      'crackhouse' => BuildingType.crackhouse,
      'gunshack' => BuildingType.gunshack,
      'house' => BuildingType.house,
      'hospital' => BuildingType.hospital,
      'police' => BuildingType.police,
      'store' => BuildingType.store,
      _ => BuildingType.store,
    };
  }

  String _getLocationDescription(String type) {
    return switch (type) {
      'hospital' =>
        'The sterile smell of antiseptic barely masks the stench of death. Doctors here don\'t ask questions if you have the cash.',
      'police' =>
        'The precinct is a fortress of state power. Every shadow here feels like a pair of handcuffs.',
      'store' =>
        'A dusty corner shop selling overpriced essentials to those who can\'t leave the neighborhood.',
      'gym' =>
        'The clang of iron and the scent of sweat. A good place to toughen up your crew.',
      'warehouse' =>
        'Rats and rusted crates. The perfect place for a quiet deal or a shallow grave.',
      'hideout' =>
        'A fortified safehouse where you can lie low when the heat gets too high.',
      'house' =>
        'A decaying tenement building. The walls have ears and the doors have three locks.',
      _ => 'A nondescript building in the heart of the urban sprawl.',
    };
  }

  Widget _buildActionButtons(
      BuildContext context, GameProvider gameProvider, String type) {
    switch (type) {
      case 'hospital':
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                if (gameProvider.gameState.spendMoney(2000)) {
                  gameProvider.gameState.heal(100);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Doctors patched you up. Health restored!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No cash, no cure. Get out.')),
                  );
                }
              },
              child: const Text('Full Medical Treatment (\$2,000)'),
            ),
          ],
        );
      case 'police':
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                if (gameProvider.gameState.spendMoney(5000)) {
                  gameProvider.gameState.reputation =
                      (gameProvider.gameState.reputation * 0.5).toInt();
                  gameProvider.gameMessage =
                      'You bribed the precinct. Heat reduced!';
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Bribe accepted. The cops are looking the other way... for now.')),
                  );
                }
              },
              child: const Text('Bribe Officials (\$5,000)'),
            ),
          ],
        );
      case 'gym':
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                if (gameProvider.gameState.spendMoney(1000)) {
                  gameProvider.gameState.maxHealth += 10;
                  gameProvider.gameState.heal(10);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Training complete. Max health increased!')),
                  );
                }
              },
              child: const Text('Gang Training (\$1,000)'),
            ),
          ],
        );
      default:
        return const Text('No special actions available here yet.',
            style: TextStyle(color: Colors.white60));
    }
  }
}
