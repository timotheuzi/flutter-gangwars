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
      // Player uses the selected weapon, and it's removed from available for others
      if (weapon == 'grenade') {
        if (gameState.weapons.grenades > 0) {
          gameState.weapons.grenades--;
          // Grenade is removed from available map too to prevent gang members using it if it was the last one
          if (availableWeapons.containsKey('grenade')) {
            availableWeapons['grenade'] = availableWeapons['grenade']! - 1;
          }
        } else {
          weapon = 'fists';
        }
      } else if (availableWeapons.containsKey(weapon) && availableWeapons[weapon]! > 0) {
        availableWeapons[weapon] = availableWeapons[weapon]! - 1;
      } else if (weapon != 'fists') {
        // If weapon not available (out of stock or consumed), default to fists
        weapon = 'fists';
      }

      final playerDmg = _getWeaponDamage(weapon, gameState);
      final isAuto = _isAutomatic(weapon, gameState);
      
      if (isAuto) {
        int totalPlayerDmg = 0;
        final shots = weapon == 'pistol' ? 3 : 5; // Fan hammer = 3, others = 5
        for (int s = 1; s <= shots; s++) {
          if (remainingEnemyHealth <= 0) break;
          final shotDmg = max(2, (playerDmg / shots).toInt() + random.nextInt(max(1, (playerDmg / (shots * 2)).toInt())));
          remainingEnemyHealth -= shotDmg;
          totalPlayerDmg += shotDmg;
          result.playerDamageDealt += shotDmg;
          fightLog.add('SHOT $s: ${_getShotDescription(weapon, shotDmg)}');
        }
        result.remainingEnemyHealth = max(0, remainingEnemyHealth);
      } else {
        final actualPlayerDmg = max(5, playerDmg + random.nextInt(max(1, playerDmg ~/ 2)));
        remainingEnemyHealth -= actualPlayerDmg;
        result.playerDamageDealt += actualPlayerDmg;
        result.remainingEnemyHealth = max(0, remainingEnemyHealth);
        fightLog.add(_getPlayerAttackDetail(weapon, gameState, actualPlayerDmg));
      }

      // 2. GANG MEMBERS ATTACK
      if (gameState.members > 1 && remainingEnemyHealth > 0) {
        for (int i = 0; i < gameState.members - 1; i++) {
          if (remainingEnemyHealth <= 0) break;
          
          final memberWeapon = _getStrongestFromMap(availableWeapons);
          if (memberWeapon != 'fists') {
            availableWeapons[memberWeapon] = availableWeapons[memberWeapon]! - 1;
            // Handle actual inventory consumption for consumables
            if (memberWeapon == 'grenade') {
              gameState.weapons.grenades--;
            }
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
    // Grenades are powerful but consumable, gang members only use them if specifically available
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
    return weapon == 'uzi' || weapon == 'machine_gun' || weapon == 'submachine_gun' || weapon == 'ar15';
  }

  static String _getShotDescription(String weapon, int damage) {
    final random = Random();
    final msgs = [
      "A round finds its mark! ($damage damage)",
      "The barrel flashes as a bullet rips into the target! ($damage damage)",
      "Direct hit! Lead tears through flesh! ($damage damage)",
      "The shot connects with brutal efficiency! ($damage damage)",
    ];
    return msgs[random.nextInt(msgs.length)];
  }

  static String _getPlayerAttackDetail(String weapon, GameState gameState, int damage) {
    final random = Random();
    final weapons = gameState.weapons;
    final isFirearm = _isFirearm(weapon);
    
    if (isFirearm && weapons.useExplodingBullets && weapons.explodingBullets > 0) {
      final explodingMsgs = [
        "You fire an exploding bullet that detonates on impact, shredding the enemy's body in a horrific explosion! ($damage damage)",
        "The exploding round screams toward your target and erupts in a devastating blast of shrapnel and fire! ($damage damage)",
        "Your special ammunition detonates with terrifying force, turning your enemy into a cloud of blood and gore! ($damage damage)"
      ];
      return '💥 ${explodingMsgs[random.nextInt(explodingMsgs.length)]}';
    }
    
    if (isFirearm && weapons.useHollowPointBullets && weapons.hollowPointBullets > 0) {
      final hpMsgs = [
        "You fire a hollow point bullet that expands on impact, creating devastating wound channels! ($damage damage)",
        "The hollow point round mushrooms dramatically as it strikes, maximizing tissue damage and stopping power! ($damage damage)",
        "Your specialized ammunition fragments inside the target, causing massive internal trauma and blood loss! ($damage damage)"
      ];
      return '💥 ${hpMsgs[random.nextInt(hpMsgs.length)]}';
    }

    final descriptions = {
      'pistol': [
        "You squeeze off a precise shot from your pistol, the barrel flashing as the bullet screams toward your target! ($damage damage)",
        "Your pistol bucks in your hand as you fire, sending a slug hurtling through the air with deadly intent! ($damage damage)",
        "You line up the sights and pull the trigger, your pistol roaring as it launches death toward your enemy! ($damage damage)"
      ],
      'uzi': [
        "You spray lead with your Uzi, the compact weapon rattling as it stitches holes through your enemies! ($damage damage)",
        "A hail of bullets erupts from your Uzi, turning the battlefield into a leaden nightmare! ($damage damage)",
        "Your submachine gun barks rapidly, sending a stream of hot lead into the fray! ($damage damage)"
      ],
      'ar15': [
        "You unleash a burst from your AR-15, the rifle chattering like an angry mechanical demon! ($damage damage)",
        "The AR-15 roars in your hands, spitting a stream of lead that tears through your enemies! ($damage damage)",
        "Your assault rifle bucks against your shoulder as it unleashes controlled devastation on your foes! ($damage damage)"
      ],
      'sword': [
        "You slice deep with your sword! A limb flies into the mud as you strike with martial artistry! ($damage damage)",
        "The blade whispers death in elegant motion, slipping between ribs to find the enemy's heart! ($damage damage)"
      ],
      'barbed_wire_bat': [
        "You swing your barbed wire bat with savage force, the cruel spikes tearing through flesh and bone! ($damage damage)",
        "The barbed wire-wrapped bat connects with devastating impact, ripping and tearing everything it touches! ($damage damage)"
      ],
      'grenade': [
        "You hurl a grenade that bounces toward your enemies, the fuse hissing as it counts down to oblivion! ($damage damage)",
        "The grenade leaves your hand in a perfect arc, exploding in a shower of deadly shrapnel moments later! ($damage damage)",
        "KABOOM! The grenade detonates in a massive fireball, shredding everything in its radius! ($damage damage)"
      ],
      'knife': [
        "You lunge forward with your knife, the blade flashing as it seeks out vital arteries! ($damage damage)",
        "You drive the blade home with lethal force, twisting and tearing through flesh and muscle! ($damage damage)"
      ],
      'axe': [
        "You bring your axe down with a sickening thud, the heavy blade burying itself in the enemy! ($damage damage)",
        "Your axe cleaves through armor and bone alike, leaving a trail of devastation! ($damage damage)"
      ],
      'vampire_bat': [
        "The vampire bat drinks deeply from your foe, each hit pulsing with dark energy! ($damage damage)",
        "You swing the vampire bat, and it seems to seek out the enemy's lifeblood with every strike! ($damage damage)"
      ],
      'poison_blowgun': [
        "A silent dart flies from your blowgun, carrying a lethal toxin that wracks the enemy with pain! ($damage damage)",
        "The poison dart finds its mark, its toxic payload beginning its deadly work immediately! ($damage damage)"
      ],
      'golden_gun': [
        "THE GOLDEN GUN ROARS! A single golden bullet erupts with the power of a thousand suns! ($damage damage)",
        "You pull the trigger of the Golden Gun, and your enemy simply ceases to exist in a flash of gold! ($damage damage)"
      ],
    };

    final list = descriptions[weapon] ?? ["You attack with savage fury for $damage damage!"];
    return list[random.nextInt(list.length)];
  }

  static String _getEnemyAttackDetail(String enemyType, int damage) {
    final random = Random();
    if (enemyType.contains('Police')) {
      final policeMsgs = [
        "A police officer swings their nightstick with brutal force, the impact cracking against your skull for $damage damage!",
        "Police brutality rains down as the officer's nightstick finds your ribs with bone-crunching impact! ($damage damage)",
        "An officer's pistol shot catches you in the side, the bullet burning a path through your flesh! ($damage damage)"
      ];
      return policeMsgs[random.nextInt(policeMsgs.length)];
    } else if (enemyType.contains('Squidie')) {
      final squidieMsgs = [
        "A Squidie's tentacle whips out with inhuman speed, the slimy appendage lashing across your face! ($damage damage)",
        "The Squidie abomination strikes with its tentacle, the touch burning like acid! ($damage damage)",
        "A Squidie fires their customized pistol, the shot enhanced with signature brutality for $damage damage!"
      ];
      return squidieMsgs[random.nextInt(squidieMsgs.length)];
    } else {
      final gangMsgs = [
        "A gang member fires wildly, their pistol shots spraying the area with hot lead for $damage damage!",
        "The gangster's bat finds your shoulder, the impact sending shockwaves of pain through your body! ($damage damage)",
        "A rival thug unloads their pistol, one shot finding its mark in your chest with burning force! ($damage damage)"
      ];
      return gangMsgs[random.nextInt(gangMsgs.length)];
    }
  }

  static String _getStrongestAvailableWeapon(GameState gameState) {
    final w = gameState.weapons;
    if ((w.bullets > 0 || w.explodingBullets > 0 || w.hollowPointBullets > 0)) {
      if (w.ar15 > 0) return 'ar15';
      if (w.uzis > 0) return 'uzi';
      if (w.pistols > 0) return 'pistol';
    }
    if (w.sword > 0) return 'sword';
    if (w.barbedWireBat > 0) return 'barbed_wire_bat';
    if (w.knife > 0) return 'knife';
    return 'fists';
  }

  static int _getWeaponDamage(String weapon, GameState gameState) {
    int base = switch (weapon) {
      'pistol' => 15,
      'uzi' => 35,
      'ar15' => 50,
      'sword' => 28,
      'barbed_wire_bat' => 22,
      'knife' => 12,
      'grenade' => 180, // Huge damage
      'ghost_gun' => 20,
      'machine_gun' => 55,
      'submachine_gun' => 40,
      'golden_gun' => 1000,
      'axe' => 35,
      'vampire_bat' => 45,
      'brass_knuckles' => 15,
      'poison_blowgun' => 40,
      _ => 8,
    };

    double ammoMult = 1.0;
    if (_isFirearm(weapon)) {
      if (gameState.weapons.useExplodingBullets && gameState.weapons.explodingBullets > 0) {
        ammoMult = 1.8;
      } else if (gameState.weapons.useHollowPointBullets && gameState.weapons.hollowPointBullets > 0) {
        ammoMult = 1.4;
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
    
    // Scale damage for Loan Shark based on loan size
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
