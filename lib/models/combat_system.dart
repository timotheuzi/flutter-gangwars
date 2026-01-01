import 'dart:math';
import '../models/game_state.dart';
import '../models/combat_result.dart';

class CombatSystem {
  static CombatResult calculateCombat(
    GameState gameState,
    String weapon,
    String enemyType,
    int enemyCount,
    double enemyHealth,
  ) {
    final result = CombatResult();
    final random = Random();
    final fightLog = result.fightLog;

    // Total enemy health
    final totalEnemyHealth = (enemyHealth * enemyCount).toInt();
    int remainingEnemyHealth = totalEnemyHealth;
    
    // Store initial values for proper animation sync
    result.initialEnemyHealth = totalEnemyHealth;
    result.remainingEnemyHealth = totalEnemyHealth;
    result.initialPlayerHealth = gameState.health;

    // Start fight log
    fightLog.add('*** COMBAT START: ${gameState.gangName} vs $enemyType ***');
    fightLog.add('The air thickens with the stench of fear and blood as battle erupts!');

    int rounds = 0;
    const maxRounds = 10;

    while (remainingEnemyHealth > 0 && gameState.health > 0 && rounds < maxRounds) {
      rounds++;
      fightLog.add('\n--- ROUND $rounds ---');

      // Track available weapons (one weapon per member)
      final availableWeapons = _getAvailableWeaponsMap(gameState);
      
      // 1. PLAYER (Leader) ATTACK
      if (weapon == 'grenade') {
        if (gameState.weapons.grenades > 0) {
          gameState.weapons.grenades--;
          if (availableWeapons.containsKey('grenade')) {
            availableWeapons['grenade'] = availableWeapons['grenade']! - 1;
          }
        } else {
          weapon = 'fists';
        }
      } else if (availableWeapons.containsKey(weapon) && availableWeapons[weapon]! > 0) {
        availableWeapons[weapon] = availableWeapons[weapon]! - 1;
      } else if (weapon != 'fists') {
        weapon = 'fists';
      }

      final playerDmg = _getWeaponDamage(weapon, gameState);
      final isAuto = _isAutomatic(weapon, gameState);
      final isMeleeMultiSwing = weapon == 'sword' || weapon == 'barbed_wire_bat' || weapon == 'axe' || weapon == 'vampire_bat' || weapon == 'knife' || weapon == 'fists' || weapon == 'brass_knuckles';
      
      if (isAuto) {
        // Uzi: 5-7 shots, AR15: 10-15 shots, Pistol (upgraded): 3-4 shots
        int shots = 1;
        if (weapon == 'uzi' || weapon == 'submachine_gun') {
          shots = 5 + random.nextInt(3); // 5-7
        } else if (weapon == 'ar15' || weapon == 'machine_gun' || weapon == 'golden_gun') {
          shots = 10 + random.nextInt(6); // 10-15
        } else if (weapon == 'pistol') {
          shots = 3 + random.nextInt(2); // 3-4
        } else {
          shots = 5;
        }

        for (int s = 1; s <= shots; s++) {
          if (remainingEnemyHealth <= 0) break;
          
          // Accuracy Check
          if (random.nextDouble() > gameState.accuracy) {
            fightLog.add('SHOT $s: ${_getMissDescription(weapon)}');
            continue;
          }

          final shotDmg = max(2, (playerDmg / shots).toInt() + random.nextInt(max(1, (playerDmg / (shots * 2)).toInt())));
          remainingEnemyHealth -= shotDmg;
          result.playerDamageDealt += shotDmg;
          fightLog.add('SHOT $s: ${_getShotDescription(weapon, gameState, shotDmg)}');
        }
        result.remainingEnemyHealth = max(0, remainingEnemyHealth);
      } else if (isMeleeMultiSwing) {
        // Melee weapons swing 1-3 times
        final swings = 1 + random.nextInt(3);
        for (int s = 1; s <= swings; s++) {
          if (remainingEnemyHealth <= 0) break;
          
          if (random.nextDouble() > gameState.accuracy) {
            fightLog.add('SWING $s: ${_getMissDescription(weapon)}');
            continue;
          }
          
          final actualPlayerDmg = max(5, (playerDmg / swings).toInt() + random.nextInt(max(1, playerDmg ~/ 4)));
          remainingEnemyHealth -= actualPlayerDmg;
          result.playerDamageDealt += actualPlayerDmg;
          fightLog.add('SWING $s: ${_getPlayerAttackDetail(weapon, gameState, actualPlayerDmg)}');
        }
        result.remainingEnemyHealth = max(0, remainingEnemyHealth);
      } else {
        // Other single use items like Grenades
        if (random.nextDouble() > gameState.accuracy) {
           fightLog.add(_getMissDescription(weapon));
        } else {
          final actualPlayerDmg = max(5, playerDmg + random.nextInt(max(1, playerDmg ~/ 2)));
          remainingEnemyHealth -= actualPlayerDmg;
          result.playerDamageDealt += actualPlayerDmg;
          result.remainingEnemyHealth = max(0, remainingEnemyHealth);
          fightLog.add(_getPlayerAttackDetail(weapon, gameState, actualPlayerDmg));
        }
      }

      // 2. GANG MEMBERS ATTACK
      if (gameState.members > 1 && remainingEnemyHealth > 0) {
        for (int i = 0; i < gameState.members - 1; i++) {
          if (remainingEnemyHealth <= 0) break;
          
          final memberWeapon = _getStrongestFromMap(availableWeapons);
          if (memberWeapon != 'fists') {
            availableWeapons[memberWeapon] = availableWeapons[memberWeapon]! - 1;
            if (memberWeapon == 'grenade') {
              gameState.weapons.grenades--;
            }
          }
          
          if (random.nextDouble() > (gameState.accuracy - 0.1)) {
            continue;
          }

          final memberDmg = _getWeaponDamage(memberWeapon, gameState);
          final actualDmg = max(2, memberDmg + random.nextInt(max(1, memberDmg ~/ 3)));
          remainingEnemyHealth -= actualDmg;
          result.gangDamageDealt += actualDmg;
          
          fightLog.add('[GANG MEMBER] Attacks with ${memberWeapon.toUpperCase()} for $actualDmg damage!');
        }
        
        result.remainingEnemyHealth = max(0, remainingEnemyHealth);
      }

      // 3. ENEMY COUNTERATTACK
      if (remainingEnemyHealth > 0) {
        final baseEnemyDmg = _calculateEnemyDamage(enemyType, enemyCount, gameState);
        final enemyDmg = max(1, baseEnemyDmg - gameState.weapons.vest);
        gameState.takeDamage(enemyDmg);
        result.totalEnemyDamage += enemyDmg;
        
        fightLog.add(_getEnemyAttackDetail(enemyType, enemyDmg));

        // Critical Hit chance
        if (random.nextDouble() < gameState.squidiesCriticalHitChance) {
          final crit = (enemyDmg * 0.5).toInt();
          gameState.takeDamage(crit);
          result.totalEnemyDamage += crit;
          fightLog.add('*** CRITICAL! $enemyType lands a devastating blow, your lifeblood paints the mud for an extra $crit damage! ***');
        }
      }
    }

    // Determine combat outcome
    fightLog.add('\n--- COMBAT RESULT ---');
    if (gameState.health <= 0) {
      result.defeat = true;
      result.finalMessage = 'FATAL DEATH! Your life is extinguished in a torrent of agony, your body joining countless others in eternal darkness!';
    } else if (remainingEnemyHealth <= 0) {
      result.victory = true;
      result.enemiesKilled = enemyCount;
      result.finalMessage = 'VICTORY! You have annihilated every last one of these wretches, their blood staining the ground!';
      
      final moneyReward = (enemyCount * 500) + random.nextInt(enemyCount * 200);
      gameState.money += moneyReward;
      fightLog.add('Looted \$$moneyReward from the mangled corpses.');
    } else {
      result.finalMessage = 'STALEMATE: The battle ends in a bloody stalemate. Both sides retreat through the mud.';
    }

    fightLog.add(result.finalMessage);
    return result;
  }

