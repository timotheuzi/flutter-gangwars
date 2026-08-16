import 'dart:math';
import 'package:flutter/material.dart';

class GameState with ChangeNotifier {
  String playerName = '';
  String gangName = '';
  int money = 1000;
  int account = 0; // Bank account
  int loan = 0;
  int loanDayTaken = 0;
  int members = 1; // Gang members
  int reputation = 0; // Gang reputation
  int squidies = 20; // Enemy gang members
  int day = 1;
  int health = 30;
  int maxHealth = 100;
  int steps = 0;
  int maxSteps = 8; // Reduced from 15 to make days pass faster
  int lives = 3;
  int damage = 0;
  int currentScore = 0;
  String currentLocation = 'procedural_open_world';
  double accuracy = 0.85; // Base accuracy rating

  Map<String, int> drugPrices = {
    'weed': 500,
    'crack': 1000,
    'coke': 2000,
    'ice': 1500,
    'percs': 800,
    'pixie_dust': 3000,
  };

  // Future drug trends
  Map<String, String> drugTrends = {};

  Flags flags = Flags();
  Weapons weapons = Weapons();
  Drugs drugs = Drugs();
  Prostitutes prostitutes = Prostitutes();

  // Squidies gang enhancements
  int squidiesGainedToday = 0;
  double squidiesCriticalHitChance = 0.1;

  // Gang HP system
  List<GangMember> gangMembers = [];

  // Additional weapons (legacy - prefer weapons object)
  int machineGun = 0;
  int rocketLauncher = 0;
  int submachineGun = 0;
  int flamethrower = 0;

  // Pistol upgrade properties
  String pistolUpgradeType = 'none';
  bool pistolUpgraded = false;
  bool pistolUpgradeToggle = false;

  GameState({
    this.playerName = '',
    this.gangName = '',
    this.money = 1000,
    this.account = 0,
    this.loan = 0,
    this.loanDayTaken = 0,
    this.members = 1,
    this.reputation = 0,
    this.squidies = 20,
    this.day = 1,
    this.health = 30,
    this.maxHealth = 100,
    this.steps = 0,
    this.maxSteps = 8,
    this.lives = 3,
    this.damage = 0,
    this.currentScore = 0,
    this.currentLocation = 'procedural_open_world',
    this.accuracy = 0.85,
  });

  void updateCurrentScore() {
    final moneyEarned = money + account;
    final survivalScore = day * 100;
    final moneyScore = moneyEarned ~/ 1000;
    currentScore = moneyScore + survivalScore;
    notifyListeners();
  }

  bool isGameOver() => lives <= 0 || (health <= 0 && lives <= 0);

  bool canAfford(int amount) => money >= amount;

