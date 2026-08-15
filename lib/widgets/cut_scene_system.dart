import 'package:flutter/material.dart';
import 'dart:math';
import 'comprehensive_sprites.dart';

/// Cut Scene System for Gang Wars
/// Provides cinematic cut scenes for important game events

class CutSceneManager {
  static final CutSceneManager _instance = CutSceneManager._internal();

  factory CutSceneManager() => _instance;

  CutSceneManager._internal();

  /// Show a gang fight cut scene
  static Future<void> showGangFightCutScene({
    required BuildContext context,
    required String playerGangName,
    required String enemyGangName,
    required int playerMembers,
    required int enemyMembers,
    VoidCallback? onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _GangFightCutScene(
        playerGangName: playerGangName,
        enemyGangName: enemyGangName,
        playerMembers: playerMembers,
        enemyMembers: enemyMembers,
        onComplete: onComplete,
      ),
    );
  }

  /// Show a drug usage cut scene
  static Future<void> showDrugUsageCutScene({
    required BuildContext context,
    required String drugType,
    required String userName,
    required int quantity,
    VoidCallback? onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DrugUsageCutScene(
        drugType: drugType,
        userName: userName,
        quantity: quantity,
        onComplete: onComplete,
      ),
    );
  }

  /// Show a major drug deal cut scene
  static Future<void> showDrugDealCutScene({
    required BuildContext context,
    required String drugType,
    required String dealerName,
    required int quantity,
    required int price,
    required bool isSuccessful,
    VoidCallback? onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DrugDealCutScene(
        drugType: drugType,
        dealerName: dealerName,
        quantity: quantity,
        price: price,
        isSuccessful: isSuccessful,
        onComplete: onComplete,
      ),
    );
  }

  /// Show a police raid cut scene
  static Future<void> showPoliceRaidCutScene({
    required BuildContext context,
    required String locationName,
    required int policeCount,
    required bool isPlayerCaught,
    VoidCallback? onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PoliceRaidCutScene(
        locationName: locationName,
        policeCount: policeCount,
        isPlayerCaught: isPlayerCaught,
        onComplete: onComplete,
      ),
    );
  }

  /// Show a gang territory takeover cut scene
  static Future<void> showTerritoryTakeoverCutScene({
    required BuildContext context,
    required String territoryName,
    required String oldGangName,
    required String newGangName,
    VoidCallback? onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _TerritoryTakeoverCutScene(
        territoryName: territoryName,
        oldGangName: oldGangName,
        newGangName: newGangName,
        onComplete: onComplete,
      ),
    );
  }

  /// Show a boss fight cut scene
  static Future<void> showBossFightCutScene({
    required BuildContext context,
    required String bossName,
    required String bossGangName,
    required String weaponType,
    VoidCallback? onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _BossFightCutScene(
        bossName: bossName,
        bossGangName: bossGangName,
        weaponType: weaponType,
        onComplete: onComplete,
      ),
    );
  }

  /// Show a player death cut scene
  static Future<void> showPlayerDeathCutScene({
    required BuildContext context,
    required String killerName,
    required String weaponType,
    required String locationName,
    VoidCallback? onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PlayerDeathCutScene(
        killerName: killerName,
        weaponType: weaponType,
        locationName: locationName,
        onComplete: onComplete,
      ),
    );
  }

  /// Show a victory cut scene
  static Future<void> showVictoryCutScene({
    required BuildContext context,
    required String enemyGangName,
    required int moneyEarned,
    required int territoryGained,
    VoidCallback? onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _VictoryCutScene(
        enemyGangName: enemyGangName,
        moneyEarned: moneyEarned,
        territoryGained: territoryGained,
        onComplete: onComplete,
      ),
    );
  }
}

// Gang Fight Cut Scene
class _GangFightCutScene extends StatefulWidget {
  final String playerGangName;
  final String enemyGangName;
  final int playerMembers;
  final int enemyMembers;
  final VoidCallback? onComplete;

  const _GangFightCutScene({
    required this.playerGangName,
    required this.enemyGangName,
    required this.playerMembers,
    required this.enemyMembers,
    this.onComplete,
  });

  @override
  _GangFightCutSceneState createState() => _GangFightCutSceneState();
}

