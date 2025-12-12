import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';
import '../models/random_event.dart';
import 'dart:math';

class AlleywayScreen extends StatelessWidget {
  const AlleywayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alleyway - Droid Gangwar'),
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
              Colors.grey.shade900,
              Colors.grey.shade700,
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
                        '🏙️ DARK ALLEYWAY',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Money: \$${gameState.money}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'The dark alleyway is filled with danger and opportunity. NPCs lurk in the shadows...',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Alleyway Actions:',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _handleNpcEncounter(context, gameProvider),
                            icon: const Icon(Icons.people),
                            label: const Text('Find NPC'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _handleRandomFight(context, gameProvider),
                            icon: const Icon(Icons.sports_mma),
                            label: const Text('Random Fight'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _searchAlleyway(context, gameProvider),
                            icon: const Icon(Icons.search),
                            label: const Text('Search Alleyway'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _findShortcuts(context, gameProvider),
                            icon: const Icon(Icons.explore),
                            label: const Text('Find Shortcuts'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _enterBossRoom(context, gameProvider),
                            icon: Icon(Icons.warning),
                            label: const Text('Boss Room'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (gameProvider.gameMessage.isNotEmpty)
                        Card(
                          color: Colors.black.withOpacity(0.7),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              gameProvider.gameMessage,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
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

  void _handleNpcEncounter(BuildContext context, GameProvider gameProvider) {
    final random = Random();
    final npcTypes = [
      'Street Thug',
      'Shady Dealer',
      'Bouncer',
      'Homeless Person',
      'Corrupt Businessman',
      'Street Punk',
      'Gang Recruit',
      'Drug Addict',
      'Informant',
      'Rival Gang Member'
    ];
    final npcType = npcTypes[random.nextInt(npcTypes.length)];

    final options = <String>[];
    final optionEffects = <String, Map<String, int>>{};

    // Add basic options
    options.add('Fight');
    optionEffects['Fight'] = {'damage': 10};

    options.add('Talk');
    optionEffects['Talk'] = {'health': 5, 'money': 100};

    options.add('Flee');
    optionEffects['Flee'] = {'damage': 5, 'money': -50};

    // Add special options based on NPC type
    if (npcType == 'Shady Dealer' || npcType == 'Corrupt Businessman' || npcType == 'Drug Addict') {
      options.add('Trade Drugs');
      optionEffects['Trade Drugs'] = {'money': -200, 'drugs': 2};
    }

    if (npcType == 'Bouncer' || npcType == 'Street Punk' || npcType == 'Gang Recruit') {
      options.add('Recruit');
      optionEffects['Recruit'] = {'money': -5000, 'members': 1};
    }

    if (npcType == 'Informant' || npcType == 'Homeless Person') {
      options.add('Get Info');
      optionEffects['Get Info'] = {'money': -100, 'reputation': 5};
    }

    if (npcType == 'Rival Gang Member') {
      options.add('Challenge');
      optionEffects['Challenge'] = {'damage': 20, 'reputation': 10};
    }

    final event = RandomEvent(
      id: 'npc_${DateTime.now().millisecondsSinceEpoch}',
      title: 'NPC Encounter: $npcType',
      description: _getNpcDescription(npcType),
      type: EventType.npcEncounter,
      options: options,
      optionEffects: optionEffects,
    );

    _showNpcDialog(context, gameProvider, event);
  }

  String _getNpcDescription(String npcType) {
    return switch (npcType) {
      'Street Thug' => 'A tough-looking thug blocks your path. He looks like he wants trouble. "You lookin\' at me, punk?"',
      'Shady Dealer' => 'A shady character in a trench coat approaches you. "Psst... I got the good stuff. Wanna make a deal?"',
      'Bouncer' => 'A massive bouncer stands guard. He might be useful if you can convince him to join you. "This area is off limits."',
      'Homeless Person' => 'A homeless person mutters to themselves. They might have useful information. "Spare some change, boss?"',
      'Corrupt Businessman' => 'A well-dressed businessman with a shady aura offers you a deal. "I have connections... for the right price."',
      'Street Punk' => 'A young punk with attitude challenges you. He could be a valuable recruit. "You think you\'re tough? Prove it!"',
      'Gang Recruit' => 'A young wannabe gangster looks up to you. "I wanna be like you, boss. Let me join your crew!"',
      'Drug Addict' => 'A twitchy drug addict approaches you. "Man, I need a fix... I can get you anything you want."',
      'Informant' => 'A nervous-looking informant whispers to you. "I know things... dangerous things."',
      'Rival Gang Member' => 'A member of a rival gang spots you. "This is our turf! Get outta here!"',
      _ => 'Someone approaches you in the dark alleyway.',
    };
  }

  void _showNpcDialog(BuildContext context, GameProvider gameProvider, RandomEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.description),
              const SizedBox(height: 15),
              const Text('What do you want to do?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Column(
                children: event.options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleNpcOption(context, gameProvider, event, option);
                      },
                      child: Text(option),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ignore'),
          ),
        ],
      ),
    );
  }

  void _handleNpcOption(BuildContext context, GameProvider gameProvider, RandomEvent event, String option) {
    final effects = event.optionEffects[option] ?? {};
    final gameState = gameProvider.gameState;
    String resultMessage = 'You chose to $option the ${event.title.split(': ').last}.\n\n';

    // Apply effects
    if (effects.containsKey('damage')) {
      gameState.takeDamage(effects['damage']!);
      resultMessage += 'You took ${effects['damage']} damage!\n';
    }

    if (effects.containsKey('health')) {
      gameState.heal(effects['health']!);
      resultMessage += 'You gained ${effects['health']} health!\n';
    }

    if (effects.containsKey('money')) {
      final moneyChange = effects['money']!;
      if (moneyChange > 0) {
        gameState.money += moneyChange;
        resultMessage += 'You gained \$$moneyChange!\n';
      } else {
        if (gameState.money >= -moneyChange) {
          gameState.money += moneyChange;
          resultMessage += 'You lost \$${-moneyChange}!\n';
        } else {
          resultMessage += 'You don\'t have enough money!\n';
        }
      }
    }

    if (effects.containsKey('members')) {
      gameState.members += effects['members']!;
      resultMessage += 'You gained ${effects['members']} gang member(s)!\n';
    }

    if (effects.containsKey('reputation')) {
      gameState.reputation += effects['reputation']!;
      resultMessage += 'Your reputation increased by ${effects['reputation']}!\n';
    }

    if (effects.containsKey('drugs')) {
      // Add random drugs
      final drugs = ['weed', 'crack', 'coke', 'ice', 'percs', 'pixie_dust'];
      final drugType = drugs[Random().nextInt(drugs.length)];
      gameState.drugs.weed += effects['drugs']!;
      resultMessage += 'You obtained some drugs!\n';
    }

    // Handle combat options
    if (option == 'Fight' || option == 'Challenge') {
      final enemyCount = option == 'Challenge' ? 2 : 1;
      gameProvider.startMudFight(50, enemyCount, event.title.split(': ').last, 'npc_fight_${DateTime.now().millisecondsSinceEpoch}');
      return;
    }

    gameProvider.gameMessage = resultMessage;
    gameProvider.saveGameState();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultMessage),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _handleRandomFight(BuildContext context, GameProvider gameProvider) {
    final fightTypes = [
      'Street Thugs',
      'Rival Gang Members',
      'Drug Dealers',
      'Police Officers',
      'Homeless Vigilantes',
      'Alleyway Rats'
    ];
    final enemyType = fightTypes[Random().nextInt(fightTypes.length)];
    final enemyCount = Random().nextInt(3) + 1;
    final enemyHealth = 30 + Random().nextInt(40);

    gameProvider.startMudFight(enemyHealth, enemyCount, enemyType, 'random_fight_${DateTime.now().millisecondsSinceEpoch}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You encountered $enemyCount $enemyType! Prepare for battle!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _searchAlleyway(BuildContext context, GameProvider gameProvider) {
    final random = Random();
    final findings = [
      'You found \$${random.nextInt(500) + 100} in a hidden stash!',
      'You discovered a cache of bullets! +20 bullets added.',
      'You found a rusty knife. +1 knife added to inventory.',
      'You stumbled upon a drug stash! +1kg of random drugs.',
      'You found nothing but trash and rats.',
      'You discovered a hidden passage that leads to another part of the city!',
      'You found a first aid kit! +15 health restored.',
      'You encountered a trap! -10 health and lost \$50.',
    ];

    final finding = findings[random.nextInt(findings.length)];

    if (finding.contains('bullets')) {
      gameProvider.gameState.weapons.bullets += 20;
    } else if (finding.contains('knife')) {
      gameProvider.gameState.weapons.knife += 1;
    } else if (finding.contains('drugs')) {
      final drugs = ['weed', 'crack', 'coke', 'ice', 'percs', 'pixie_dust'];
      final drugType = drugs[random.nextInt(drugs.length)];
      switch (drugType) {
        case 'weed': gameProvider.gameState.drugs.weed += 1;
        case 'crack': gameProvider.gameState.drugs.crack += 1;
        case 'coke': gameProvider.gameState.drugs.coke += 1;
        case 'ice': gameProvider.gameState.drugs.ice += 1;
        case 'percs': gameProvider.gameState.drugs.percs += 1;
        case 'pixie_dust': gameProvider.gameState.drugs.pixieDust += 1;
      }
    } else if (finding.contains('health')) {
      gameProvider.gameState.heal(15);
    } else if (finding.contains('trap')) {
      gameProvider.gameState.takeDamage(10);
      gameProvider.gameState.money -= 50;
    } else if (finding.contains('\$')) {
      final amount = int.parse(finding.split('\$').last.split(' ').first);
      gameProvider.gameState.money += amount;
    }

    gameProvider.gameMessage = finding;
    gameProvider.saveGameState();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(finding),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _findShortcuts(BuildContext context, GameProvider gameProvider) {
    final random = Random();
    final results = [
      'You discovered a shortcut to the Gun Shack! Travel time reduced.',
      'You found a hidden path to the Crackhouse. Your drug deals will be more profitable.',
      'You mapped out a safe route through police territory. Less chance of encounters.',
      'You found a secret entrance to the Bank. Your transactions will be more discreet.',
      'You discovered an underground tunnel system. Faster travel between locations.',
      'You found nothing useful. The alleyways are confusing and dangerous.',
    ];

    final result = results[random.nextInt(results.length)];
    gameProvider.gameMessage = result;

    // Apply some game benefits
    if (result.contains('Gun Shack')) {
      gameProvider.gameState.reputation += 2;
    } else if (result.contains('Crackhouse')) {
      gameProvider.gameState.drugPrices['crack'] = (gameProvider.gameState.drugPrices['crack']! * 0.9).toInt();
    } else if (result.contains('police')) {
      gameProvider.gameState.flags.hasId = true;
    } else if (result.contains('Bank')) {
      gameProvider.gameState.account += 1000;
    }

    gameProvider.saveGameState();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _enterBossRoom(BuildContext context, GameProvider gameProvider) {
    final gameState = gameProvider.gameState;

    // Check if player is ready for boss fight
    if (gameState.health < 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are too weak to face the boss! Heal first.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (gameState.members < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need at least 3 gang members to face the boss!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final bossTypes = [
      'Alley King',
      'Shadow Assassin',
      'Drug Lord',
      'Corrupt Cop',
      'Gang War Veteran'
    ];
    final bossType = bossTypes[Random().nextInt(bossTypes.length)];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('👑 $bossType Challenge'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You have entered the $bossType\'s domain!'),
              const SizedBox(height: 10),
              Text('This powerful enemy guards valuable treasures.'),
              const SizedBox(height: 10),
              Text('Boss Health: 300'),
              Text('Boss Damage: High'),
              Text('Reward: \$5000 and rare weapons'),
              const SizedBox(height: 15),
              const Text('Are you ready to face this challenge?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Retreat'),
          ),
          TextButton(
            onPressed: () {
              gameProvider.startMudFight(300, 1, bossType, 'boss_fight_${DateTime.now().millisecondsSinceEpoch}');
              Navigator.pop(context);
            },
            child: const Text('FIGHT!'),
          ),
        ],
      ),
    );
  }
}