  static Map<String, int> _getAvailableWeaponsMap(GameState gameState) {
    final w = gameState.weapons;
    return {
      'ar15': w.ar15,
      'uzi': w.uzis,
      'pistol': w.pistols,
      'sword': w.sword,
      'barbed_wire_bat': w.barbedWireBat,
      'knife': w.knife,
      'machine_gun': w.machineGun,
      'submachine_gun': w.submachineGun,
      'golden_gun': w.goldenGun,
      'ghost_gun': w.ghostGuns,
      'grenade': w.grenades,
      'vampire_bat': w.vampireBat,
      'brass_knuckles': w.brassKnuckles,
      'axe': w.axe,
      'poison_blowgun': w.poisonBlowgun,
    };
  }

  static String _getStrongestFromMap(Map<String, int> weapons) {
    if ((weapons['golden_gun'] ?? 0) > 0) return 'golden_gun';
    if ((weapons['machine_gun'] ?? 0) > 0) return 'machine_gun';
    if ((weapons['ar15'] ?? 0) > 0) return 'ar15';
    if ((weapons['submachine_gun'] ?? 0) > 0) return 'submachine_gun';
    if ((weapons['uzi'] ?? 0) > 0) return 'uzi';
    if ((weapons['pistol'] ?? 0) > 0) return 'pistol';
    if ((weapons['sword'] ?? 0) > 0) return 'sword';
    if ((weapons['axe'] ?? 0) > 0) return 'axe';
    if ((weapons['vampire_bat'] ?? 0) > 0) return 'vampire_bat';
    if ((weapons['barbed_wire_bat'] ?? 0) > 0) return 'barbed_wire_bat';
    if ((weapons['poison_blowgun'] ?? 0) > 0) return 'poison_blowgun';
    if ((weapons['knife'] ?? 0) > 0) return 'knife';
    if ((weapons['brass_knuckles'] ?? 0) > 0) return 'brass_knuckles';
    if ((weapons['ghost_gun'] ?? 0) > 0) return 'ghost_gun';
    if ((weapons['grenade'] ?? 0) > 0) return 'grenade';
    return 'fists';
  }

