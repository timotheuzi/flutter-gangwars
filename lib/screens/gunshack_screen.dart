import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';

class GunshackScreen extends StatelessWidget {
  const GunshackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gun Shack - Gangwars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => gameProvider.navigateToScreen('city'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade900,
              Colors.red.shade700,
              Colors.deepPurple.shade600,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '🔫 GUN SHACK',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Money: \$${gameState.money}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Purchase weapons and armor to protect your gang and take down enemies.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Available Weapons:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    _buildWeaponCard(context, 'Pistol', 800, 'pistol'),
                    _buildPistolUpgradeCard(context),
                    _buildWeaponCard(
                      context,
                      'Pistol Bullets (50)',
                      400,
                      'bullets',
                    ),
                    _buildWeaponCard(
                      context,
                      'Hollow Point Bullets (15)',
                      600,
                      'hollow_point_bullets',
                    ),
                    _buildWeaponCard(
                      context,
                      'Exploding Bullets (20)',
                      400,
                      'exploding_bullets',
                    ),
                    _buildWeaponCard(
                      context,
                      'Barb Wired Bat',
                      2000,
                      'barbed_wire_bat',
                    ),
                    _buildWeaponCard(context, 'Uzi', 15000, 'uzi'),
                    _buildWeaponCard(context, 'AR-15', 30000, 'ar15'),
                    _buildWeaponCard(context, 'Grenade', 800, 'grenade'),
                    _buildWeaponCard(
                      context,
                      'Vest (Light)',
                      25000,
                      'vest_light',
                    ),
                    _buildWeaponCard(
                      context,
                      'Vest (Medium)',
                      45000,
                      'vest_medium',
                    ),
                    _buildWeaponCard(
                      context,
                      'Vest (Heavy)',
                      65000,
                      'vest_heavy',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GameButton(
                text: 'Return to City',
                onPressed: () => gameProvider.navigateToScreen('city'),
                icon: Icons.arrow_back,
                backgroundColor: Colors.brown,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeaponCard(
    BuildContext context,
    String weaponName,
    int price,
    String weaponType,
  ) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    // Get current quantity
    final quantity = switch (weaponType) {
      'pistol' => gameState.weapons.pistols,
      'uzi' => gameState.weapons.uzis,
      'ar15' => gameState.weapons.ar15,
      'grenade' => gameState.weapons.grenades,
      'barbed_wire_bat' => gameState.weapons.barbedWireBat,
      'bullets' => gameState.weapons.bullets ~/ 50,
      'hollow_point_bullets' => gameState.weapons.hollowPointBullets ~/ 15,
      'exploding_bullets' => gameState.weapons.explodingBullets ~/ 20,
      'vest_light' => gameState.weapons.vest == 5 ? 1 : 0,
      'vest_medium' => gameState.weapons.vest == 10 ? 1 : 0,
      'vest_heavy' => gameState.weapons.vest == 15 ? 1 : 0,
      _ => 0,
    };

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$weaponName: \$${price.toString()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Owned: $quantity', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                gameProvider.buyWeapon(weaponType);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 40),
              ),
              child: const Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPistolUpgradeCard(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pistol Auto-Upgrade: \$5000',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: gameState.pistolUpgraded,
                  onChanged: (value) {
                    if (value && !gameState.pistolUpgraded) {
                      // Try to buy upgrade
                      if (gameState.money >= 5000) {
                        gameState.money -= 5000;
                        gameState.pistolUpgraded = true;
                        gameProvider.gameMessage =
                            'Pistol upgraded to automatic! 3 shots per turn.';
                        gameProvider.saveGameState();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Not enough money for upgrade!'),
                          ),
                        );
                        // Revert switch
                        return;
                      }
                    } else if (!value && gameState.pistolUpgraded) {
                      // Downgrade (no refund)
                      gameState.pistolUpgraded = false;
                      gameProvider.gameMessage =
                          'Pistol downgraded to single shot.';
                      gameProvider.saveGameState();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Upgrade pistol to automatic (3 shots per turn)',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (gameState.pistolUpgraded)
              const Text(
                'AUTOMATIC MODE ACTIVE',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
