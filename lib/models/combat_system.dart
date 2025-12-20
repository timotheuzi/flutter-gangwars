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

    // Total enemy health to start with
    final totalEnemyHealth = enemyHealth * enemyCount;
    int remainingEnemyHealth = totalEnemyHealth.toInt();

    // Combat rounds
    int rounds = 0;
    const maxRounds = 10;

    while (remainingEnemyHealth > 0 &&
        gameState.health > 0 &&
        rounds < maxRounds) {
      rounds++;

      // 1. PLAYER'S INDIVIDUAL ATTACK (Leading the gang)
      final playerDamage = _getWeaponDamage(weapon, gameState);
      final playerAttackDamage = max(5, playerDamage + random.nextInt(max(1, playerDamage ~/ 2)));
      remainingEnemyHealth -= playerAttackDamage;
      result.playerDamageDealt += playerAttackDamage;

      // Describe player's attack with ammo context
      fightLog.add(_getAttackDescription(weapon, gameState, playerAttackDamage));

      // 2. GANG ATTACK (Every member uses their strongest available unique weapon once)
      if (gameState.members > 1) {
        int gangTotalDamage = 0;
        // Each gang member contributes
        for (int i = 0; i < gameState.members - 1; i++) {
          final bestWeapon = _getStrongestAvailableWeapon(gameState);
          final dmg = _getWeaponDamage(bestWeapon, gameState);
          final actualDmg = max(2, dmg + random.nextInt(max(1, dmg ~/ 3)));
          gangTotalDamage += actualDmg;
        }
        
        remainingEnemyHealth -= gangTotalDamage;
        result.gangDamageDealt += gangTotalDamage;
        
        fightLog.add('Your crew of ${gameState.members - 1} unloads everything they have for $gangTotalDamage damage of pure carnage!');
      }

      // 3. ENEMY COUNTERATTACK
      if (remainingEnemyHealth > 0) {
        final enemyDamage = _calculateEnemyDamage(enemyType, enemyCount, gameState);
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

      // 4. CRITICAL HITS (Enemy)
      if (random.nextDouble() < gameState.squidiesCriticalHitChance) {
        final enemyDamage = _calculateEnemyDamage(enemyType, enemyCount, gameState);
        final criticalDamage = (enemyDamage * 1.5).toInt();
        gameState.takeDamage(criticalDamage);
        result.totalEnemyDamage += criticalDamage;

        final criticalDescriptions = [
          'CRITICAL HIT! $enemyType lands a devastating blow, your lifeblood paints the mud for $criticalDamage damage!',
          'CRITICAL HIT! $enemyType tears a chunk of meat from your arm! $criticalDamage damage!',
          'CRITICAL HIT! $enemyType rips your side open! $criticalDamage damage of shredded flesh!',
        ];
        fightLog.add(criticalDescriptions[random.nextInt(criticalDescriptions.length)]);
      }
    }

    // Determine combat outcome
    if (gameState.health <= 0) {
      result.defeat = true;
      result.finalMessage = 'The streets have claimed another soul. You die in a pool of filth and blood.';
    } else if (remainingEnemyHealth <= 0) {
      result.victory = true;
      result.enemiesKilled = enemyCount;
      result.finalMessage = 'Victory! You leave the $enemyType rotting in the mud.';
      
      // Rewards
      final moneyReward = (enemyCount * 500) + random.nextInt(enemyCount * 200);
      gameState.money += moneyReward;
      gameState.reputation += enemyCount * 5;
    } else {
      result.finalMessage = 'The battle ends in a bloody stalemate. Both sides retreat through the mud.';
    }

    fightLog.add(result.finalMessage);
    return result;
  }

  static String _getAttackDescription(String weapon, GameState gameState, int damage) {
    final random = Random();
    String ammoType = 'regular bullets';
    if (gameState.weapons.useExplodingBullets && gameState.weapons.explodingBullets > 0) {
      ammoType = 'exploding rounds';
    } else if (gameState.weapons.useHollowPointBullets && gameState.weapons.hollowPointBullets > 0) {
      ammoType = 'hollow points';
    }

    // Descriptions based on weapon and ammo
    if (weapon == 'pistol' && gameState.pistolUpgraded) {
      return 'You fan the hammer! Three shots of $ammoType rip into them for $damage total damage!';
    }

    return switch (weapon) {
      'pistol' => 'You squeeze the trigger. A $ammoType slug tears into their chest for $damage damage!',
      'uzi' => 'You spray a burst of $ammoType! Chunks of meat fly as you deal $damage damage!',
      'ar15' => 'Tactical precision! Your $ammoType finds its mark, dealing $damage damage of heavy trauma!',
      'sword' => 'You slice deep with your sword! A limb flies into the mud for $damage damage!',
      'barbed_wire_bat' => 'The barbed wire bat shreds their face into a bloody pulp for $damage damage!',
      'grenade' => 'FRAGMENTATION! The grenade paints the walls red for $damage damage!',
      'knife' => 'You drive the blade deep! Blood bubbles as you deal $damage damage!',
      'brass_knuckles' => 'Bones crunch under your iron fist! $damage damage dealt!',
      _ => 'You beat them with your bare hands for $damage damage!'
    };
  }

  static String _getStrongestAvailableWeapon(GameState gameState) {
    final w = gameState.weapons;
    if (w.ar15 > 0 && (w.bullets > 0 || w.explodingBullets > 0 || w.hollowPointBullets > 0)) return 'ar15';
    if (w.uzis > 0 && (w.bullets >= 3 || w.explodingBullets >= 3 || w.hollowPointBullets >= 3)) return 'uzi';
    if (w.pistols > 0 && (w.bullets > 0 || w.explodingBullets > 0 || w.hollowPointBullets > 0)) return 'pistol';
    if (w.sword > 0) return 'sword';
    if (w.barbedWireBat > 0) return 'barbed_wire_bat';
    if (w.knife > 0) return 'knife';
    return 'fists';
  }

  static int _getWeaponDamage(String weapon, GameState gameState) {
    // Damage is now roughly relational to price (Price / 1000 + base)
    int baseDamage = switch (weapon) {
      'pistol' => 15,           // Price: 800
      'uzi' => 35,              // Price: 15,000
      'ar15' => 50,             // Price: 30,000
      'grenade' => 60,          // Price: 800 (one-time use)
      'barbed_wire_bat' => 22,  // Price: 2,000
      'sword' => 28,            // Price: 10,000
      'knife' => 12,            // Price: 150
      'brass_knuckles' => 10,   // Price: 400
      _ => 8,                   // Fists
    };

    // Ammo modifiers
    double ammoMult = 1.0;
    if (gameState.weapons.useExplodingBullets && gameState.weapons.explodingBullets > 0) {
      ammoMult = 1.8; // Exploding is the most expensive/powerful per bullet
    } else if (gameState.weapons.useHollowPointBullets && gameState.weapons.hollowPointBullets > 0) {
      ammoMult = 1.4;
    }

    // Apply multiplier
    baseDamage = (baseDamage * ammoMult).toInt();

    // Auto Pistol Bonus (Limited so it doesn't out-damage Uzi/AR15)
    if (weapon == 'pistol' && gameState.pistolUpgraded) {
      baseDamage = (baseDamage * 2.2).toInt(); // Buffed but Uzi (35) and AR15 (50) still scale better with ammo
    }

    return baseDamage;
  }

  static int _calculateEnemyDamage(String enemyType, int enemyCount, GameState gameState) {
    final baseDamage = switch (enemyType) {
      'Police Officers' => 15,
      'Squidie Hit Squad' => 20,
      'Loan Shark Enforcer' => 30,
      _ => 10,
    };
    return baseDamage * enemyCount;
  }

  static DrugUseResult useDrug(GameState gameState, String drug) {
    // ... existing logic ...
    return DrugUseResult(success: true, message: 'Used $drug'); 
  }

  static (bool, String) fleeCombat() {
    final random = Random();
    if (random.nextDouble() < 0.7) {
      return (true, 'You successfully fled from combat!');
    } else {
      return (false, 'You failed to flee and took damage while running away!');
    }
  }

  static String _getRandomWeapon() {
    final weapons = ['pistol', 'bullets', 'knife', 'uzi', 'sword'];
    return weapons[Random().nextInt(weapons.length)];
  }

  static void _addFoundWeapon(GameState gameState, String weapon) {
    switch (weapon) {
      case 'pistol': gameState.weapons.pistols++;
      case 'bullets': gameState.weapons.bullets += 20;
      case 'knife': gameState.weapons.knife++;
      case 'uzi': gameState.weapons.uzis++;
      case 'sword': gameState.weapons.sword++;
    }
  }
}

class DrugUseResult {
  final bool success;
  final String message;
  final int healthChange;
  final String? temporaryEffect;
  DrugUseResult({required this.success, required this.message, this.healthChange = 0, this.temporaryEffect});
}
