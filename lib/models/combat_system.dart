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

    // Determine player damage based on weapon
    int playerDamage = _getWeaponDamage(weapon, gameState);

    // Calculate total enemy health
    final totalEnemyHealth = enemyHealth * enemyCount;
    int remainingEnemyHealth = totalEnemyHealth.toInt();

    // Combat simulation
    int rounds = 0;
    const maxRounds = 10;

    while (remainingEnemyHealth > 0 &&
        gameState.health > 0 &&
        rounds < maxRounds) {
      rounds++;

      // Player attack
      final playerAttackDamage =
          max(5, playerDamage + random.nextInt(playerDamage ~/ 2));
      remainingEnemyHealth -= playerAttackDamage;
      result.playerDamageDealt += playerAttackDamage;

      // Gritty attack descriptions
      final attackDescriptions = [
        'You $weapon them with savage fury! Blood sprays across the mud for $playerAttackDamage damage!',
        'Your $weapon rips through their flesh and bone, $playerAttackDamage chunks of gore flying into the muck!',
        'You smash your $weapon into their skull, brains and blood mixing in the filth for $playerAttackDamage damage!',
        'The $weapon tears open their stomach, intestines spilling into the gutter for $playerAttackDamage damage!',
        'You drive your $weapon through their chest, blood bubbling from punctured lungs for $playerAttackDamage damage!',
        'A brutal strike with your $weapon leaves them gasping in a pool of their own blood for $playerAttackDamage damage!',
      ];
      
      // Weapon specific descriptions
      String weaponMsg = attackDescriptions[random.nextInt(attackDescriptions.length)];
      if (weapon == 'sword') {
        weaponMsg = 'You slice deep with your sword! A limb flies into the mud for $playerAttackDamage damage!';
      } else if (weapon == 'barbed_wire_bat') {
        weaponMsg = 'The barbed wire bat shreds their face into a bloody pulp for $playerAttackDamage damage!';
      }
      
      fightLog.add(weaponMsg);

      // Gang attack (if player has gang members)
      if (gameState.members > 1) {
        final gangDamage =
            (gameState.members * 3) + random.nextInt(gameState.members * 2);
        remainingEnemyHealth -= gangDamage;
        result.gangDamageDealt += gangDamage;

        final gangAttackDescriptions = [
          'Your crew unleashes a slaughter! $gangDamage damage worth of blades and bullets!',
          'The gang swarms like hungry wolves, tearing them apart for $gangDamage damage!',
          'Your boys stomp them into the bloody mud for $gangDamage damage!',
          'The crew turns the alley into a meat grinder, $gangDamage damage of carnage!',
          'Your gang executes them with cold brutality, $gangDamage damage of gore!',
        ];
        fightLog.add(gangAttackDescriptions[random.nextInt(gangAttackDescriptions.length)]);
      }

      // Enemy counterattack
      if (remainingEnemyHealth > 0) {
        final enemyDamage =
            _calculateEnemyDamage(enemyType, enemyCount, gameState);
        final actualDamage = max(1, enemyDamage - gameState.weapons.vest);
        gameState.takeDamage(actualDamage);
        result.totalEnemyDamage += actualDamage;

        final counterAttackDescriptions = [
          '$enemyType retaliate with dying rage! $actualDamage damage of bloody violence!',
          'The $enemyType slash back in desperation! $actualDamage damage rips through your skin!',
          '$enemyType unleash their death throes, wounding you for $actualDamage damage!',
          'The surviving $enemyType lash out, their strikes covered in gore for $actualDamage damage!',
          '$enemyType counter with savage brutality! $actualDamage damage of pure pain!',
        ];
        fightLog.add(counterAttackDescriptions[random.nextInt(counterAttackDescriptions.length)]);
      }

      // Check for critical hits
      if (random.nextDouble() < gameState.squidiesCriticalHitChance) {
        final enemyDamage =
            _calculateEnemyDamage(enemyType, enemyCount, gameState);
        final criticalDamage = (enemyDamage * 1.5).toInt();
        gameState.takeDamage(criticalDamage);
        result.totalEnemyDamage += criticalDamage;

        final criticalDescriptions = [
          'CRITICAL HIT! $enemyType lands a devastating blow, your lifeblood paints the mud for $criticalDamage damage!',
          'CRITICAL HIT! $enemyType tears a chunk of meat from your arm! $criticalDamage damage!',
          'CRITICAL HIT! $enemyType rips your side open! $criticalDamage damage of shredded flesh!',
          'CRITICAL HIT! $enemyType smashes your face into the muck! $criticalDamage damage!',
          'CRITICAL HIT! $enemyType unleashes a fatal strike! $criticalDamage damage of agony!',
        ];
        fightLog.add(criticalDescriptions[random.nextInt(criticalDescriptions.length)]);
      }
    }

    // Determine combat outcome
    if (gameState.health <= 0) {
      result.defeat = true;
      result.finalMessage =
          'The streets have claimed another soul. You die in a pool of filth and blood.';
      fightLog.add(result.finalMessage);
    } else if (remainingEnemyHealth <= 0) {
      result.victory = true;
      result.enemiesKilled = enemyCount;
      result.finalMessage = 'Victory! You leave the $enemyType rotting in the mud.';

      // Rewards
      final moneyReward = (enemyCount * 500) + random.nextInt(enemyCount * 200);
      gameState.money += moneyReward;
      fightLog.add('You loot \$${moneyReward.toString()} from their mangled corpses!');

      // Reputation gain
      final repGain = enemyCount * 5;
      gameState.reputation += repGain;
      fightLog.add('The streets fear you more. Reputation +$repGain!');

      // Chance to find weapons
      if (random.nextDouble() < 0.3) {
        final foundWeapon = _getRandomWeapon();
        fightLog.add('You find a $foundWeapon among the remains!');
        _addFoundWeapon(gameState, foundWeapon);
      }
    } else {
      result.finalMessage =
          'The battle ends in a bloody stalemate. Both sides retreat through the mud.';
    }

    fightLog.add(result.finalMessage);
    return result;
  }

  static int _getWeaponDamage(String weapon, GameState gameState) {
    // Apply pistol upgrade bonus
    int baseDamage = switch (weapon) {
      'pistol' => 15 + (gameState.weapons.pistols > 1 ? 5 : 0),
      'uzi' => 25,
      'ar15' => 35,
      'ghost_gun' => 40,
      'grenade' => 50,
      'barbed_wire_bat' => 22, // Slightly buffed
      'vampire_bat' => 30,
      'brass_knuckles' => 12,
      'knife' => 15,
      'sword' => 28, // Slightly buffed
      'axe' => 30,
      'golden_gun' => 60,
      'poison_blowgun' => 20,
      'missile_launcher' => 75,
      'machine_gun' => 45,
      'rocket_launcher' => 80,
      'submachine_gun' => 35,
      'flamethrower' => 50,
      _ => 10, // Fists
    };

    // Apply automatic pistol upgrade (3x damage)
    if (weapon == 'pistol' && gameState.pistolUpgraded) {
      baseDamage *= 3;
    }

    // Apply special bullet effects
    if ((weapon == 'pistol' || weapon == 'uzi' || weapon == 'ar15') &&
        gameState.weapons.useExplodingBullets &&
        gameState.weapons.explodingBullets > 0) {
      baseDamage = (baseDamage * 1.5).toInt();
      gameState.weapons.explodingBullets--;
    } else if ((weapon == 'pistol' || weapon == 'uzi' || weapon == 'ar15') &&
        gameState.weapons.useHollowPointBullets &&
        gameState.weapons.hollowPointBullets > 0) {
      baseDamage = (baseDamage * 1.3).toInt();
      gameState.weapons.hollowPointBullets--;
    } else if ((weapon == 'pistol' || weapon == 'uzi' || weapon == 'ar15') &&
        gameState.weapons.bullets > 0) {
      gameState.weapons.bullets--;
    }

    return baseDamage;
  }

  static int _calculateEnemyDamage(
      String enemyType, int enemyCount, GameState gameState) {
    final baseDamage = switch (enemyType) {
      'Police Officers' => 15,
      'Squidie Hit Squad' => 20,
      'Loan Shark Enforcer' => 30,
      _ => 10,
    };

    return baseDamage * enemyCount;
  }

  static DrugUseResult useDrug(GameState gameState, String drug) {
    // Check if player has the drug
    final drugCount = switch (drug) {
      'crack' => gameState.drugs.crack,
      'coke' => gameState.drugs.coke,
      'weed' => gameState.drugs.weed,
      'ice' => gameState.drugs.ice,
      'percs' => gameState.drugs.percs,
      'pixie_dust' => gameState.drugs.pixieDust,
      _ => 0,
    };

    if (drugCount <= 0) {
      return DrugUseResult(
        success: false,
        message: 'You don\'t have any $drug to use!',
      );
    }

    // Consume the drug
    switch (drug) {
      case 'crack': gameState.drugs.crack--;
      case 'coke': gameState.drugs.coke--;
      case 'weed': gameState.drugs.weed--;
      case 'ice': gameState.drugs.ice--;
      case 'percs': gameState.drugs.percs--;
      case 'pixie_dust': gameState.drugs.pixieDust--;
    }

    return switch (drug) {
      'crack' => DrugUseResult(
          success: true,
          message:
              'You snort some crack! Your heart hammers against your ribs and the pain fades into a bloody blur. (+30 HP, but -10 HP next turn)',
          healthChange: 30,
          temporaryEffect: 'crack_crash',
        ),
      'coke' => DrugUseResult(
          success: true,
          message: 'You do a line of coke! A surge of violent energy rushes through you. (+20 HP, +5 damage next attack)',
          healthChange: 20,
          temporaryEffect: 'coke_boost',
        ),
      'weed' => DrugUseResult(
          success: true,
          message: 'You smoke some weed. The screaming in the street sounds farther away. (+10 HP, reduced enemy aggression)',
          healthChange: 10,
          temporaryEffect: 'weed_chill',
        ),
      'ice' => DrugUseResult(
          success: true,
          message: 'You smoke some ice. You feel invincible, but everyone looks like they\'re holding a knife. (+25 HP, higher critical hit chance)',
          healthChange: 25,
          temporaryEffect: 'ice_paranoia',
        ),
      'percs' => DrugUseResult(
          success: true,
          message: 'You pop some percs. Your wounds still bleed, but you just don\'t care anymore. (+15 HP, pain resistance)',
          healthChange: 15,
          temporaryEffect: 'percs_pain_relief',
        ),
      'pixie_dust' => DrugUseResult(
          success: true,
          message:
              'You snort some pixie dust. The world turns into a Technicolor nightmare of blood and neon. (+40 HP, hallucinations)',
          healthChange: 40,
          temporaryEffect: 'pixie_hallucinations',
        ),
      _ => DrugUseResult(
          success: false,
          message: 'You don\'t have any $drug to use!',
        ),
    };
  }

  static (bool, String) fleeCombat() {
    final random = Random();
    if (random.nextDouble() < 0.7) {
      return (true, 'You scramble through the mud and escape into the shadows!');
    } else {
      return (false, 'You slip in the muck! They tear into your back as you try to run!');
    }
  }

  static String _getRandomWeapon() {
    final weapons = [
      'pistol',
      'bullets',
      'knife',
      'brass_knuckles',
      'uzi',
      'grenade',
      'vest_light',
      'sword'
    ];
    return weapons[Random().nextInt(weapons.length)];
  }

  static void _addFoundWeapon(GameState gameState, String weapon) {
    switch (weapon) {
      case 'pistol':
        gameState.weapons.pistols++;
      case 'bullets':
        gameState.weapons.bullets += 20;
      case 'knife':
        gameState.weapons.knife++;
      case 'brass_knuckles':
        gameState.weapons.brassKnuckles++;
      case 'uzi':
        gameState.weapons.uzis++;
      case 'grenade':
        gameState.weapons.grenades++;
      case 'vest_light':
        gameState.weapons.vest = 5;
      case 'sword':
        gameState.weapons.sword++;
    }
  }
}

class DrugUseResult {
  final bool success;
  final String message;
  final int healthChange;
  final String? temporaryEffect;

  DrugUseResult({
    required this.success,
    required this.message,
    this.healthChange = 0,
    this.temporaryEffect,
  });
}