class _GangFightCutSceneState extends State<_GangFightCutScene>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _shakeController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _shakeAnimation;
  int _currentPhase = 0;
  final List<_FightAction> _fightActions = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _mainController.forward().then((_) {
      widget.onComplete?.call();
      Navigator.of(context).pop();
    });

    _startFightSequence();
  }

  void _startFightSequence() {
    // Phase 1: Confrontation
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _currentPhase = 1);
    });

    // Phase 2: Fight begins
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _currentPhase = 2);
      _generateFightActions();
    });

    // Phase 3: Intense fighting
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _currentPhase = 3);
    });

    // Phase 4: Resolution
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) setState(() => _currentPhase = 4);
    });
  }

  void _generateFightActions() {
    final actions = ['punch', 'kick', 'shoot', 'dodge'];
    final colors = [Colors.white, Colors.yellow, Colors.red, Colors.blue];

    for (int i = 0; i < 15; i++) {
      Future.delayed(Duration(milliseconds: 300 * i), () {
        if (mounted) {
          setState(() {
            _fightActions.add(
              _FightAction(
                type: actions[_random.nextInt(actions.length)],
                position: Offset(
                  100 + _random.nextDouble() * 200,
                  100 + _random.nextDouble() * 100,
                ),
                color: colors[_random.nextInt(colors.length)],
                size: 20 + _random.nextDouble() * 20,
              ),
            );
          });
          _shakeController.forward().then((_) => _shakeController.reverse());
        }
      });
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _slideAnimation.value * MediaQuery.of(context).size.width,
            0,
          ),
          child: Opacity(
            opacity: _fadeInAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.shade900, width: 3),
                ),
                child: Column(
                  children: [
                    // Title
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'GANG WAR',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Fight scene
                    Expanded(
                      child: Stack(
                        children: [
                          // Background
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.grey.shade900, Colors.black],
                              ),
                            ),
                          ),

                          // Player gang
                          Positioned(
                            left: 50,
                            top: 100,
                            child: Column(
                              children: [
                                Text(
                                  widget.playerGangName,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: List.generate(
                                    widget.playerMembers.clamp(0, 5),
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child:
                                          ComprehensiveSprites.createPoliceSprite(
                                            size: 40,
                                            state: _currentPhase >= 2
                                                ? PoliceState.shooting
                                                : PoliceState.idle,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Enemy gang
                          Positioned(
                            right: 50,
                            top: 100,
                            child: Column(
                              children: [
                                Text(
                                  widget.enemyGangName,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: List.generate(
                                    widget.enemyMembers.clamp(0, 5),
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child:
                                          ComprehensiveSprites.createCivilianSprite(
                                            size: 40,
                                            type: CivilianType.man,
                                            state: _currentPhase >= 2
                                                ? CivilianState.scared
                                                : CivilianState.idle,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // VS text
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 150,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _shakeAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      _shakeAnimation.value * 5,
                                      0,
                                    ),
                                    child: Text(
                                      'VS',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.red,
                                            blurRadius: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Fight actions
                          ..._fightActions.map(
                            (action) => _buildFightAction(action),
                          ),

                          // Phase text
                          Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                _getPhaseText(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Skip button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onComplete?.call();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFightAction(_FightAction action) {
    return Positioned(
      left: action.position.dx,
      top: action.position.dy,
      child: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + _shakeAnimation.value * 0.3,
            child: Text(
              _getActionSymbol(action.type),
              style: TextStyle(
                color: action.color,
                fontSize: action.size,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  String _getActionSymbol(String action) {
    switch (action) {
      case 'punch':
        return '👊';
      case 'kick':
        return '🦵';
      case 'shoot':
        return '💥';
      case 'dodge':
        return '💨';
      default:
        return '⚔️';
    }
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case 0:
        return 'Two gangs meet...';
      case 1:
        return 'Tensions rise...';
      case 2:
        return 'The fight begins!';
      case 3:
        return 'Intense combat!';
      case 4:
        return 'The battle ends...';
      default:
        return '';
    }
  }
}

// Drug Usage Cut Scene
class _DrugUsageCutScene extends StatefulWidget {
  final String drugType;
  final String userName;
  final int quantity;
  final VoidCallback? onComplete;

  const _DrugUsageCutScene({
    required this.drugType,
    required this.userName,
    required this.quantity,
    this.onComplete,
  });

  @override
  _DrugUsageCutSceneState createState() => _DrugUsageCutSceneState();
}

class _DrugUsageCutSceneState extends State<_DrugUsageCutScene>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _zoomAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _colorAnimation;
  int _currentPhase = 0;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeInOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _colorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _mainController.forward().then((_) {
      widget.onComplete?.call();
      Navigator.of(context).pop();
    });

    _startDrugSequence();
  }

  void _startDrugSequence() {
    // Phase 1: Preparation
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _currentPhase = 1);
    });

    // Phase 2: Usage
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _currentPhase = 2);
      _pulseController.repeat(reverse: true);
    });

    // Phase 3: Effects begin
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _currentPhase = 3);
    });

    // Phase 4: Peak effects
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _currentPhase = 4);
    });

    // Phase 5: Coming down
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _currentPhase = 5);
      _pulseController.stop();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Transform.scale(
          scale: _zoomAnimation.value,
          child: Opacity(
            opacity: _fadeInAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getDrugColor(), width: 3),
                ),
                child: Column(
                  children: [
                    // Title
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'USING ${widget.drugType.toUpperCase()}',
                        style: TextStyle(
                          color: _getDrugColor(),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Drug scene
                    Expanded(
                      child: Stack(
                        children: [
                          // Background with color animation
                          Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.center,
                                colors: [
                                  _getDrugColor().withValues(
                                    alpha: _colorAnimation.value * 0.3,
                                  ),
                                  Colors.black,
                                ],
                              ),
                            ),
                          ),

                          // User character
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 100,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child:
                                        ComprehensiveSprites.createCivilianSprite(
                                          size: 80,
                                          type: CivilianType.man,
                                          state: _currentPhase >= 2
                                              ? CivilianState.scared
                                              : CivilianState.idle,
                                        ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Drug sprite
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 200,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 + _pulseController.value * 0.2,
                                    child:
                                        ComprehensiveSprites.createDrugSprite(
                                          size: 60,
                                          type: _getDrugType(),
                                          state: _currentPhase >= 2
                                              ? DrugState.collected
                                              : DrugState.idle,
                                        ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Effects
                          if (_currentPhase >= 3) ...[
                            // Visual effects
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _DrugEffectPainter(
                                  color: _getDrugColor(),
                                  intensity: _colorAnimation.value,
                                  phase: _currentPhase,
                                ),
                              ),
                            ),

                            // Floating particles
                            ..._buildParticles(),
                          ],

                          // Phase text
                          Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                _getPhaseText(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Skip button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onComplete?.call();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getDrugColor() {
    switch (widget.drugType.toLowerCase()) {
      case 'weed':
        return Colors.green;
      case 'crack':
        return Colors.yellow.shade100;
      case 'coke':
        return Colors.white;
      case 'ice':
        return Colors.lightBlue;
      case 'percs':
        return Colors.pink;
      case 'pixie dust':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  DrugType _getDrugType() {
    switch (widget.drugType.toLowerCase()) {
      case 'weed':
        return DrugType.weed;
      case 'crack':
        return DrugType.crack;
      case 'coke':
        return DrugType.coke;
      case 'ice':
        return DrugType.ice;
      case 'percs':
        return DrugType.percs;
      case 'pixie dust':
        return DrugType.pixie;
      default:
        return DrugType.weed;
    }
  }

  List<Widget> _buildParticles() {
    final particles = <Widget>[];
    final random = Random();

    for (int i = 0; i < 20; i++) {
      particles.add(
        Positioned(
          left: random.nextDouble() * 300,
          top: random.nextDouble() * 300,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Opacity(
                opacity: 0.5 + _pulseController.value * 0.5,
                child: Container(
                  width: 4 + random.nextDouble() * 4,
                  height: 4 + random.nextDouble() * 4,
                  decoration: BoxDecoration(
                    color: _getDrugColor(),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return particles;
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case 0:
        return 'Preparing to use...';
      case 1:
        return 'Getting ready...';
      case 2:
        return 'Using the drug...';
      case 3:
        return 'Effects starting...';
      case 4:
        return 'Feeling the high...';
      case 5:
        return 'Coming down...';
      default:
        return '';
    }
  }
}

// Drug Deal Cut Scene
class _DrugDealCutScene extends StatefulWidget {
  final String drugType;
  final String dealerName;
  final int quantity;
  final int price;
  final bool isSuccessful;
  final VoidCallback? onComplete;

  const _DrugDealCutScene({
    required this.drugType,
    required this.dealerName,
    required this.quantity,
    required this.price,
    required this.isSuccessful,
    this.onComplete,
  });

  @override
  _DrugDealCutSceneState createState() => _DrugDealCutSceneState();
}

class _DrugDealCutSceneState extends State<_DrugDealCutScene>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  int _currentPhase = 0;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );

    _mainController.forward().then((_) {
      widget.onComplete?.call();
      Navigator.of(context).pop();
    });

    _startDealSequence();
  }

  void _startDealSequence() {
    // Phase 1: Meeting
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _currentPhase = 1);
    });

    // Phase 2: Negotiation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _currentPhase = 2);
    });

    // Phase 3: Exchange
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _currentPhase = 3);
    });

    // Phase 4: Result
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _currentPhase = 4);
    });

    // Phase 5: Conclusion
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _currentPhase = 5);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _slideAnimation.value * MediaQuery.of(context).size.width,
            0,
          ),
          child: Opacity(
            opacity: _fadeInAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.isSuccessful ? Colors.green : Colors.red,
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    // Title
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        widget.isSuccessful
                            ? 'DRUG DEAL SUCCESSFUL'
                            : 'DRUG DEAL FAILED',
                        style: TextStyle(
                          color: widget.isSuccessful
                              ? Colors.green
                              : Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Deal scene
                    Expanded(
                      child: Stack(
                        children: [
                          // Background
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.grey.shade900, Colors.black],
                              ),
                            ),
                          ),

                          // Dealer
                          Positioned(
                            right: 80,
                            top: 100,
                            child: Column(
                              children: [
                                Text(
                                  widget.dealerName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ComprehensiveSprites.createCivilianSprite(
                                  size: 60,
                                  type: CivilianType.man,
                                  state: _currentPhase >= 3
                                      ? CivilianState.idle
                                      : CivilianState.walking,
                                ),
                              ],
                            ),
                          ),

                          // Player
                          Positioned(
                            left: 80,
                            top: 100,
                            child: Column(
                              children: [
                                const Text(
                                  'YOU',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ComprehensiveSprites.createPoliceSprite(
                                  size: 60,
                                  state: _currentPhase >= 3
                                      ? PoliceState.idle
                                      : PoliceState.idle,
                                ),
                              ],
                            ),
                          ),

                          // Drug and money exchange
                          if (_currentPhase >= 3) ...[
                            // Drug sprite
                            Positioned(
                              left: 150,
                              top: 180,
                              child: ComprehensiveSprites.createDrugSprite(
                                size: 40,
                                type: _getDrugType(),
                                state: DrugState.floating,
                              ),
                            ),

                            // Money sprite
                            Positioned(
                              right: 150,
                              top: 180,
                              child: ComprehensiveSprites.createMoneySprite(
                                size: 40,
                                denomination: MoneyDenomination.hundred,
                                state: MoneyState.floating,
                              ),
                            ),
                          ],

                          // Deal info
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 250,
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '${widget.quantity}x ${widget.drugType.toUpperCase()}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '\$${widget.price}',
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Result indicator
                          if (_currentPhase >= 4)
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 320,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.isSuccessful
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    widget.isSuccessful
                                        ? 'DEAL COMPLETED'
                                        : 'DEAL FAILED',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          // Phase text
                          Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                _getPhaseText(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Skip button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onComplete?.call();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  DrugType _getDrugType() {
    switch (widget.drugType.toLowerCase()) {
      case 'weed':
        return DrugType.weed;
      case 'crack':
        return DrugType.crack;
      case 'coke':
        return DrugType.coke;
      case 'ice':
        return DrugType.ice;
      case 'percs':
        return DrugType.percs;
      case 'pixie dust':
        return DrugType.pixie;
      default:
        return DrugType.weed;
    }
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case 0:
        return 'Meeting the dealer...';
      case 1:
        return 'Looking around...';
      case 2:
        return 'Negotiating the deal...';
      case 3:
        return 'Making the exchange...';
      case 4:
        return widget.isSuccessful
            ? 'Deal successful!'
            : 'Something went wrong...';
      case 5:
        return 'Walking away...';
      default:
        return '';
    }
  }
}

// Police Raid Cut Scene
class _PoliceRaidCutScene extends StatefulWidget {
  final String locationName;
  final int policeCount;
  final bool isPlayerCaught;
  final VoidCallback? onComplete;

  const _PoliceRaidCutScene({
    required this.locationName,
    required this.policeCount,
    required this.isPlayerCaught,
    this.onComplete,
  });

  @override
  _PoliceRaidCutSceneState createState() => _PoliceRaidCutSceneState();
}

class _PoliceRaidCutSceneState extends State<_PoliceRaidCutScene>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _sirenController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _sirenAnimation;
  int _currentPhase = 0;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _sirenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _sirenAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sirenController, curve: Curves.easeInOut),
    );

    _mainController.forward().then((_) {
      widget.onComplete?.call();
      Navigator.of(context).pop();
    });

    _sirenController.repeat(reverse: true);
    _startRaidSequence();
  }

  void _startRaidSequence() {
    // Phase 1: Sirens approach
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _currentPhase = 1);
    });

    // Phase 2: Police arrive
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _currentPhase = 2);
    });

    // Phase 3: Raid begins
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _currentPhase = 3);
    });

    // Phase 4: Chaos
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _currentPhase = 4);
    });

    // Phase 5: Resolution
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _currentPhase = 5);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _sirenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeInAnimation.value,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue, width: 3),
              ),
              child: Column(
                children: [
                  // Title with siren effect
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: AnimatedBuilder(
                      animation: _sirenAnimation,
                      builder: (context, child) {
                        return Text(
                          'POLICE RAID!',
                          style: TextStyle(
                            color: _sirenAnimation.value > 0.5
                                ? Colors.red
                                : Colors.blue,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 10,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Raid scene
                  Expanded(
                    child: Stack(
                      children: [
                        // Background with siren effect
                        AnimatedBuilder(
                          animation: _sirenAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment.center,
                                  colors: [
                                    _sirenAnimation.value > 0.5
                                        ? Colors.red.withValues(alpha: 0.3)
                                        : Colors.blue.withValues(alpha: 0.3),
                                    Colors.black,
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Location name
                        Positioned(
                          top: 30,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              widget.locationName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // Police vehicles
                        if (_currentPhase >= 2) ...[
                          Positioned(
                            left: 50,
                            top: 100,
                            child: ComprehensiveSprites.createVehicleSprite(
                              size: 60,
                              type: VehicleType.police,
                              state: VehicleState.idle,
                            ),
                          ),
                          Positioned(
                            right: 50,
                            top: 100,
                            child: ComprehensiveSprites.createVehicleSprite(
                              size: 60,
                              type: VehicleType.police,
                              state: VehicleState.idle,
                            ),
                          ),
                        ],

                        // Police officers
                        if (_currentPhase >= 3)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 180,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                widget.policeCount.clamp(0, 4),
                                (index) =>
                                    ComprehensiveSprites.createPoliceSprite(
                                      size: 50,
                                      state: PoliceState.chasing,
                                    ),
                              ),
                            ),
                          ),

                        // Player (if caught)
                        if (widget.isPlayerCaught && _currentPhase >= 4)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 250,
                            child: Center(
                              child: Column(
                                children: [
                                  ComprehensiveSprites.createPoliceSprite(
                                    size: 60,
                                    state: PoliceState.arresting,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'CAUGHT!',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Phase text
                        Positioned(
                          bottom: 50,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              _getPhaseText(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Skip button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onComplete?.call();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case 0:
        return 'Sirens in the distance...';
      case 1:
        return 'Getting closer...';
      case 2:
        return 'Police vehicles arriving!';
      case 3:
        return 'Officers deploying!';
      case 4:
        return widget.isPlayerCaught
            ? 'You\'ve been caught!'
            : 'Raid in progress!';
      case 5:
        return 'Raid complete...';
      default:
        return '';
    }
  }
}

// Territory Takeover Cut Scene
class _TerritoryTakeoverCutScene extends StatefulWidget {
  final String territoryName;
  final String oldGangName;
  final String newGangName;
  final VoidCallback? onComplete;

  const _TerritoryTakeoverCutScene({
    required this.territoryName,
    required this.oldGangName,
    required this.newGangName,
    this.onComplete,
  });

  @override
  _TerritoryTakeoverCutSceneState createState() =>
      _TerritoryTakeoverCutSceneState();
}

class _TerritoryTakeoverCutSceneState extends State<_TerritoryTakeoverCutScene>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _flagAnimation;
  int _currentPhase = 0;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _flagAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    _mainController.forward().then((_) {
      widget.onComplete?.call();
      Navigator.of(context).pop();
    });

    _startTakeoverSequence();
  }

  void _startTakeoverSequence() {
    // Phase 1: Arrival
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _currentPhase = 1);
    });

    // Phase 2: Confrontation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _currentPhase = 2);
    });

    // Phase 3: Takeover
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _currentPhase = 3);
    });

    // Phase 4: New flag
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _currentPhase = 4);
    });

    // Phase 5: Victory
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _currentPhase = 5);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeInAnimation.value,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.yellow, width: 3),
              ),
              child: Column(
                children: [
                  // Title
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'TERRITORY TAKEOVER',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Takeover scene
                  Expanded(
                    child: Stack(
                      children: [
                        // Background
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.grey.shade900, Colors.black],
                            ),
                          ),
                        ),

                        // Territory name
                        Positioned(
                          top: 30,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              widget.territoryName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // Building
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 80,
                          child: Center(
                            child: ComprehensiveSprites.createBuildingSprite(
                              size: 100,
                              type: BuildingType.store,
                              state: _currentPhase >= 3
                                  ? BuildingState.damaged
                                  : BuildingState.idle,
                            ),
                          ),
                        ),

                        // Old gang flag (being lowered)
                        if (_currentPhase < 4)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 200,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _flagAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      _flagAnimation.value * 100,
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.flag,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        Text(
                                          widget.oldGangName,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                        // New gang flag (being raised)
                        if (_currentPhase >= 4)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 200,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _flagAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      (1 - _flagAnimation.value) * 100,
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.flag,
                                          color: Colors.green,
                                          size: 40,
                                        ),
                                        Text(
                                          widget.newGangName,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                        // Gang members
                        if (_currentPhase >= 2)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 280,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ComprehensiveSprites.createPoliceSprite(
                                  size: 40,
                                  state: PoliceState.idle,
                                ),
                                ComprehensiveSprites.createPoliceSprite(
                                  size: 40,
                                  state: PoliceState.idle,
                                ),
                                ComprehensiveSprites.createPoliceSprite(
                                  size: 40,
                                  state: PoliceState.idle,
                                ),
                              ],
                            ),
                          ),

                        // Phase text
                        Positioned(
                          bottom: 50,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              _getPhaseText(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Skip button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onComplete?.call();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case 0:
        return 'Approaching territory...';
      case 1:
        return 'Entering the area...';
      case 2:
        return 'Confronting the enemy gang!';
      case 3:
        return 'Taking control!';
      case 4:
        return 'Raising new flag!';
      case 5:
        return 'Territory secured!';
      default:
        return '';
    }
  }
}

