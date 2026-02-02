import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';
import '../widgets/location_card.dart';
import '../models/random_event.dart';

class CityScreen extends StatelessWidget {
  const CityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('City - Droid Gangwar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Restart Game',
            onPressed: () => _showRestartConfirm(context),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => _showStats(context),
          ],
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
              Colors.purple.shade600,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Player Info Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          gameState.playerName.isNotEmpty
                              ? '${gameState.playerName} - ${gameState.gangName}'
                              : 'New Player',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn(
                                'Health',
                                '${gameState.health}/${gameState.maxHealth}',
                                Icons.favorite),
                            _buildStatColumn('Money', '\$${gameState.money}',
                                Icons.attach_money),
                            _buildStatColumn('Day', gameState.day.toString(),
                                Icons.calendar_today),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: gameState.health / gameState.maxHealth,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        const SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: gameState.steps / gameState.maxSteps,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Gang Members: ${gameState.members} | Reputation: ${gameState.reputation}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Drug Prices
                const Text(
                  'Current Drug Prices:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: gameState.drugPrices.entries.map((entry) {
                    final displayName = entry.key
                        .split('_')
                        .map((word) => word[0].toUpperCase() + word.substring(1))
                        .join(' ');
                    return Chip(
                      label: Text('$displayName: \$${entry.value}/kg'),
                      backgroundColor: Colors.deepPurple.shade100,
                      labelStyle: const TextStyle(color: Colors.deepPurple),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Locations Grid
                const Text(
                  'Explore Locations:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: [
                    LocationCard(
                      title: 'Crackhouse',
                      description: 'Buy and sell drugs',
                      icon: Icons.local_pharmacy,
                      color: Colors.green,
                      onPressed: () =>
                          gameProvider.navigateToScreen('crackhouse'),
                    ),
                    LocationCard(
                      title: 'Gun Shack',
                      description: 'Purchase weapons',
                      icon: Icons.security,
                      color: Colors.red,
                      onPressed: () =>
                          gameProvider.navigateToScreen('gunshack'),
                    ),
                    LocationCard(
                      title: 'Bank',
                      description: 'Manage finances',
                      icon: Icons.account_balance,
                      color: Colors.blue,
                      onPressed: () => gameProvider.navigateToScreen('bank'),
                    ),
                    LocationCard(
                      title: 'Bar',
                      description: 'Gather information',
                      icon: Icons.local_bar,
                      color: Colors.amber,
                      onPressed: () => gameProvider.navigateToScreen('bar'),
                    ),
                    LocationCard(
                      title: 'Info Booth',
                      description: 'Special items',
                      icon: Icons.info,
                      color: Colors.purple,
                      onPressed: () =>
                          gameProvider.navigateToScreen('infobooth'),
                    ),
                    LocationCard(
                      title: 'Alleyway',
                      description: 'Explore hidden areas',
                      icon: Icons.explore,
                      color: Colors.grey,
                      onPressed: () =>
                          gameProvider.navigateToScreen('alleyway'),
                    ),
                    LocationCard(
                      title: 'Pick n Save',
                      description: 'Gang management',
                      icon: Icons.shopping_cart,
                      color: Colors.orange,
                      onPressed: () =>
                          gameProvider.navigateToScreen('picknsave'),
                    ),
                    LocationCard(
                      title: 'Credits',
                      description: 'Game information',
                      icon: Icons.credit_card,
                      color: Colors.teal,
                      onPressed: () => gameProvider.navigateToScreen('credits'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Action Buttons
                GameButton(
                  text: 'Wander the Streets',
                  onPressed: () => _handleWander(context),
                  icon: Icons.directions_walk,
                  backgroundColor: Colors.brown,
                ),

                const SizedBox(height: 10),

                if (gameState.members >= 10)
                  GameButton(
                    text: 'Final Battle',
                    onPressed: () => _startFinalBattle(context),
                    icon: Icons.dangerous,
                    backgroundColor: Colors.red.shade800,
                  ),

                const SizedBox(height: 20),

                // Game Message
                if (gameProvider.gameMessage.isNotEmpty)
                  Card(
                    color: Colors.amber.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        gameProvider.gameMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.brown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.deepPurple),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  void _showStats(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final gameState = gameProvider.gameState;
    final weapons = gameState.weapons;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Player Statistics'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${gameState.playerName}'),
              Text('Gang: ${gameState.gangName}'),
              Text('Day: $gameState.day'),
              Text('Health: ${gameState.health}/${gameState.maxHealth}'),
              Text('Money: \$${gameState.money}'),
              Text('Bank Account: \$${gameState.account}'),
              Text('Loan: \$${gameState.loan}'),
              Text('Gang Members: ${gameState.members}'),
              Text('Reputation: ${gameState.reputation}'),
              Text('Squidies: ${gameState.squidies}'),
              Text('Current Score: ${gameState.currentScore}'),
              const SizedBox(height: 15),
              const Text('Weapons:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              if (weapons.pistols > 0) Text('Pistols: ${weapons.pistols}'),
              if (weapons.totalBullets > 0) Text('Total Bullets: ${weapons.totalBullets}'),
              if (weapons.bullets > 0) Text('Standard Bullets: ${weapons.bullets}'),
              if (weapons.hollowPointBullets > 0) Text('Hollow Point: ${weapons.hollowPointBullets}'),
              if (weapons.explodingBullets > 0) Text('Exploding: ${weapons.explodingBullets}'),
              if (weapons.uzis > 0) Text('Uzis: ${weapons.uzis}'),
              if (weapons.ar15 > 0) Text('AR-15: ${weapons.ar15}'),
              if (weapons.machineGun > 0) Text('Machine Guns: ${weapons.machineGun}'),
              if (weapons.submachineGun > 0) Text('Submachine Guns: ${weapons.submachineGun}'),
              if (weapons.ghostGuns > 0) Text('Ghost Guns: ${weapons.ghostGuns}'),
              if (weapons.goldenGun > 0) Text('Golden Guns: ${weapons.goldenGun}'),
              if (weapons.grenades > 0) Text('Grenades: ${weapons.grenades}'),
              if (weapons.missileLauncher > 0) Text('Missile Launcher: ${weapons.missileLauncher}'),
              if (weapons.missiles > 0) Text('Missiles: ${weapons.missiles}'),
              if (weapons.rocketLauncher > 0) Text('Rocket Launcher: ${weapons.rocketLauncher}'),
              if (weapons.flamethrower > 0) Text('Flamethrowers: ${weapons.flamethrower}'),
              if (weapons.knife > 0) Text('Knives: ${weapons.knife}'),
              if (weapons.sword > 0) Text('Swords: ${weapons.sword}'),
              if (weapons.axe > 0) Text('Axes: ${weapons.axe}'),
              if (weapons.barbedWireBat > 0) Text('Barbed Wire Bats: ${weapons.barbedWireBat}'),
              if (weapons.vampireBat > 0) Text('Vampire Bats: ${weapons.vampireBat}'),
              if (weapons.brassKnuckles > 0) Text('Brass Knuckles: ${weapons.brassKnuckles}'),
              if (weapons.poisonBlowgun > 0) Text('Poison Blowguns: ${weapons.poisonBlowgun}'),
              if (weapons.goldenSword > 0) Text('Golden Swords: ${weapons.goldenSword}'),
              if (weapons.goldenAxe > 0) Text('Golden Axes: ${weapons.goldenAxe}'),
              if (weapons.goldenKnife > 0) Text('Golden Knives: ${weapons.goldenKnife}'),
              if (weapons.goldenUzi > 0) Text('Golden Uzis: ${weapons.goldenUzi}'),
              if (weapons.goldenAr15 > 0) Text('Golden AR-15: ${weapons.goldenAr15}'),
              if (weapons.vest > 0) Text('Body Armor: ${weapons.vest}'),
              const SizedBox(height: 15),
              const Text('Drugs:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Weed: ${gameState.drugs.weed}kg'),
              Text('Crack: ${gameState.drugs.crack}kg'),
              Text('Coke: ${gameState.drugs.coke}kg'),
              Text('Ice: ${gameState.drugs.ice}kg'),
              Text('Percs: ${gameState.drugs.percs}kg'),
              Text('Pixie Dust: ${gameState.drugs.pixieDust}kg'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRestartConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restart Game?'),
        content: const Text('This will wipe all stats and progress. Are you sure you want to start a new legacy?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final gameProvider = Provider.of<GameProvider>(context, listen: false);
              gameProvider.restartGame(keepPersistentData: false);
            },
            child: const Text('RESTART', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleWander(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    // Start the wandering animation
    gameProvider.startWanderingAnimation();

    // Process the wander event after a delay to let animation start
    Future.delayed(const Duration(milliseconds: 500), () {
      final event = gameProvider.wanderWithEvent();

      // If combat started during wandering, complete animation immediately
      if (gameProvider.currentScreen == 'mud_fight') {
        gameProvider.completeWanderingAnimation();
        return;
      }

      if (event == null) {
        // Complete animation after 4 seconds and show message
        Future.delayed(const Duration(seconds: 4), () {
          if (context.mounted) {
            gameProvider.completeWanderingAnimation();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(gameProvider.gameMessage),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
        return;
      }

      // Set the event to be shown by the WanderingAnimation
      gameProvider.currentWanderingEvent.value = event;
    });
  }
  
  
  void _startFinalBattle(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final gameState = gameProvider.gameState;

    // Check requirements
    final hasEnoughMembers = gameState.members >= 10;
    final totalFirearms = gameState.weapons.pistols +
        gameState.weapons.uzis +
        gameState.weapons.ar15 +
        gameState.weapons.machineGun +
        gameState.weapons.submachineGun +
        gameState.weapons.ghostGuns +
        gameState.weapons.goldenGun;
    final hasEnoughGuns = totalFirearms >= gameState.members ~/ 2;
    final hasEnoughBullets =
        gameState.weapons.totalBullets >= gameState.members * 20;

    if (!hasEnoughMembers || !hasEnoughGuns || !hasEnoughBullets) {
      String message =
          'You are not ready to challenge the Squidie Army. You need:\n';
      if (!hasEnoughMembers) message += '\n- At least 10 gang members.';
      if (!hasEnoughGuns) {
        message += '\n- Enough firearms for at least half your gang.';
      }
      if (!hasEnoughBullets) {
        message += '\n- At least 20 bullets (any type) per gang member.';
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Not Ready for Final Battle'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Calculate enemy stats
    final enemyCount = gameState.squidies;
    double baseEnemyHealth = 50.0;
    String squidieUpgradeMessage = '';

    // Scaling based on gang size
    if (gameState.members > 30) {
      baseEnemyHealth *= 2.0;
      baseEnemyHealth += gameState.members * 3;
      squidieUpgradeMessage +=
          '🔴 SQUIDIE UPGRADE: EXPERIMENTAL MILITARY TECH\n';
    } else if (gameState.members > 15) {
      baseEnemyHealth *= 1.5;
      baseEnemyHealth += gameState.members * 2;
      squidieUpgradeMessage += '🟠 SQUIDIE UPGRADE: ADVANCED TACTICAL GEAR\n';
    }

    // Scaling based on wealth
    if (gameState.money > 1000000) {
      baseEnemyHealth *= 1.5;
      squidieUpgradeMessage += '🟡 SQUIDIE UPGRADE: HEAVY ARMOR\n';
    } else if (gameState.money > 500000) {
      baseEnemyHealth *= 1.2;
      squidieUpgradeMessage += '🟢 SQUIDIE UPGRADE: MODERATE ARMOR\n';
    }

    final powerFactor = max(1.0, gameState.members / 5.0);
    final perEnemyHealth = (baseEnemyHealth * powerFactor).toInt();
    final totalEnemyHealth = perEnemyHealth * enemyCount;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ FINAL BATTLE ⚠️'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are about to challenge the entire Squidie Army!'),
              const SizedBox(height: 10);
              Text(
                  'They have gathered all their $enemyCount soldiers to crush you.');
              Text(
                  'Their total health is estimated to be around $totalEnemyHealth.');
              const SizedBox(height: 10);
              Text(squidieUpgradeMessage);
              const SizedBox(height: 10);
              const Text(
                  'This is the final showdown. There is no turning back.');
              const SizedBox(height: 10);
              const Text('Are you ready to become the King?');
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Retreat for Now'),
          ),
          TextButton(
            onPressed: () {
              gameProvider.startMudFight(
                perEnemyHealth,
                enemyCount,
                'Squidie Army',
                'final_battle_${DateTime.now().millisecondsSinceEpoch}',
              );
              Navigator.pop(context);
            },
            child: const Text('TO VICTORY!'),
          ),
        ],
      ),
    );
  }
}