  static bool _isFirearm(String weapon) {
    return weapon == 'pistol' || 
           weapon == 'uzi' || 
           weapon == 'ar15' || 
           weapon == 'ghost_gun' || 
           weapon == 'machine_gun' || 
           weapon == 'submachine_gun' ||
           weapon == 'golden_gun';
  }

  static bool _isAutomatic(String weapon, GameState gameState) {
    if (weapon == 'pistol' && gameState.pistolUpgraded) return true;
    return weapon == 'uzi' || weapon == 'machine_gun' || weapon == 'submachine_gun' || weapon == 'ar15' || weapon == 'golden_gun';
  }

  static String _getMissDescription(String weapon) {
    final random = Random();
    final isGun = _isFirearm(weapon);
    final msgs = isGun ? [
      "The bullet whizzes past the target's ear! (MISS)",
      "Your shot goes wide, striking a nearby dumpster! (MISS)",
      "Recoil spoils your aim! The round hits the pavement! (MISS)",
      "You pull the trigger but the enemy ducks just in time! (MISS)",
      "A stray gust of wind carries your shot off target! (MISS)",
      "The barrel smokes as your shot disappears into the void! (MISS)",
      "Fear causes your hand to shake, the bullet missing by a mile! (MISS)",
    ] : [
      "You swing wildly but hit only thin air! (MISS)",
      "The enemy sidesteps your clumsy strike! (MISS)",
      "You overextend and stumble, missing your mark! (MISS)",
      "Your weapon grazes their clothing but does no damage! (MISS)",
      "A desperate dodge saves your foe from your blade! (MISS)",
      "You strike the wall instead, sparks flying in the dark! (MISS)",
      "The weight of your weapon causes you to mistime the swing! (MISS)",
    ];
    return msgs[random.nextInt(msgs.length)];
  }

