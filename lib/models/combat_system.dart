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
      fightLog.add('You attack with $weapon for $playerAttackDamage damage!');

      // Gang attack (if player has gang members)
      if (gameState.members > 1) {
        final gangDamage =
            (gameState.members * 3) + random.nextInt(gameState.members * 2);
        remainingEnemyHealth -= gangDamage;
        result.gangDamageDealt += gangDamage;
        fightLog.add('Your gang attacks for $gangDamage damage!');
      }

      // Enemy counterattack
      if (remainingEnemyHealth > 0) {
        final enemyDamage =
            _calculateEnemyDamage(enemyType, enemyCount, gameState);
        final actualDamage = max(1, enemyDamage - gameState.weapons.vest);
        gameState.takeDamage(actualDamage);
        result.totalEnemyDamage += actualDamage;
        fightLog.add('$enemyType counterattack for $actualDamage damage!');
      }

      // Check for critical hits
      if (random.nextDouble() < gameState.squidiesCriticalHitChance) {
        final enemyDamage =
            _calculateEnemyDamage(enemyType, enemyCount, gameState);
        final criticalDamage = (enemyDamage * 1.5).toInt();
        gameState.takeDamage(criticalDamage);
        result.totalEnemyDamage += criticalDamage;
        fightLog.add(
            'CRITICAL HIT! $enemyType lands a devastating blow for $criticalDamage damage!');
      }
    }

    // Determine combat outcome
    if (gameState.health <= 0) {
      result.defeat = true;
      result.finalMessage =
          'You fought bravely, but the street always wins. You are dead.';
      fightLog.add(result.finalMessage);
    } else if (remainingEnemyHealth <= 0) {
      result.victory = true;
      result.enemiesKilled = enemyCount;
      result.finalMessage = 'Victory! The $enemyType have been defeated!';

      // Rewards
      final moneyReward = (enemyCount * 500) + random.nextInt(enemyCount * 200);
      gameState.money += moneyReward;
      fightLog.add('You found \$${moneyReward.toString()} on the bodies!');

      // Reputation gain
      final repGain = enemyCount * 5;
      gameState.reputation += repGain;
      fightLog.add('Your reputation increased by $repGain!');

      // Chance to find weapons
      if (random.nextDouble() < 0.3) {
        final foundWeapon = _getRandomWeapon();
        fightLog.add('You found a $foundWeapon on the battlefield!');
        _addFoundWeapon(gameState, foundWeapon);
      }
    } else {
      result.finalMessage =
          'The battle was inconclusive. Both sides retreat to fight another day.';
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
      'barbed_wire_bat' => 20,
      'vampire_bat' => 30,
      'brass_knuckles' => 10,
      'knife' => 12,
      'sword' => 25,
      'axe' => 30,
      'golden_gun' => 60,
      'poison_blowgun' => 20,
      'missile_launcher' => 75,
      'machine_gun' => 45,
      'rocket_launcher' => 80,
      'submachine_gun' => 30,
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
              'You snort some crack! Your health increases but you feel the crash coming. (+30 HP, but -10 HP next turn)',
          healthChange: 30,
          temporaryEffect: 'crack_crash',
        ),
      'coke' => DrugUseResult(
          success: true,
          message: 'You do a line of coke! You feel energized and focused. (+20 HP, +5 damage next attack)',
          healthChange: 20,
          temporaryEffect: 'coke_boost',
        ),
      'weed' => DrugUseResult(
          success: true,
          message: 'You smoke some weed. Chill vibes, man. (+10 HP, reduced enemy aggression)',
          healthChange: 10,
          temporaryEffect: 'weed_chill',
        ),
      'ice' => DrugUseResult(
          success: true,
          message: 'You smoke some ice. You feel powerful but paranoid. (+25 HP, but higher chance of enemy critical hits)',
          healthChange: 25,
          temporaryEffect: 'ice_paranoia',
        ),
      'percs' => DrugUseResult(
          success: true,
          message: 'You pop some percs. The pain fades away. (+15 HP, pain resistance)',
          healthChange: 15,
          temporaryEffect: 'percs_pain_relief',
        ),
      'pixie_dust' => DrugUseResult(
          success: true,
          message:
              'You snort some pixie dust. The world becomes magical and dangerous. (+40 HP, hallucinations)',
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
      return (true, 'You successfully fled from combat!');
    } else {
      return (false, 'You failed to flee and took damage while running away!');
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
