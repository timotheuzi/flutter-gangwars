import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../models/game_state.dart';
import '../models/combat_result.dart';
import '../models/combat_system.dart';
import '../models/random_event.dart';
import '../models/random_event_data.dart';

class GameProvider with ChangeNotifier {
  GameState _gameState = GameState();
  CombatResult? _combatResult;
  String _currentScreen = 'main_menu';
  String _gameMessage = '';
  CombatData? _currentCombatData;
  bool _showingBuildingAnimation = false;
  String _buildingAnimationType = '';
  bool _showingWanderingAnimation = false;
  final currentWanderingEvent = ValueNotifier<RandomEvent?>(null);

  GameState get gameState => _gameState;
  CombatResult? get combatResult => _combatResult;
  String get currentScreen => _currentScreen;
  String get gameMessage => _gameMessage;
  set gameMessage(String message) {
    _gameMessage = message;
    notifyListeners();
  }

  CombatData? get currentCombatData => _currentCombatData;
  bool get showingBuildingAnimation => _showingBuildingAnimation;
  String get buildingAnimationType => _buildingAnimationType;
  bool get showingWanderingAnimation => _showingWanderingAnimation;

  GameProvider() {
    loadGameState();
  }

  Future<void> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedState = prefs.getString('game_state');

    if (savedState != null) {
      try {
        final jsonData = json.decode(savedState);
        _gameState = GameState.fromJson(jsonData);
        _currentScreen = _gameState.currentLocation.isNotEmpty
            ? _gameState.currentLocation
            : 'main_menu';
      } catch (e) {
        _gameState = GameState();
        _currentScreen = 'main_menu';
      }
    } else {
      _gameState = GameState();
      _currentScreen = 'main_menu';
    }
    notifyListeners();
  }

  Future<void> saveGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('game_state', json.encode(_gameState.toJson()));
  }

  void startNewGame(String playerName, String gangName) {
    _gameState = GameState(playerName: playerName, gangName: gangName);
    _currentScreen = 'city';
    saveGameState();
    notifyListeners();
  }

  void restartGame({bool keepPersistentData = true}) {
    if (keepPersistentData) {
      final currentState = _gameState;
      _gameState = GameState(
        playerName: currentState.playerName,
        gangName: currentState.gangName,
        currentScore: currentState.currentScore,
        reputation: currentState.reputation,
      );
    } else {
      _gameState = GameState();
      _currentScreen = 'main_menu';
    }
    saveGameState();
    _gameMessage = 'Game restarted! Enter your name and gang name.';
    notifyListeners();
  }

  void navigateToScreen(String screen) {
    final buildingScreens = [
      'bank',
      'bar',
      'crackhouse',
      'gunshack',
      'infobooth',
      'picknsave',
      'alleyway',
    ];

    if (buildingScreens.contains(screen)) {
      _showingBuildingAnimation = true;
      _buildingAnimationType = screen;
    } else {
      _currentScreen = screen;
      _gameState.currentLocation = screen;
      saveGameState();
    }
    notifyListeners();
  }

  void completeBuildingAnimation() {
    _showingBuildingAnimation = false;
    _currentScreen = _buildingAnimationType;
    _gameState.currentLocation = _buildingAnimationType;
    _buildingAnimationType = '';
    saveGameState();
    notifyListeners();
  }

  void startWanderingAnimation() {
    _showingWanderingAnimation = true;
    notifyListeners();
  }

  void completeWanderingAnimation() {
    _showingWanderingAnimation = false;
    notifyListeners();
  }

  void startMudFight(
    int enemyHealth,
    int enemyCount,
    String enemyType,
    String combatId,
  ) {
    _combatResult = CombatResult()
      ..enemiesKilled = 0
      ..initialEnemyHealth = enemyHealth * enemyCount
      ..remainingEnemyHealth = enemyHealth * enemyCount
      ..initialPlayerHealth = _gameState.health
      ..fightLog.add(
        'Combat starting in the mud: $enemyType ($enemyCount enemies)',
      );

    _currentCombatData = CombatData(
      enemyHealth: enemyHealth.toDouble(),
      enemyCount: enemyCount,
      enemyType: enemyType,
      combatId: combatId,
      initialMessage: 'You engage in a muddy brawl with $enemyType!',
    );

    _currentScreen = 'mud_fight';
    saveGameState();
    _gameMessage = 'Starting combat with $enemyType!';
    notifyListeners();
  }

  bool buyWeapon(String weaponType, {int quantity = 1}) {
    final price = _getWeaponPrice(weaponType);
    final totalCost = price * quantity;

    if (!_gameState.spendMoney(totalCost)) {
      _gameMessage = 'Not enough money!';
      notifyListeners();
      return false;
    }

    _addWeapon(weaponType, quantity);
    _gameMessage = 'Purchased $quantity $weaponType(s) for \$${totalCost}';
    saveGameState();
    notifyListeners();
    return true;
  }

  int _getWeaponPrice(String weaponType) {
    return switch (weaponType) {
      'pistol' => 800,
      'bullets' => 400, // Balanced price for 50 bullets
      'exploding_bullets' => 400, // Balanced price for 20 bullets
      'hollow_point_bullets' => 300, // Fixed: 100 less than exploding
      'uzi' => 15000,
      'ar15' => 30000,
      'ghost_gun' => 2000,
      'grenade' => 800,
      'barbed_wire_bat' => 2000,
      'vampire_bat' => 8000,
      'brass_knuckles' => 400,
      'knife' => 150,
      'sword' => 10000,
      'axe' => 8000,
      'golden_gun' => 5000000,
      'poison_blowgun' => 5000,
      'missile_launcher' => 1000000,
      'missile' => 50000,
      'machine_gun' => 100000,
      'rocket_launcher' => 2000000,
      'submachine_gun' => 25000,
      'flamethrower' => 750000,
      'vest_light' => 25000,
      'vest_medium' => 45000,
      'vest_heavy' => 65000,
      _ => 0,
    };
  }

  void _addWeapon(String weaponType, int quantity) {
    switch (weaponType) {
      case 'pistol':
        _gameState.weapons.pistols += quantity;
      case 'bullets':
        _gameState.weapons.bullets += quantity * 50;
      case 'exploding_bullets':
        _gameState.weapons.explodingBullets += quantity * 20;
      case 'hollow_point_bullets':
        _gameState.weapons.hollowPointBullets += quantity * 15;
      case 'uzi':
        _gameState.weapons.uzis += quantity;
      case 'ar15':
        _gameState.weapons.ar15 += quantity;
      case 'ghost_gun':
        _gameState.weapons.ghostGuns += quantity;
      case 'grenade':
        _gameState.weapons.grenades += quantity;
      case 'barbed_wire_bat':
        _gameState.weapons.barbedWireBat += quantity;
      case 'vampire_bat':
        _gameState.weapons.vampireBat += quantity;
      case 'brass_knuckles':
        _gameState.weapons.brassKnuckles += quantity;
      case 'knife':
        _gameState.weapons.knife += quantity;
      case 'sword':
        _gameState.weapons.sword += quantity;
      case 'axe':
        _gameState.weapons.axe += quantity;
      case 'golden_gun':
        _gameState.weapons.goldenGun += quantity;
      case 'poison_blowgun':
        _gameState.weapons.poisonBlowgun += quantity;
      case 'missile_launcher':
        _gameState.weapons.missileLauncher += quantity;
      case 'missile':
        _gameState.weapons.missiles += quantity;
      case 'machine_gun':
        _gameState.weapons.machineGun += quantity;
      case 'rocket_launcher':
        _gameState.weapons.rocketLauncher += quantity;
      case 'submachine_gun':
        _gameState.weapons.submachineGun += quantity;
      case 'flamethrower':
        _gameState.weapons.flamethrower += quantity;
      case 'vest_light':
        _gameState.weapons.vest = 5;
      case 'vest_medium':
        _gameState.weapons.vest = 10;
      case 'vest_heavy':
        _gameState.weapons.vest = 15;
    }
  }

  String _normalizeDrugType(String drugType) {
    return drugType.toLowerCase().replaceAll(' ', '_');
  }

  bool tradeDrug(String drugType, String action, int quantity) {
    final normalizedType = _normalizeDrugType(drugType);
    final price = _gameState.drugPrices[normalizedType] ?? 0;

    if (action == 'buy') {
      final cost = price * quantity;
      if (!_gameState.spendMoney(cost)) {
        _gameMessage = 'Not enough money!';
        notifyListeners();
        return false;
      }

      _addDrug(normalizedType, quantity);
      _gameMessage = 'Bought $quantity kilo(s) of $drugType for \$${cost}';
      saveGameState();
      notifyListeners();
      return true;
    } else if (action == 'sell') {
      final currentQty = _getDrugQuantity(normalizedType);

      if (currentQty < quantity) {
        _gameMessage = 'Not enough $drugType to sell!';
        notifyListeners();
        return false;
      }

      final revenue = price * quantity;
      _gameState.money += revenue;
      _removeDrug(normalizedType, quantity);

      _gameMessage = 'Sold $quantity kilo(s) of $drugType for \$${revenue}';

      // Chance to recruit new member from big drug sales
      if (revenue >= 5000 && Random().nextDouble() < 0.25) {
        _gameState.members++;
        _gameMessage += '\nWord spread! A new recruit joined your gang!';
      }

      saveGameState();
      notifyListeners();
      return true;
    }

    return false;
  }

  bool recruitProstitute() {
    if (_gameState.money >= _gameState.prostitutes.price) {
      _gameState.money -= _gameState.prostitutes.price;
      _gameState.prostitutes.count++;
      _gameMessage = 'You recruited a new prostitute!';
      saveGameState();
      notifyListeners();
      return true;
    }
    _gameMessage = 'Not enough money to recruit!';
    notifyListeners();
    return false;
  }

  int _getDrugQuantity(String drugType) {
    final normalized = _normalizeDrugType(drugType);
    return switch (normalized) {
      'weed' => _gameState.drugs.weed,
      'crack' => _gameState.drugs.crack,
      'coke' => _gameState.drugs.coke,
      'ice' => _gameState.drugs.ice,
      'percs' => _gameState.drugs.percs,
      'pixie_dust' => _gameState.drugs.pixieDust,
      _ => 0,
    };
  }

  void _addDrug(String drugType, int quantity) {
    final normalized = _normalizeDrugType(drugType);
    switch (normalized) {
      case 'weed':
        _gameState.drugs.weed += quantity;
      case 'crack':
        _gameState.drugs.crack += quantity;
      case 'coke':
        _gameState.drugs.coke += quantity;
      case 'ice':
        _gameState.drugs.ice += quantity;
      case 'percs':
        _gameState.drugs.percs += quantity;
      case 'pixie_dust':
        _gameState.drugs.pixieDust += quantity;
    }
  }

  void _removeDrug(String drugType, int quantity) {
    final normalized = _normalizeDrugType(drugType);
    switch (normalized) {
      case 'weed':
        _gameState.drugs.weed -= quantity;
      case 'crack':
        _gameState.drugs.crack -= quantity;
      case 'coke':
        _gameState.drugs.coke -= quantity;
      case 'ice':
        _gameState.drugs.ice -= quantity;
      case 'percs':
        _gameState.drugs.percs -= quantity;
      case 'pixie_dust':
        _gameState.drugs.pixieDust -= quantity;
    }
  }

  bool performCombat(String weapon, String enemyType, int enemyCount) {
    // Use the stored enemy health from combat data to maintain scaling/power factor
    final perEnemyHealth = _currentCombatData?.enemyHealth ??
        _calculateEnemyHealth(enemyType, enemyCount);

    final result = CombatSystem.calculateCombat(
      _gameState,
      weapon,
      enemyType,
      enemyCount,
      perEnemyHealth,
    );
    _combatResult = result;

    if (result.victory) {
      _gameMessage = 'Victory! You defeated the $enemyType in the mud!';
    } else if (result.defeat) {
      _gameMessage = 'Defeat! You died in the gutter.';
      // We do NOT change _currentScreen here so the user can see the defeat card summary
    }

    saveGameState();
    notifyListeners();
    return result.victory;
  }

  double _calculateEnemyHealth(String enemyType, int enemyCount) {
    return switch (enemyType) {
      'Police Officers' => 10.0,
      'Squidie Hit Squad' => 25.0,
      'Squidie Army' => 50.0,
      'Loan Shark Enforcer' => 200.0,
      _ => 15.0,
    };
  }

  void useDrug(String drug) {
    final result = CombatSystem.useDrug(_gameState, drug);
    _gameMessage = result.message;
    if (result.success) {
      if (result.healthChange > 0) {
        _gameState.heal(result.healthChange);
      } else {
        _gameState.takeDamage(-result.healthChange);
      }
    }
    saveGameState();
    notifyListeners();
  }

  bool fleeCombat() {
    final (success, message) = CombatSystem.fleeCombat();
    _gameMessage = message;
    if (success) {
      saveGameState();
    }
    notifyListeners();
    return success;
  }

  bool picknsaveAction(String action) {
    return switch (action) {
      'buy_food' => _buyFood(),
      'buy_medical' => _buyMedical(),
      'buy_id' => _buyId(),
      'buy_info' => _buyInfo(),
      'recruit' => _recruit(),
      _ => false,
    };
  }

  bool _buyFood() {
    if (!_gameState.spendMoney(500)) {
      _gameMessage = 'Not enough money!';
      return false;
    }
    _gameMessage = 'You bought food supplies for your gang! Morale is high.';
    saveGameState();
    return true;
  }

  bool _buyMedical() {
    if (!_gameState.spendMoney(500)) {
      // Balanced price
      _gameMessage = 'Not enough money!';
      return false;
    }
    _gameState.heal(50);
    _gameMessage = 'You bought medical supplies! Health restored.';
    saveGameState();
    return true;
  }

  bool _buyId() {
    if (!_gameState.spendMoney(5000)) {
      _gameMessage = 'Not enough money!';
      return false;
    }
    _gameState.flags.hasId = true;
    _gameMessage = 'You bought a fake ID! Protected from police checks.';
    saveGameState();
    return true;
  }

  bool _buyInfo() {
    if (!_gameState.spendMoney(2000)) {
      _gameMessage = 'Not enough money!';
      return false;
    }
    _gameState.flags.hasInfo = true;
    _gameMessage = 'You bought information! Insider knowledge about police.';
    saveGameState();
    return true;
  }

  bool _recruit() {
    if (!_gameState.spendMoney(10000)) {
      _gameMessage = 'Not enough money!';
      return false;
    }
    _gameState.members++;
    _gameMessage = 'You recruited a new gang member! Your gang grows stronger.';
    saveGameState();
    return true;
  }

  void updateGameState(GameState newState) {
    _gameState = newState;
    saveGameState();
    notifyListeners();
  }

  void incrementSteps() {
    _gameState.steps++;

    if (_gameState.steps >= _gameState.maxSteps) {
      _advanceDayWithIncome();
    } else {
      saveGameState();
      notifyListeners();
    }
  }

  void _advanceDayWithIncome() {
    // Calculate income before advancing day
    final random = Random();
    int totalIncome = 0;
    for (int i = 0; i < _gameState.prostitutes.count; i++) {
      totalIncome += 3500 + random.nextInt(1301);
    }

    _gameState.advanceDay();

    // Day message includes prostitute income
    _gameMessage = 'A new day begins! Day $_gameState.day';
    if (_gameState.prostitutes.count > 0) {
      _gameMessage += '\nYour prostitutes earned you \$$totalIncome tonight.';
    }

    saveGameState();
    notifyListeners();
  }

  // Legacy method for compatibility if needed, but updated to use new logic
  String wander() {
    final event = wanderWithEvent();
    return event?.description ?? _gameMessage;
  }

  // New method that returns the full event object
  RandomEvent? wanderWithEvent() {
    _gameState.steps++;

    if (_gameState.steps >= _gameState.maxSteps) {
      _advanceDayWithIncome();

      // Check for loan sharks at the start of a new day - now 2 days grace
      if (_gameState.loan > 0 &&
          (_gameState.day - _gameState.loanDayTaken) >= 2) {
        _gameState.flags.hasAttractedLoanShark = true;
      }

      return null;
    }

    // Check for loan shark encounter
    if (_gameState.loan > 0 &&
        _gameState.flags.hasAttractedLoanShark &&
        Random().nextDouble() < 0.2) {
      // Increased chance
      final msg = _handleLoanSharkEncounter();
      _gameMessage = msg;
      return null; // Combat started or debt paid
    }

    // Generate random event
    final event = RandomEventData.generateRandomEvent(_gameState);

    if (!RandomEventData.hasMeetRequirements(event, _gameState)) {
      _gameMessage = 'You wander the streets but find nothing of interest.';
      return RandomEvent(
        id: 'nothing',
        title: 'Nothing',
        description: 'You wander the streets but find nothing of interest.',
        type: EventType.nothing,
      );
    }

    // Don't apply effects yet for NPC encounters with options
    if (event.type == EventType.npcEncounter && event.options.isNotEmpty) {
      return event;
    }

    RandomEventData.applyEventEffects(event, _gameState);

    // Handle combat events
    switch (event.type) {
      case EventType.gangFight:
        startMudFight(100, 3, 'Rival Gang Members', event.id);
        break;
      case EventType.policeChase:
        startMudFight(150, 4, 'Police Officers', event.id);
        break;
      case EventType.squidieHitSquad:
        final enemyCount = _gameState.members + Random().nextInt(2) + 1;
        startMudFight(200, enemyCount, 'Squidie Hit Squad', event.id);
        break;
      default:
        // Other events handled by applyEventEffects or just informational
        break;
    }

    _gameMessage = event.description;
    return event;
  }

  String _handleLoanSharkEncounter() {
    final repaymentAmount = (_gameState.loan * 1.5).toInt();

    if (_gameState.money >= repaymentAmount) {
      // Automatic repayment if money is available? Or force combat?
      // Requirement says "hunted down", so let's trigger combat.
      startMudFight(200, 1, 'Loan Shark Enforcer', 'loan_shark_boss_fight');
      return 'A Loan Shark Enforcer corners you! "You owe us \$${repaymentAmount}, punk!"';
    } else {
      // Start combat with loan shark enforcer
      startMudFight(200, 1, 'Loan Shark Enforcer', 'loan_shark_boss_fight');
      return 'Loan shark enforcer attacks! Fight or die!';
    }
  }

  String handleNpcInteraction(RandomEvent event, String option) {
    if (!event.optionEffects.containsKey(option)) {
      return 'Nothing happens.';
    }

    final effects = event.optionEffects[option]!;
    final messages = <String>[];

    effects.forEach((key, value) {
      switch (key) {
        case 'damage':
          if (option == 'Fight' || option == 'Challenge') {
            if (option == 'Fight' || option == 'Challenge') {
              final enemyName = event.title.replaceFirst('NPC Encounter: ', '');
              startMudFight(100, 1, enemyName, event.id);
              messages.add('You attacked the $enemyName!');
              return; // Exit switch, combat started
            }

            _gameState.takeDamage(value);
            messages.add('You took $value damage.');
          } else {
            _gameState.takeDamage(value);
            messages.add('You took $value damage.');
          }
        case 'health':
          _gameState.heal(value);
          messages.add('You healed $value health.');
        case 'money':
          if (value > 0) {
            _gameState.money += value;
            messages.add('You got \$$value.');
          } else {
            if (_gameState.spendMoney(-value)) {
              messages.add('You spent \$${-value}');
            } else {
              messages.add('You couldn\'t afford to pay \$${-value}');
            }
          }
        case 'reputation':
          _gameState.reputation += value;
          messages.add('Your reputation changed by $value.');
        case 'members':
          _gameState.members += value;
          messages.add('You gained $value gang member(s).');
        case 'drugs':
          // Correctly handle the random drug added via NPC
          final drugType = event.description.contains('kilos of ')
              ? event.description
                  .split('kilos of ')[1]
                  .split(' ')[0]
                  .replaceAll('.', '')
              : 'weed';
          _addDrug(drugType, value);
          messages.add('You got $value kg of $drugType.');
      }
    });

    // Check if we entered combat, if so, we are already navigating
    if (_currentScreen == 'mud_fight') {
      return 'Entering combat!';
    }

    saveGameState();
    notifyListeners();
    return messages.join(' ');
  }

  void toggleExplodingBullets(bool enable) {
    _gameState.weapons.useExplodingBullets = enable;
    saveGameState();
    notifyListeners();
  }
}

class CombatData {
  final double enemyHealth;
  final int enemyCount;
  final String enemyType;
  final String combatId;
  final String initialMessage;

  CombatData({
    required this.enemyHealth,
    required this.enemyCount,
    required this.enemyType,
    required this.combatId,
    required this.initialMessage,
  });
}