  static String _getShotDescription(String weapon, GameState gameState, int damage) {
    final random = Random();
    final weapons = gameState.weapons;
    
    if (weapons.useExplodingBullets && weapons.explodingBullets > 0) {
      final explodingMsgs = [
        "💥 A micro-detonation erupts inside the target's ribcage! ($damage damage)",
        "💥 Fragments of bone and steel spray outward as the round detonates! ($damage damage)",
        "💥 The target screams as an exploding slug liquefies their internal organs! ($damage damage)",
        "💥 A thunderous boom echoes as a round turns a limb into red mist! ($damage damage)",
      ];
      return explodingMsgs[random.nextInt(explodingMsgs.length)];
    }
    if (weapons.useHollowPointBullets && weapons.hollowPointBullets > 0) {
      final hpMsgs = [
        "🩸 The hollow point mushrooms, carving a jagged canyon through flesh! ($damage damage)",
        "🩸 Hydraulic shock ripples through the target as the lead expands! ($damage damage)",
        "🩸 The heavy slug peels back like a lead flower, shredding muscle! ($damage damage)",
        "🩸 A massive exit wound erupts, painting the mud a darker shade of red! ($damage damage)",
      ];
      return hpMsgs[random.nextInt(hpMsgs.length)];
    }

    final msgs = [
      "A round finds its mark with a wet thud! ($damage damage)",
      "Lead tears through a vital artery, blood jetting into the air! ($damage damage)",
      "Direct hit! The enemy staggers as the bullet shatters their collarbone! ($damage damage)",
      "The shot connects with brutal, clinical efficiency! ($damage damage)",
      "You stitch a line of holes across the wretch's chest! ($damage damage)",
      "The bullet buries itself deep in the enemy's gut, they gasp in agony! ($damage damage)",
    ];
    return msgs[random.nextInt(msgs.length)];
  }

  static String _getPlayerAttackDetail(String weapon, GameState gameState, int damage) {
    final random = Random();
    final weapons = gameState.weapons;
    final isFirearm = _isFirearm(weapon);
    
    if (isFirearm && weapons.useExplodingBullets && weapons.explodingBullets > 0) {
      final explodingMsgs = [
        "You unleash a payload of death, the exploding rounds turning your foe into a grotesque fountain of gore! ($damage damage)",
        "The air screams as your special ammo erupts, shredding meat and melting armor! ($damage damage)",
        "Your bullets detonate with the fury of a dying star, leaving only charred remains! ($damage damage)",
        "A cacophony of explosions marks your target's messy demise! ($damage damage)",
      ];
      return '💥 ${explodingMsgs[random.nextInt(explodingMsgs.length)]}';
    }
    
    if (isFirearm && weapons.useHollowPointBullets && weapons.hollowPointBullets > 0) {
      final hpMsgs = [
        "The hollow point slugs bite deep, expanding into jagged claws that rip the enemy apart from within! ($damage damage)",
        "You fire a series of expanding rounds that turn the target's chest into a cavity of shredded tissue! ($damage damage)",
        "The heavy lead mushrooms with horrific force, maximizing the target's suffering! ($damage damage)",
        "Blood sprays in a wide arc as the hollow points do their grim work! ($damage damage)",
      ];
      return '🩸 ${hpMsgs[random.nextInt(hpMsgs.length)]}';
    }

    final descriptions = {
      'pistol': [
        "The pistol barks like a hellhound, spitting death into the darkness! ($damage damage)",
        "You put a bullet between the enemy's eyes, their skull cracking like an egg! ($damage damage)",
        "Each shot from your handgun is a punctuation mark in a sentence of death! ($damage damage)",
        "Cold steel and hot lead; your pistol delivers a message of finality! ($damage damage)",
      ],
      'uzi': [
        "The Uzi chatters with insane glee, sewing a shroud of lead for your enemies! ($damage damage)",
        "You spray a curtain of fire, the compact weapon dancing in your hands as it destroys! ($damage damage)",
        "A hailstorm of bullets erupts, the Uzi's scream drowning out the target's cries! ($damage damage)",
        "The rapid-fire slaughter leaves the enemy full of jagged, smoking holes! ($damage damage)",
      ],
      'ar15': [
        "The AR-15 roars, a mechanical beast unleashing a torrent of high-velocity destruction! ($damage damage)",
        "You fire with clinical coldness, the rifle's bark signaling another life extinguished! ($damage damage)",
        "A stream of .223 rounds shreds through the gloom, turning the enemy into a sieve! ($damage damage)",
        "The rifle's recoil is the heartbeat of a demon as you unload into the crowd! ($damage damage)",
      ],
      'sword': [
        "The blade sings a song of steel and slaughter, severing limbs with a sickening squelch! ($damage damage)",
        "You carve a path of red through the enemy, your sword thirsty for more lifeblood! ($damage damage)",
        "Steel flashes like lightning in a storm of gore, decapitating the nearest wretch! ($damage damage)",
        "The edge of your blade finds the gaps in their armor, sliding home with lethal grace! ($damage damage)",
      ],
      'barbed_wire_bat': [
        "The bat connects with a wet crunch, the rusted wire tearing chunks of meat away! ($damage damage)",
        "You pulverize the enemy's face, the barbed wire snagging on teeth and bone! ($damage damage)",
        "A savage swing leaves the target a faceless mess of pulp and splinters! ($damage damage)",
        "The rusted spikes bite deep, infecting the wound with the rot of the gutter! ($damage damage)",
      ],
      'grenade': [
        "The world turns into fire and shrapnel as the grenade cleanses the mud! ($damage damage)",
        "The explosion is a thunderous decree of death, erasing your enemies from existence! ($damage damage)",
        "White-hot fragments of steel tear through the air, turning men into meat! ($damage damage)",
        "The shockwave liquefies the target's insides before the fire even reaches them! ($damage damage)",
      ],
      'knife': [
        "The knife slips between ribs, a silent kiss of cold steel to the heart! ($damage damage)",
        "You carve your initials into the enemy's throat, blood jetting over your hands! ($damage damage)",
        "A jagged blade finds a vital artery, a spray of red marking the kill! ($damage damage)",
        "The combat knife is an extension of your own savage intent! ($damage damage)",
      ],
      'axe': [
        "The heavy head of the axe splits the enemy from crown to crotch! ($damage damage)",
        "You deliver a decapitating swing, the head rolling into the filthy mud! ($damage damage)",
        "The axe bites deep into the shoulder, shucking the arm like a corn husk! ($damage damage)",
        "Each swing is a brutal sentence of execution carried out in iron and wood! ($damage damage)",
      ],
      'vampire_bat': [
        "The bat groans as it sips the enemy's warmth, leaving them a shriveled husk! ($damage damage)",
        "Unholy hunger drives the bat as it crushes bone and drinks the essence of the fallen! ($damage damage)",
        "Dark energy pulses from the weapon as it feasts on the agony of the wretches! ($damage damage)",
        "The enemy's life fades into the wood of the bat with every bone-shattering hit! ($damage damage)",
      ],
      'poison_blowgun': [
        "The needle-thin dart carries a cargo of liquid agony into the target's veins! ($damage damage)",
        "The enemy's face turns a necrotic purple as the toxin melts them from within! ($damage damage)",
        "Silent death flies through the air, carrying a venom brewed in the deepest pits! ($damage damage)",
        "The victim collapses, their nervous system screaming in a final, toxic crescendo! ($damage damage)",
      ],
      'golden_gun': [
        "The golden pistol erupts with the majesty of a god, erasing the unworthy! ($damage damage)",
        "A single golden bullet marks the end of a legacy, the air shimmering with power! ($damage damage)",
        "Pure destruction dressed in 24-karat gold; the ultimate tool of execution! ($damage damage)",
        "The target is reduced to atoms in a flash of divine, golden fire! ($damage damage)",
      ],
    };

    final list = descriptions[weapon] ?? ["You unleash a torrent of savage violence for $damage damage!"];
    return list[random.nextInt(list.length)];
  }

