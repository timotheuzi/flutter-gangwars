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
  CombatResult? _currentCombatData;
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

  CombatResult? get currentCombatData => _currentCombatData;
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
    _currentScreen = 'procedural_open_world';
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

    _currentCombatData = CombatResult()
      ..initialEnemyHealth = enemyHealth
      ..enemyCount = enemyCount
      ..enemyType = enemyType
      ..combatId = combatId
      ..initialMessage = 'You engage in a muddy brawl with $enemyType!';

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
    _gameMessage =
        'Purchased $quantity $weaponType(s) for \$${totalCost.toString()}!';
    saveGameState();
    notifyListeners();
    return true;
  }

  int _getWeaponPrice(String weaponType) {
    return switch (weaponType) {
      'pistol' => 800,
      'bullets' => 400,
      'exploding_bullets' => 400,
      'hollow_point_bullets' => 300,
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
        break;
      case 'bullets':
        _gameState.weapons.bullets += quantity * 50;
        break;
      case 'exploding_bullets':
        _gameState.weapons.explodingBullets += quantity * 20;
        break;
      case 'hollow_point_bullets':
        _gameState.weapons.hollowPointBullets += quantity * 15;
        break;
      case 'uzi':
        _gameState.weapons.uzis += quantity;
        break;
      case 'ar15':
        _gameState.weapons.ar15 += quantity;
        break;
      case 'ghost_gun':
        _gameState.weapons.ghostGuns += quantity;
        break;
      case 'grenade':
        _gameState.weapons.grenades += quantity;
        break;
      case 'barbed_wire_bat':
        _gameState.weapons.barbedWireBat += quantity;
        break;
      case 'vampire_bat':
        _gameState.weapons.vampireBat += quantity;
        break;
      case 'brass_knuckles':
        _gameState.weapons.brassKnuckles += quantity;
        break;
      case 'knife':
        _gameState.weapons.knife += quantity;
        break;
      case 'sword':
        _gameState.weapons.sword += quantity;
        break;
      case 'axe':
        _gameState.weapons.axe += quantity;
        break;
      case 'golden_gun':
        _gameState.weapons.goldenGun += quantity;
        break;
      case 'poison_blowgun':
        _gameState.weapons.poisonBlowgun += quantity;
        break;
      case 'missile_launcher':
        _gameState.weapons.missileLauncher += quantity;
        break;
      case 'missile':
        _gameState.weapons.missiles += quantity;
        break;
      case 'machine_gun':
        _gameState.weapons.machineGun += quantity;
        break;
      case 'rocket_launcher':
        _gameState.weapons.rocketLauncher += quantity;
        break;
      case 'submachine_gun':
        _gameState.weapons.submachineGun += quantity;
        break;
      case 'flamethrower':
        _gameState.weapons.flamethrower += quantity;
        break;
      case 'vest_light':
        _gameState.weapons.vest = 5;
        break;
      case 'vest_medium':
        _gameState.weapons.vest = 10;
        break;
      case 'vest_heavy':
        _gameState.weapons.vest = 15;
        break;
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
      _gameMessage =
          'Bought $quantity kilo(s) of $drugType for \$${cost.toString()}!';
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

      _gameMessage =
          'Sold $quantity kilo(s) of $drugType for \$${revenue.toString()}!';

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
        break;
      case 'crack':
        _gameState.drugs.crack += quantity;
        break;
      case 'coke':
        _gameState.drugs.coke += quantity;
        break;
      case 'ice':
        _gameState.drugs.ice += quantity;
        break;
      case 'percs':
        _gameState.drugs.percs += quantity;
        break;
      case 'pixie_dust':
        _gameState.drugs.pixieDust += quantity;
        break;
    }
  }

  void _removeDrug(String drugType, int quantity) {
    final normalized = _normalizeDrugType(drugType);
    switch (normalized) {
      case 'weed':
        _gameState.drugs.weed -= quantity;
        break;
      case 'crack':
        _gameState.drugs.crack -= quantity;
        break;
      case 'coke':
        _gameState.drugs.coke -= quantity;
        break;
      case 'ice':
        _gameState.drugs.ice -= quantity;
        break;
      case 'percs':
        _gameState.drugs.percs -= quantity;
        break;
      case 'pixie_dust':
        _gameState.drugs.pixieDust -= quantity;
        break;
    }
  }

  bool performCombat(String weapon, String enemyType, int enemyCount) {
    // Use the stored enemy health from combat data to maintain scaling/power factor
    final perEnemyHealth =
        (_currentCombatData?.initialEnemyHealth ??
                _calculateEnemyHealth(enemyType, enemyCount))
            .toDouble();

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
    final random = Random();
    int totalIncome = 0;
    for (int i = 0; i < _gameState.prostitutes.count; i++) {
      totalIncome += 3500 + random.nextInt(1301);
    }

    _gameState.advanceDay();

    _gameMessage = 'A new day begins! Day ${_gameState.day}';
    if (_gameState.prostitutes.count > 0) {
      _gameMessage += '\nYour prostitutes earned you \$$totalIncome tonight.';
    }

    saveGameState();
    notifyListeners();
  }

  String wander() {
    final event = wanderWithEvent();
    return event?.description ?? _gameMessage;
  }

  RandomEvent? wanderWithEvent() {
    _gameState.steps++;

    if (_gameState.steps >= _gameState.maxSteps) {
      _advanceDayWithIncome();

      if (_gameState.loan > 0 &&
          (_gameState.day - _gameState.loanDayTaken) >= 2) {
        _gameState.flags.hasAttractedLoanShark = true;
      }

      return null;
    }

    if (_gameState.loan > 0 &&
        _gameState.flags.hasAttractedLoanShark &&
        Random().nextDouble() < 0.2) {
      final msg = _handleLoanSharkEncounter();
      _gameMessage = msg;
      return null;
    }

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

    if (event.options.isNotEmpty) {
      return event;
    }

    RandomEventData.applyEventEffects(event, _gameState);

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
        break;
    }

    _gameMessage = event.description;
    return event;
  }

  String _handleLoanSharkEncounter() {
    final repaymentAmount = (_gameState.loan * 1.5).toInt();
    startMudFight(200, 1, 'Loan Shark Enforcer', 'loan_shark_boss_fight');
    return 'A Loan Shark Enforcer corners you! "You owe us \$$repaymentAmount, punk!"';
  }

  String handleNpcInteraction(RandomEvent event, String option) {
    if (!event.optionEffects.containsKey(option)) {
      return 'Nothing happens.';
    }

    final effects = event.optionEffects[option]!;
    bool interactionSuccess = true;

    effects.forEach((key, value) {
      switch (key) {
        case 'damage':
          if (option == 'Fight' || option == 'Challenge' || option == 'YES (FIGHT)') {
             int enemyHealth = 100;
             int enemyCount = 1;
             String enemyName = event.title.replaceFirst('👤 DARK ENCOUNTER: ', '')
                                         .replaceFirst('🩸 TERRITORY DISPUTE', 'Rival Gang')
                                         .replaceFirst('🪤 THE SLAUGHTERHOUSE', 'Ambushers');
             
             if (event.type == EventType.gangFight) {
               enemyCount = 3;
             } else if (event.type == EventType.policeChase) {
               enemyName = 'Police Officers';
               enemyCount = 4;
               enemyHealth = 150;
             }
             
             startMudFight(enemyHealth, enemyCount, enemyName, event.id);
             _gameMessage = 'You engaged the $enemyName!';
          } else {
            _gameMessage = 'You took $value damage.';
            _gameState.takeDamage(value);
          }
          break;
        case 'health':
          _gameState.heal(value);
          _gameMessage = 'You healed $value health.';
          break;
        case 'money':
          if (value > 0) {
            _gameState.money += value;
            _gameMessage = 'You got \$$value.';
          } else {
            if (!_gameState.spendMoney(-value)) {
              _gameMessage = 'You didn\'t have enough money!';
              interactionSuccess = false;
            }
          }
          break;
        case 'drugs':
           // Add a default drug if not specified, or just add crack
           _addDrug('crack', value);
           _gameMessage = 'You received $value kilos of crack.';
           break;
        case 'members':
           _gameState.members = min(100, _gameState.members + value);
           _gameMessage = 'You recruited $value new members.';
           break;
      }
    });
    
    // Handle specific event type transitions if needed
    if (interactionSuccess) {
       if (event.type == EventType.weaponFound && option == 'YES') {
          // Grant random weapon
          final weapons = ['pistol', 'knife', 'brass_knuckles', 'uzi'];
          final weapon = weapons[Random().nextInt(weapons.length)];
          _addWeapon(weapon, 1);
          _gameMessage = 'You found a $weapon!';
       }
    }
    
    saveGameState();
    notifyListeners();
    return _gameMessage;
  }
}