// Boss Fight Cut Scene
class _BossFightCutScene extends StatefulWidget {
  final String bossName;
  final String bossGangName;
  final String weaponType;
  final VoidCallback? onComplete;

  const _BossFightCutScene({
    required this.bossName,
    required this.bossGangName,
    required this.weaponType,
    this.onComplete,
  });

  @override
  _BossFightCutSceneState createState() => _BossFightCutSceneState();
}

class _BossFightCutSceneState extends State<_BossFightCutScene>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _shakeController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _zoomAnimation;
  late Animation<double> _shakeAnimation;
  int _currentPhase = 0;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _zoomAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _mainController.forward().then((_) {
      widget.onComplete?.call();
      Navigator.of(context).pop();
    });

    _startBossSequence();
  }

  void _startBossSequence() {
    // Phase 1: Introduction
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _currentPhase = 1);
    });

    // Phase 2: Boss appears
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _currentPhase = 2);
      _shakeController.forward().then((_) => _shakeController.reverse());
    });

    // Phase 3: Taunt
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _currentPhase = 3);
    });

    // Phase 4: Fight begins
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) setState(() => _currentPhase = 4);
    });

    // Phase 5: Ready
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) setState(() => _currentPhase = 5);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Transform.scale(
          scale: _zoomAnimation.value,
          child: Opacity(
            opacity: _fadeInAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red, width: 3),
                ),
                child: Column(
                  children: [
                    // Title
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'BOSS FIGHT',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Boss fight scene
                    Expanded(
                      child: Stack(
                        children: [
                          // Background
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.red.shade900, Colors.black],
                              ),
                            ),
                          ),

                          // Boss name and gang
                          Positioned(
                            top: 30,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    widget.bossName,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.bossGangName,
                                    style: TextStyle(
                                      color: Colors.red.shade300,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Boss character
                          if (_currentPhase >= 2)
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 100,
                              child: Center(
                                child: AnimatedBuilder(
                                  animation: _shakeAnimation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                        _shakeAnimation.value * 10,
                                        0,
                                      ),
                                      child:
                                          ComprehensiveSprites.createCivilianSprite(
                                            size: 100,
                                            type: CivilianType.man,
                                            state: CivilianState.scared,
                                          ),
                                    );
                                  },
                                ),
                              ),
                            ),

                          // Boss weapon
                          if (_currentPhase >= 3)
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 220,
                              child: Center(
                                child: ComprehensiveSprites.createWeaponSprite(
                                  size: 60,
                                  type: _getWeaponType(),
                                  state: WeaponState.idle,
                                ),
                              ),
                            ),

                          // Player character
                          if (_currentPhase >= 4)
                            Positioned(
                              left: 50,
                              bottom: 100,
                              child: ComprehensiveSprites.createPoliceSprite(
                                size: 60,
                                state: PoliceState.idle,
                              ),
                            ),

                          // VS text
                          if (_currentPhase >= 4)
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 300,
                              child: Center(
                                child: Text(
                                  'VS',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          // Phase text
                          Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                _getPhaseText(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Skip button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onComplete?.call();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  WeaponType _getWeaponType() {
    switch (widget.weaponType.toLowerCase()) {
      case 'pistol':
        return WeaponType.pistol;
      case 'uzi':
        return WeaponType.uzi;
      case 'ar15':
        return WeaponType.ar15;
      case 'shotgun':
        return WeaponType.shotgun;
      case 'knife':
        return WeaponType.knife;
      case 'bat':
        return WeaponType.bat;
      case 'grenade':
        return WeaponType.grenade;
      default:
        return WeaponType.pistol;
    }
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case 0:
        return 'A powerful enemy approaches...';
      case 1:
        return 'The boss appears!';
      case 2:
        return '"${widget.bossName}" has arrived!';
      case 3:
        return '"You dare challenge me?"';
      case 4:
        return 'Prepare for battle!';
      case 5:
        return 'FIGHT!';
      default:
        return '';
    }
  }
}

// Player Death Cut Scene
class _PlayerDeathCutScene extends StatefulWidget {
  final String killerName;
  final String weaponType;
  final String locationName;
  final VoidCallback? onComplete;

  const _PlayerDeathCutScene({
    required this.killerName,
    required this.weaponType,
    required this.locationName,
    this.onComplete,
  });

  @override
  _PlayerDeathCutSceneState createState() => _PlayerDeathCutSceneState();
}

class _PlayerDeathCutSceneState extends State<_PlayerDeathCutScene>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _fadeController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _zoomAnimation;
  int _currentPhase = 0;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );

    _mainController.forward().then((_) {
      _fadeController.forward().then((_) {
        widget.onComplete?.call();
        Navigator.of(context).pop();
      });
    });

    _startDeathSequence();
  }

  void _startDeathSequence() {
    // Phase 1: Hit
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _currentPhase = 1);
    });

    // Phase 2: Falling
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _currentPhase = 2);
    });

    // Phase 3: On ground
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _currentPhase = 3);
    });

    // Phase 4: Vision fading
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _currentPhase = 4);
    });

    // Phase 5: Death
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _currentPhase = 5);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Transform.scale(
          scale: _zoomAnimation.value,
          child: Opacity(
            opacity: _fadeInAnimation.value * _fadeOutAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red, width: 3),
                ),
                child: Column(
                  children: [
                    // Title
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'YOU DIED',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Death scene
                    Expanded(
                      child: Stack(
                        children: [
                          // Background
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.red.shade900, Colors.black],
                              ),
                            ),
                          ),

                          // Location
                          Positioned(
                            top: 30,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                widget.locationName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // Killer
                          if (_currentPhase >= 1)
                            Positioned(
                              right: 80,
                              top: 100,
                              child: Column(
                                children: [
                                  Text(
                                    widget.killerName,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ComprehensiveSprites.createCivilianSprite(
                                    size: 60,
                                    type: CivilianType.man,
                                    state: CivilianState.idle,
                                  ),
                                ],
                              ),
                            ),

                          // Weapon used
                          if (_currentPhase >= 1)
                            Positioned(
                              right: 150,
                              top: 180,
                              child: ComprehensiveSprites.createWeaponSprite(
                                size: 40,
                                type: _getWeaponType(),
                                state: WeaponState.idle,
                              ),
                            ),

                          // Player dying
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 150,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _mainController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _currentPhase >= 2
                                        ? _mainController.value * 3.14159 / 2
                                        : 0,
                                    child: Opacity(
                                      opacity: _currentPhase >= 4
                                          ? 1 - _mainController.value
                                          : 1,
                                      child:
                                          ComprehensiveSprites.createPoliceSprite(
                                            size: 80,
                                            state: _currentPhase >= 3
                                                ? PoliceState.dead
                                                : PoliceState.hurt,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Blood effects
                          if (_currentPhase >= 2)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _BloodEffectPainter(
                                  intensity: _mainController.value,
                                ),
                              ),
                            ),

                          // Phase text
                          Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                _getPhaseText(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Skip button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onComplete?.call();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  WeaponType _getWeaponType() {
    switch (widget.weaponType.toLowerCase()) {
      case 'pistol':
        return WeaponType.pistol;
      case 'uzi':
        return WeaponType.uzi;
      case 'ar15':
        return WeaponType.ar15;
      case 'shotgun':
        return WeaponType.shotgun;
      case 'knife':
        return WeaponType.knife;
      case 'bat':
        return WeaponType.bat;
      case 'grenade':
        return WeaponType.grenade;
      default:
        return WeaponType.pistol;
    }
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case 0:
        return 'You were attacked...';
      case 1:
        return 'Hit by ${widget.weaponType}!';
      case 2:
        return 'Falling to the ground...';
      case 3:
        return 'Lying on the ground...';
      case 4:
        return 'Vision fading...';
      case 5:
        return 'You have died...';
      default:
        return '';
    }
  }
}

// Victory Cut Scene
class _VictoryCutScene extends StatefulWidget {
  final String enemyGangName;
  final int moneyEarned;
  final int territoryGained;
  final VoidCallback? onComplete;

  const _VictoryCutScene({
    required this.enemyGangName,
    required this.moneyEarned,
    required this.territoryGained,
    this.onComplete,
  });

  @override
  _VictoryCutSceneState createState() => _VictoryCutSceneState();
}

class _VictoryCutSceneState extends State<_VictoryCutScene>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _confettiController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  int _currentPhase = 0;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.5, curve: Curves.elasticOut),
      ),
    );

    _mainController.forward().then((_) {
      widget.onComplete?.call();
      Navigator.of(context).pop();
    });

    _confettiController.repeat();
    _startVictorySequence();
  }

  void _startVictorySequence() {
    // Phase 1: Victory announcement
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _currentPhase = 1);
    });

    // Phase 2: Enemy defeated
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _currentPhase = 2);
    });

    // Phase 3: Rewards
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _currentPhase = 3);
    });

    // Phase 4: Celebration
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) setState(() => _currentPhase = 4);
    });

    // Phase 5: Complete
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) setState(() => _currentPhase = 5);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeInAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.yellow, width: 3),
                ),
                child: Column(
                  children: [
                    // Title
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'VICTORY!',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Victory scene
                    Expanded(
                      child: Stack(
                        children: [
                          // Background
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.yellow.shade900, Colors.black],
                              ),
                            ),
                          ),

                          // Confetti
                          ..._buildConfetti(),

                          // Victory text
                          Positioned(
                            top: 30,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                'ENEMY DEFEATED',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // Enemy gang name
                          if (_currentPhase >= 2)
                            Positioned(
                              top: 80,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  widget.enemyGangName,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ),

                          // Player celebrating
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 150,
                            child: Center(
                              child: ComprehensiveSprites.createPoliceSprite(
                                size: 80,
                                state: PoliceState.idle,
                              ),
                            ),
                          ),

                          // Rewards
                          if (_currentPhase >= 3) ...[
                            // Money earned
                            Positioned(
                              left: 50,
                              top: 250,
                              child: Column(
                                children: [
                                  ComprehensiveSprites.createMoneySprite(
                                    size: 50,
                                    denomination: MoneyDenomination.hundred,
                                    state: MoneyState.floating,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '+\$${widget.moneyEarned}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Territory gained
                            Positioned(
                              right: 50,
                              top: 250,
                              child: Column(
                                children: [
                                  ComprehensiveSprites.createBuildingSprite(
                                    size: 50,
                                    type: BuildingType.store,
                                    state: BuildingState.idle,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '+${widget.territoryGained} Territory',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Celebration text
                          if (_currentPhase >= 4)
                            Positioned(
                              bottom: 100,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  'CELEBRATION!',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          // Phase text
                          Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                _getPhaseText(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Skip button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onComplete?.call();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildConfetti() {
    final confetti = <Widget>[];
    final random = Random();
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
    ];

    for (int i = 0; i < 30; i++) {
      confetti.add(
        Positioned(
          left: random.nextDouble() * 400,
          top: random.nextDouble() * 400,
          child: AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _confettiController.value * 200),
                child: Transform.rotate(
                  angle: _confettiController.value * 4 * 3.14159,
                  child: Container(
                    width: 8,
                    height: 8,
                    color: colors[random.nextInt(colors.length)],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return confetti;
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case 0:
        return 'The battle is over...';
      case 1:
        return 'VICTORY!';
      case 2:
        return '${widget.enemyGangName} has been defeated!';
      case 3:
        return 'Collecting rewards...';
      case 4:
        return 'Celebrating success!';
      case 5:
        return 'Well done!';
      default:
        return '';
    }
  }
}

// Helper classes
class _FightAction {
  final String type;
  final Offset position;
  final Color color;
  final double size;

  _FightAction({
    required this.type,
    required this.position,
    required this.color,
    required this.size,
  });
}

class _DrugEffectPainter extends CustomPainter {
  final Color color;
  final double intensity;
  final int phase;

  _DrugEffectPainter({
    required this.color,
    required this.intensity,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: intensity * 0.3)
      ..style = PaintingStyle.fill;

    // Draw swirling effects
    for (int i = 0; i < 5; i++) {
      final offset = Offset(
        size.width / 2 + cos(i * 1.2) * 100,
        size.height / 2 + sin(i * 1.2) * 100,
      );
      canvas.drawCircle(offset, 20 + i * 10, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrugEffectPainter oldDelegate) => true;
}

class _BloodEffectPainter extends CustomPainter {
  final double intensity;

  _BloodEffectPainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withValues(alpha: intensity * 0.5)
      ..style = PaintingStyle.fill;

    // Draw blood splatters
    final random = Random(42);
    for (int i = 0; i < 10; i++) {
      final offset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      canvas.drawCircle(offset, 5 + random.nextDouble() * 10, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BloodEffectPainter oldDelegate) => true;
}