  static String _getEnemyAttackDetail(String enemyType, int damage) {
    final random = Random();
    if (enemyType.contains('Police')) {
      final policeMsgs = [
        "A boot-licking officer cracks your ribs with a nightstick, the wood splintering! ($damage damage)",
        "State-sanctioned violence rains down as a baton finds your temple! ($damage damage)",
        "The law barks from the barrel of a service pistol, lead burning through your gut! ($damage damage)",
        "\"SAY YOUR PRAYERS!\" an officer screams while grinding your face into the filth! ($damage damage)",
      ];
      return policeMsgs[random.nextInt(policeMsgs.length)];
    } else if (enemyType.contains('Squidie')) {
      final squidieMsgs = [
        "A barbed tentacle lashes across your chest, carving deep, slimy furrows! ($damage damage)",
        "The Squidie abomination injects a paralytic venom as its beak snaps at your neck! ($damage damage)",
        "An inky void erupts from the Squidie's customized weapon, searing your flesh! ($damage damage)",
        "Eldritch whispers fill your mind as a Squidie assassin carves into your soul! ($damage damage)",
      ];
      return squidieMsgs[random.nextInt(squidieMsgs.length)];
    } else {
      final gangMsgs = [
        "A rival thug puts a bullet in your shoulder, the heat cauterizing the wound! ($damage damage)",
        "A rusted pipe connects with your skull, the sound echoing like a funeral bell! ($damage damage)",
        "A hail of lead from a gutter-punk's pistol stitches a map of pain across your body! ($damage damage)",
        "\"DIE IN THE MUD!\" a rival screams as they drive a jagged shiv into your side! ($damage damage)",
      ];
      return gangMsgs[random.nextInt(gangMsgs.length)];
    }
  }

