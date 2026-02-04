class CombatResult {
  bool victory = false;
  bool defeat = false;
  int enemiesKilled = 0;
  List<String> fightLog = [];
  int playerDamageDealt = 0;
  int gangDamageDealt = 0;
  int totalEnemyDamage = 0;
  String finalMessage = '';

  // Real-time tracking for animations
  int remainingEnemyHealth = 0;
  int initialEnemyHealth = 0;
  int initialPlayerHealth = 0;
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
