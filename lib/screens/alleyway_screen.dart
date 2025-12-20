import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';
import '../models/random_event.dart';
import 'dart:math';

class AlleywayScreen extends StatefulWidget {
  const AlleywayScreen({super.key});

  @override
  State<AlleywayScreen> createState() => _AlleywayScreenState();
}

class _AlleywayScreenState extends State<AlleywayScreen> {
  // Simple dungeon navigation system
  int currentX = 0;
  int currentY = 0;
  Set<String> visitedRooms = {};
  Map<String, String> roomDescriptions = {};
  Map<String, List<String>> roomEvents = {};

  @override
  void initState() {
    super.initState();
    _generateDungeon();
  }

  void _generateDungeon() {
    // Generate a simple 5x5 dungeon layout with random rooms
    final random = Random();
    for (int x = -2; x <= 2; x++) {
      for (int y = -2; y <= 2; y++) {
        final roomKey = '$x,$y';
        visitedRooms.add(roomKey);

        // Generate room description
        final roomTypes = [
          'a narrow alley littered with broken bottles and syringes',
          'a dark corner where rats scurry through piles of garbage',
          'a shadowy junction where multiple alleys converge',
          'an abandoned warehouse entrance, doors hanging off hinges',
          'a bloody scene where a recent fight took place',
          'a drug dealer\'s stash spot, hidden behind rusted dumpsters',
          'a dead end blocked by crumbling brick walls',
          'a makeshift shelter where homeless people huddle',
          'a hidden courtyard overgrown with weeds and debris',
          'a underground access point with a manhole cover',
        ];
        roomDescriptions[roomKey] = roomTypes[random.nextInt(roomTypes.length)];

        // Generate room events
        final events = [
          'You hear footsteps echoing in the distance...',
          'A rat bites at your ankle, drawing blood!',
          'You find a discarded wallet with some cash inside.',
          'The stench of decay is overwhelming here.',
          'Fresh blood stains the ground - someone died here recently.',
          'You spot shadowy figures watching from afar.',
          'The wind carries the sound of distant gunfire.',
          'Broken syringes crunch underfoot.',
          'A homeless person begs for spare change.',
          'You find a hidden cache of drugs.',
        ];
        roomEvents[roomKey] = [events[random.nextInt(events.length)]];
      }
    }
  }

  void _moveDirection(String direction) {
    setState(() {
      switch (direction) {
        case 'north': currentY += 1; break;
        case 'south': currentY -= 1; break;
        case 'east': currentX += 1; break;
        case 'west': currentX -= 1; break;
      }
      // Keep within bounds
      currentX = currentX.clamp(-2, 2);
      currentY = currentY.clamp(-2, 2);
    });
  }

  bool _canMove(String direction) {
    int testX = currentX;
    int testY = currentY;
    switch (direction) {
      case 'north': testY += 1; break;
      case 'south': testY -= 1; break;
      case 'east': testX += 1; break;
      case 'west': testX -= 1; break;
    }
    return testX >= -2 && testX <= 2 && testY >= -2 && testY <= 2;
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;
    final currentRoomKey = '$currentX,$currentY';
    final roomDesc = roomDescriptions[currentRoomKey] ?? 'an unknown alleyway';
    final roomEvent = roomEvents[currentRoomKey]?.first ?? '';

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
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.shade800,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '🏙️ DARK ALLEYWAY',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade300,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Money: \$${gameState.money}',
                      style: TextStyle(fontSize: 18, color: Colors.yellow.shade200, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You are in $roomDesc.',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade200, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      roomEvent,
                      style: TextStyle(fontSize: 14, color: Colors.red.shade300, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Location: ($currentX, $currentY)',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Navigation Controls
                      const Text(
                        'Navigate:',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // North
                          ElevatedButton.icon(
                            onPressed: _canMove('north') ? () => _moveDirection('north') : null,
                            icon: const Icon(Icons.arrow_upward),
                            label: const Text('North'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _canMove('north') ? Colors.green.shade700 : Colors.grey.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // West
                          ElevatedButton.icon(
                            onPressed: _canMove('west') ? () => _moveDirection('west') : null,
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('West'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _canMove('west') ? Colors.green.shade700 : Colors.grey.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // East
                          ElevatedButton.icon(
                            onPressed: _canMove('east') ? () => _moveDirection('east') : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('East'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _canMove('east') ? Colors.green.shade700 : Colors.grey.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // South
                          ElevatedButton.icon(
                            onPressed: _canMove('south') ? () => _moveDirection('south') : null,
                            icon: const Icon(Icons.arrow_downward),
                            label: const Text('South'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _canMove('south') ? Colors.green.shade700 : Colors.grey.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Room Actions
                      const Text(
                        'Room Actions:',
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
                            label: const Text('Search Area'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _findShortcuts(context, gameProvider),
                            icon: const Icon(Icons.explore),
                            label: const Text('Look Around'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          if (currentX == 0 && currentY == 0) // Boss room at center
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
      'Street Thug' => 'A scarred thug with fresh blood on his knuckles blocks your path. His eyes are wild with rage and cheap booze. "You lookin\' at me, punk? I\'ll carve your fuckin\' eyes out!" The stench of sweat and violence surrounds him.',
      'Shady Dealer' => 'A gaunt figure in a blood-stained trench coat emerges from the shadows. Track marks line his arms like railroad tracks to hell. "Psst... I got the pure shit. But cross me and you\'ll be beggin\' for death."',
      'Bouncer' => 'A mountain of a man with broken teeth and prison tattoos guards the entrance. His fists are the size of sledgehammers, scarred from countless beatings. "This area is off limits, or I\'ll snap your spine like a twig."',
      'Homeless Person' => 'A wretched vagrant covered in filth and open sores mutters incoherently. His eyes dart wildly, seeing ghosts in the darkness. "Spare some change, boss? Or I\'ll slit your throat while you sleep..."',
      'Corrupt Businessman' => 'A suited predator with gold rings stained red approaches with a crocodile smile. His manicured hands hide the blood of countless betrayals. "I have connections... for the right price. Or I\'ll have your family fed to the dogs."',
      'Street Punk' => 'A feral youth with a switchblade and dead eyes challenges you. His face is a roadmap of scars from street fights gone wrong. "You think you\'re tough? I\'ll gut you like a fish and leave you bleeding in the gutter!"',
      'Gang Recruit' => 'A desperate kid with fresh bruises and borrowed clothes looks up at you with hungry eyes. His hands tremble from withdrawal and fear. "I wanna be like you, boss. Let me join your crew... or I\'ll die trying."',
      'Drug Addict' => 'A skeletal junkie with rotting teeth and haunted eyes staggers toward you. Pus oozes from infected wounds as he twitches violently. "Man, I need a fix... I can get you anything you want. Just don\'t let me die alone."',
      'Informant' => 'A twitchy rat with yellow teeth and a face like melted wax whispers urgently. He reeks of fear and cheap cologne. "I know things... dangerous things. But if I talk, they\'ll cut out my tongue and feed it to me."',
      'Rival Gang Member' => 'A hardened killer from a rival crew spots you, his hand instinctively going for the gun in his waistband. Fresh blood stains his clothes from his last victim. "This is our turf! I\'ll paint these walls with your brains!"',
      _ => 'A shadowy figure approaches through the fog of blood and despair in the dark alleyway.',
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