  static int _getWeaponDamage(String weapon, GameState gameState) {
    int base = switch (weapon) {
      'pistol' => 25,
      'uzi' => 55,
      'ar15' => 110,
      'sword' => 150, // Buffed melee
      'barbed_wire_bat' => 120, // Buffed melee
      'knife' => 60,
      'grenade' => 180,
      'ghost_gun' => 45,
      'machine_gun' => 135,
      'submachine_gun' => 75,
      'golden_gun' => 1000,
      'axe' => 140, // Buffed melee
      'vampire_bat' => 160, // Buffed melee
      'brass_knuckles' => 40,
      'poison_blowgun' => 80,
      _ => 20,
    };

    double ammoMult = 1.0;
    if (_isFirearm(weapon)) {
      if (gameState.weapons.useExplodingBullets && gameState.weapons.explodingBullets > 0) {
        ammoMult = 1.8;
      } else if (gameState.weapons.useHollowPointBullets && gameState.weapons.hollowPointBullets > 0) {
        ammoMult = 1.62;
      }
    }

    base = (base * ammoMult).toInt();
    if (weapon == 'pistol' && gameState.pistolUpgraded) base = (base * 2.2).toInt();

    return base;
  }

  static int _calculateEnemyDamage(String enemyType, int enemyCount, GameState gameState) {
    int base = switch (enemyType) {
      'Police Officers' => 15,
      'Squidie Hit Squad' => 20,
      'Loan Shark Enforcer' => 30,
      _ => 10,
    };
    
    if (enemyType == 'Loan Shark Enforcer') {
       final loanPower = (gameState.loan / 1000).clamp(1.0, 10.0);
       base = (base * loanPower).toInt();
    }
    
    return base * enemyCount;
  }

  static DrugUseResult useDrug(GameState gameState, String drug) {
    final drugCount = switch (drug) {
      'crack' => gameState.drugs.crack,
      'coke' => gameState.drugs.coke,
      'weed' => gameState.drugs.weed,
      'ice' => gameState.drugs.ice,
      'percs' => gameState.drugs.percs,
      'pixie_dust' => gameState.drugs.pixieDust,
      _ => 0,
    };

    if (drugCount <= 0) return DrugUseResult(success: false, message: 'You don\'t have any $drug!');

    switch (drug) {
      case 'crack': gameState.drugs.crack--;
      case 'coke': gameState.drugs.coke--;
      case 'weed': gameState.drugs.weed--;
      case 'ice': gameState.drugs.ice--;
      case 'percs': gameState.drugs.percs--;
      case 'pixie_dust': gameState.drugs.pixieDust--;
    }

    return switch (drug) {
      'crack' => DrugUseResult(success: true, message: 'You consume crack with desperate hunger, your body surging with unholy power! (+30 HP)', healthChange: 30),
      'percs' => DrugUseResult(success: true, message: 'You swallow painkillers, dulling the agony and healing wounds through chemical oblivion! (+15 HP)', healthChange: 15),
      _ => DrugUseResult(success: true, message: 'You ingest $drug, feeling its dark influence course through your veins!', healthChange: 10),
    };
  }

  static (bool, String) fleeCombat() {
    final random = Random();
    if (random.nextDouble() < 0.7) {
      return (true, 'You flee into the shadows like a hunted animal, heart pounding with the terror of the pursuit!');
    } else {
      return (false, 'Your desperate flight fails, and the enemy descends upon you with renewed savagery!');
    }
  }
}

class DrugUseResult {
  final bool success;
  final String message;
  final int healthChange;
  final String temporaryEffect;

  DrugUseResult({
    required this.success,
    required this.message,
    this.healthChange = 0,
    this.temporaryEffect = '',
  });
}