  bool spendMoney(int amount) {
    if (canAfford(amount)) {
      money -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  void heal(int amount) {
    health = min(maxHealth, health + amount);
    damage = max(0, maxHealth - health);
    notifyListeners();
  }

  void takeDamage(int amount) {
    health = max(0, health - amount);
    damage = maxHealth - health;
    if (health <= 0) {
      lives = max(0, lives - 1);
    }
    notifyListeners();
  }

  void advanceDay() {
    day++;
    steps = 0;
    squidiesGainedToday = 0;

    // Squidies gain members
    if (Random().nextDouble() < 0.15) {
      squidies++;
      squidiesGainedToday = 1;
    }

    // Player reputation attracts recruits
    final recruitChance = reputation / 1000.0;
    if (Random().nextDouble() < recruitChance) {
      final newRecruits = switch (reputation) {
        >= 200 => Random().nextInt(3) + 1,
        >= 100 => Random().nextInt(2) + 1,
        >= 50 => Random().nextInt(1) + 1,
        _ => 1,
      };
      members += newRecruits;
      if (members > 100) members = 100;
    }

    // Prostitutes generate income: $3500 - $4800 per day
    final random = Random();
    int totalIncome = 0;
    for (int i = 0; i < prostitutes.count; i++) {
      totalIncome += 3500 + random.nextInt(1301); // 4800 - 3500 + 1
    }
    money += totalIncome;

    // Increase squidies critical hit chance
    squidiesCriticalHitChance = min(0.25, squidiesCriticalHitChance + 0.005);

    // Initialize gang members
    if (gangMembers.isEmpty) {
      for (int i = 1; i <= members; i++) {
        gangMembers.add(GangMember('Member $i', 100, []));
      }
    } else {
      while (gangMembers.length < members) {
        gangMembers.add(
          GangMember('Member ${gangMembers.length + 1}', 100, []),
        );
      }
    }

    updateDrugPrices();
    generateDrugTrends();

    notifyListeners();
  }

  void updateDrugPrices() {
    final random = Random();
    for (var drug in drugPrices.keys) {
      final basePrice = switch (drug) {
        'weed' => 500,
        'crack' => 1000,
        'coke' => 2000,
        'ice' => 1500,
        'percs' => 800,
        'pixie_dust' => 3000,
        _ => 500,
      };

      // Check for trends from previous day
      double modifier = 1.0;
      if (drugTrends.containsKey(drug)) {
        if (drugTrends[drug]!.contains('skyrocket')) {
          modifier = 2.0 + random.nextDouble(); // Massive spike
        } else if (drugTrends[drug]!.contains('tank')) {
          modifier = 0.2 + random.nextDouble() * 0.3; // Massive drop
        }
      }

      final volatility = 0.15 + (day * 0.01);
      final variation = (random.nextDouble() * (volatility * 2)) - volatility;
      drugPrices[drug] = max(
        10,
        (basePrice * modifier * (1 + variation)).toInt(),
      );
    }
  }

  void generateDrugTrends() {
    drugTrends.clear();
    final random = Random();
    final drugs = drugPrices.keys.toList();

    // Always generate 2-3 significant trends to keep the bar talk active
    final numTrends = random.nextInt(2) + 2;
    final shuffledDrugs = List.from(drugs)..shuffle();

    for (int i = 0; i < numTrends; i++) {
      final drug = shuffledDrugs[i];
      final isBust = random.nextBool();
      final displayName = drug.replaceAll('_', ' ');
      if (isBust) {
        drugTrends[drug] =
            'The Feds just made a massive bust on a $displayName shipment. Prices are gonna skyrocket tomorrow.';
      } else {
        drugTrends[drug] =
            'Word is the market is being flooded with cheap $displayName from the border. Prices are gonna tank soon.';
      }
    }
  }

  // Convert to JSON for saving
  Map<String, dynamic> toJson() => {
    'playerName': playerName,
    'gangName': gangName,
    'money': money,
    'account': account,
    'loan': loan,
    'loanDayTaken': loanDayTaken,
    'members': members,
    'reputation': reputation,
    'squidies': squidies,
    'day': day,
    'health': health,
    'maxHealth': maxHealth,
    'steps': steps,
    'maxSteps': maxSteps,
    'lives': lives,
    'damage': damage,
    'currentScore': currentScore,
    'currentLocation': currentLocation,
    'accuracy': accuracy,
    'drugPrices': drugPrices,
    'drugTrends': drugTrends,
    'flags': flags.toJson(),
    'weapons': weapons.toJson(),
    'drugs': drugs.toJson(),
    'prostitutes': prostitutes.toJson(),
    'squidiesGainedToday': squidiesGainedToday,
    'squidiesCriticalHitChance': squidiesCriticalHitChance,
    'gangMembers': gangMembers.map((m) => m.toJson()).toList(),
    'machineGun': machineGun,
    'rocketLauncher': rocketLauncher,
    'submachineGun': submachineGun,
    'flamethrower': flamethrower,
    'pistolUpgradeType': pistolUpgradeType,
    'pistolUpgraded': pistolUpgraded,
    'pistolUpgradeToggle': pistolUpgradeToggle,
  };

  // Create from JSON
  factory GameState.fromJson(Map<String, dynamic> json) {
    final state = GameState(
      playerName: json['playerName'] ?? '',
      gangName: json['gangName'] ?? '',
      money: json['money'] ?? 1000,
      account: json['account'] ?? 0,
      loan: json['loan'] ?? 0,
      loanDayTaken: json['loanDayTaken'] ?? 0,
      members: json['members'] ?? 1,
      reputation: json['reputation'] ?? 0,
      squidies: json['squidies'] ?? 20,
      day: json['day'] ?? 1,
      health: json['health'] ?? 30,
      maxHealth: json['maxHealth'] ?? 100,
      steps: json['steps'] ?? 0,
      maxSteps: json['maxSteps'] ?? 8,
      lives: json['lives'] ?? 3,
      damage: json['damage'] ?? 0,
      currentScore: json['currentScore'] ?? 0,
      currentLocation: json['currentLocation'] ?? 'procedural_open_world',
      accuracy: (json['accuracy'] ?? 0.85).toDouble(),
    );

    state.drugPrices = Map<String, int>.from(json['drugPrices'] ?? {});
    state.drugTrends = Map<String, String>.from(json['drugTrends'] ?? {});
    state.flags = Flags.fromJson(json['flags'] ?? {});
    state.weapons = Weapons.fromJson(json['weapons'] ?? {});
    state.drugs = Drugs.fromJson(json['drugs'] ?? {});
    state.prostitutes = Prostitutes.fromJson(json['prostitutes'] ?? {});
    state.squidiesGainedToday = json['squidiesGainedToday'] ?? 0;
    state.squidiesCriticalHitChance = (json['squidiesCriticalHitChance'] ?? 0.1)
        .toDouble();
    state.gangMembers = (json['gangMembers'] as List? ?? [])
        .map((m) => GangMember.fromJson(m))
        .toList();
    state.machineGun = json['machineGun'] ?? 0;
    state.rocketLauncher = json['rocketLauncher'] ?? 0;
    state.submachineGun = json['submachineGun'] ?? 0;
    state.flamethrower = json['flamethrower'] ?? 0;
    state.pistolUpgradeType = json['pistolUpgradeType'] ?? 'none';
    state.pistolUpgraded = json['pistolUpgraded'] ?? false;
    state.pistolUpgradeToggle = json['pistolUpgradeToggle'] ?? false;

    return state;
  }
}

class GangMember {
  String name;
  int health;
  List<String> equippedWeapons;

  GangMember(this.name, this.health, this.equippedWeapons);

  Map<String, dynamic> toJson() => {
    'name': name,
    'health': health,
    'equippedWeapons': equippedWeapons,
  };

  factory GangMember.fromJson(Map<String, dynamic> json) {
    return GangMember(
      json['name'] ?? '',
      json['health'] ?? 100,
      List<String>.from(json['equippedWeapons'] ?? []),
    );
  }
}

class Flags {
  bool hasId = false;
  bool hasInfo = false;
  bool hasSwitch = false;
  bool hasAttractedLoanShark = false;

  Flags(); // Default constructor

  Map<String, dynamic> toJson() => {
    'hasId': hasId,
    'hasInfo': hasInfo,
    'hasSwitch': hasSwitch,
    'hasAttractedLoanShark': hasAttractedLoanShark,
  };

  factory Flags.fromJson(Map<String, dynamic> json) {
    return Flags()
      ..hasId = json['hasId'] ?? false
      ..hasInfo = json['hasInfo'] ?? false
      ..hasSwitch = json['hasSwitch'] ?? false
      ..hasAttractedLoanShark = json['hasAttractedLoanShark'] ?? false;
  }
}

class Weapons {
  int pistols = 1;
  int bullets = 10;
  int explodingBullets = 0;
  int hollowPointBullets = 0;
  bool useExplodingBullets = false;
  bool useHollowPointBullets = false;
  int uzis = 0;
  int grenades = 0;
  int barbedWireBat = 0;
  int brassKnuckles = 0;
  int vampireBat = 0;
  int missileLauncher = 0;
  int missiles = 0;
  int ar15 = 0;
  int vest = 0;
  int knife = 0;
  int ghostGuns = 0;
  int sword = 0;
  int axe = 0;
  int goldenGun = 0;
  int poisonBlowgun = 0;
  int goldenSword = 0;
  int goldenAxe = 0;
  int goldenKnife = 0;
  int goldenUzi = 0;
  int goldenAr15 = 0;
  int machineGun = 0;
  int rocketLauncher = 0;
  int submachineGun = 0;
  int flamethrower = 0;

  Weapons(); // Default constructor

  int get totalBullets => bullets + explodingBullets + hollowPointBullets;

  bool canFightWithPistol() =>
      pistols > 0 &&
      (bullets > 0 || explodingBullets > 0 || hollowPointBullets > 0);
  bool canFightWithUzi() =>
      uzis > 0 &&
      (bullets >= 3 || explodingBullets >= 3 || hollowPointBullets >= 3);
  bool canFightWithAr15() =>
      ar15 > 0 &&
      (bullets > 0 || explodingBullets > 0 || hollowPointBullets > 0);
  bool canFightWithGhostGun() =>
      ghostGuns > 0 &&
      (bullets > 0 || explodingBullets > 0 || hollowPointBullets > 0);
  bool canFightWithGrenade() => grenades > 0;
  bool canFightWithMissile() => missileLauncher > 0 && missiles > 0;
  bool canFightWithMachineGun() =>
      machineGun > 0 &&
      (bullets > 0 || explodingBullets > 0 || hollowPointBullets >= 3);
  bool canFightWithRocketLauncher() => rocketLauncher > 0 && missiles > 0;
  bool canFightWithSubmachineGun() =>
      submachineGun > 0 &&
      (bullets > 0 || explodingBullets > 0 || hollowPointBullets > 0);
  bool canFightWithFlamethrower() => flamethrower > 0;

  Map<String, dynamic> toJson() => {
    'pistols': pistols,
    'bullets': bullets,
    'explodingBullets': explodingBullets,
    'hollowPointBullets': hollowPointBullets,
    'useExplodingBullets': useExplodingBullets,
    'useHollowPointBullets': useHollowPointBullets,
    'uzis': uzis,
    'grenades': grenades,
    'barbedWireBat': barbedWireBat,
    'brassKnuckles': brassKnuckles,
    'vampireBat': vampireBat,
    'missileLauncher': missileLauncher,
    'missiles': missiles,
    'ar15': ar15,
    'vest': vest,
    'knife': knife,
    'ghostGuns': ghostGuns,
    'sword': sword,
    'axe': axe,
    'goldenGun': goldenGun,
    'poisonBlowgun': poisonBlowgun,
    'goldenSword': goldenSword,
    'goldenAxe': goldenAxe,
    'goldenKnife': goldenKnife,
    'goldenUzi': goldenUzi,
    'goldenAr15': goldenAr15,
    'machineGun': machineGun,
    'rocketLauncher': rocketLauncher,
    'submachineGun': submachineGun,
    'flamethrower': flamethrower,
  };

  factory Weapons.fromJson(Map<String, dynamic> json) {
    return Weapons()
      ..pistols = json['pistols'] ?? 1
      ..bullets = json['bullets'] ?? 10
      ..explodingBullets = json['explodingBullets'] ?? 0
      ..hollowPointBullets = json['hollowPointBullets'] ?? 0
      ..useExplodingBullets = json['useExplodingBullets'] ?? false
      ..useHollowPointBullets = json['useHollowPointBullets'] ?? false
      ..uzis = json['uzis'] ?? 0
      ..grenades = json['grenades'] ?? 0
      ..barbedWireBat = json['barbedWireBat'] ?? 0
      ..brassKnuckles = json['brassKnuckles'] ?? 0
      ..vampireBat = json['vampireBat'] ?? 0
      ..missileLauncher = json['missileLauncher'] ?? 0
      ..missiles = json['missiles'] ?? 0
      ..ar15 = json['ar15'] ?? 0
      ..vest = json['vest'] ?? 0
      ..knife = json['knife'] ?? 0
      ..ghostGuns = json['ghostGuns'] ?? 0
      ..sword = json['sword'] ?? 0
      ..axe = json['axe'] ?? 0
      ..goldenGun = json['goldenGun'] ?? 0
      ..poisonBlowgun = json['poisonBlowgun'] ?? 0
      ..goldenSword = json['goldenSword'] ?? 0
      ..goldenAxe = json['goldenAxe'] ?? 0
      ..goldenKnife = json['goldenKnife'] ?? 0
      ..goldenUzi = json['goldenUzi'] ?? 0
      ..goldenAr15 = json['goldenAr15'] ?? 0
      ..machineGun = json['machineGun'] ?? 0
      ..rocketLauncher = json['rocketLauncher'] ?? 0
      ..submachineGun = json['submachineGun'] ?? 0
      ..flamethrower = json['flamethrower'] ?? 0;
  }
}

class Drugs {
  int weed = 0;
  int crack = 5; // Start with 5 kilos
  int coke = 0;
  int ice = 0;
  int percs = 0;
  int pixieDust = 0;

  Drugs(); // Default constructor

  int getTotalValue(Map<String, int> prices) {
    return weed * (prices['weed'] ?? 0) +
        crack * (prices['crack'] ?? 0) +
        coke * (prices['coke'] ?? 0) +
        ice * (prices['ice'] ?? 0) +
        percs * (prices['percs'] ?? 0) +
        pixieDust * (prices['pixie_dust'] ?? 0);
  }

  Map<String, dynamic> toJson() => {
    'weed': weed,
    'crack': crack,
    'coke': coke,
    'ice': ice,
    'percs': percs,
    'pixie_dust': pixieDust,
  };

  factory Drugs.fromJson(Map<String, dynamic> json) {
    return Drugs()
      ..weed = json['weed'] ?? 0
      ..crack = json['crack'] ?? 5
      ..coke = json['coke'] ?? 0
      ..ice = json['ice'] ?? 0
      ..percs = json['percs'] ?? 0
      ..pixieDust = json['pixie_dust'] ?? 0;
  }
}

class Prostitutes {
  int count = 0;
  int price = 5000;

  Prostitutes();

  Map<String, dynamic> toJson() => {'count': count, 'price': price};

  factory Prostitutes.fromJson(Map<String, dynamic> json) {
    return Prostitutes()
      ..count = json['count'] ?? 0
      ..price = json['price'] ?? 5000;
  }
}
