import 'package:flutter/material.dart';

class FightAnimation extends StatefulWidget {
  final String playerName;
  final String gangName;
  final String enemyType;
  final int playerHealth;
  final int enemyHealth;
  final double playerMaxHealth;
  final double enemyMaxHealth;
  final String? currentWeapon;
  final bool showBloodEffects;

  const FightAnimation({
    super.key,
    required this.playerName,
    required this.gangName,
    required this.enemyType,
    required this.playerHealth,
    required this.enemyHealth,
    required this.playerMaxHealth,
    required this.enemyMaxHealth,
    this.currentWeapon,
    this.showBloodEffects = false,
  });

  @override
  FightAnimationState createState() => FightAnimationState();
}

class FightAnimationState extends State<FightAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _playerAnimation;
  late Animation<double> _enemyAnimation;
  late Animation<Color?> _playerColorAnimation;
  late Animation<Color?> _enemyColorAnimation;
  late Animation<double> _bloodSplashAnimation;
  late Animation<double> _weaponSwingAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Player animation - moves left and right
    _playerAnimation = Tween<double>(begin: -30.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    // Enemy animation - moves right and left (opposite of player)
    _enemyAnimation = Tween<double>(begin: 30.0, end: -30.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Player color animation - pulses based on health
    _playerColorAnimation = ColorTween(
      begin: Colors.blue.shade800,
      end: _getHealthColor(widget.playerHealth, widget.playerMaxHealth),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Enemy color animation - pulses based on health
    _enemyColorAnimation = ColorTween(
      begin: Colors.red.shade800,
      end: _getHealthColor(widget.enemyHealth, widget.enemyMaxHealth),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Blood splash animation
    _bloodSplashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // Weapon swing animation
    _weaponSwingAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
  }

  Color _getHealthColor(int health, double maxHealth) {
    final healthPercentage = health / maxHealth;
    if (healthPercentage > 0.6) {
      return Colors.green;
    } else if (healthPercentage > 0.3) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getWeaponIcon(String? weapon) {
    if (weapon == null) return '✊'; // Fists

    return switch (weapon.toLowerCase()) {
      'pistol' => '🔫',
      'uzi' => '🔫🔫',
      'ar15' => '🪖',
      'grenade' => '💣',
      'knife' => '🔪',
      'sword' => '🗡️',
      'barbed_wire_bat' => '⚾💢',
      'brass_knuckles' => '🥊',
      'axe' => '🪓',
      'fists' => '✊',
      'ghost_gun' => '👻🔫',
      'vampire_bat' => '🦇⚾',
      'missile_launcher' => '🚀',
      'machine_gun' => '🔫🔫🔫',
      'rocket_launcher' => '🚀🚀',
      'submachine_gun' => '🔫🔫',
      'flamethrower' => '🔥',
      'golden_gun' => '💰🔫',
      _ => '✊',
    };
  }

  @override
  void didUpdateWidget(FightAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerHealth != widget.playerHealth ||
        oldWidget.enemyHealth != widget.enemyHealth ||
        oldWidget.currentWeapon != widget.currentWeapon ||
        oldWidget.showBloodEffects != widget.showBloodEffects) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerHealthPercentage = widget.playerHealth / widget.playerMaxHealth;
    final enemyHealthPercentage = widget.enemyHealth / widget.enemyMaxHealth;
    final isPlayerLosing = playerHealthPercentage < enemyHealthPercentage;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.red.shade900.withOpacity(0.7),
          ],
        ),
        border: Border.all(
          color: Colors.red.shade700,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade900.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Battlefield background with gritty texture
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.red.shade900.withOpacity(0.3),
                    Colors.black.withOpacity(0.4),
                    Colors.red.shade800.withOpacity(0.3),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Blood splatter effects for losing fighter
          if (widget.showBloodEffects)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _bloodSplashAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _bloodSplashAnimation.value * 0.3,
                    child: Container(
                      color: Colors.red.withOpacity(0.1),
                      child: Center(
                        child: Text(
                          '🩸💀🩸',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Player character (left side) - Gangster with weapon
          Positioned(
            left: 15,
            bottom: 30,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final weaponIcon = _getWeaponIcon(widget.currentWeapon);
                final weaponOffset = _weaponSwingAnimation.value * 20;

                return Transform.translate(
                  offset: Offset(_playerAnimation.value, 0),
                  child: Stack(
                    children: [
                      // Blood effects on player if losing
                      if (isPlayerLosing && widget.showBloodEffects)
                        Positioned(
                          top: -10,
                          left: -10,
                          child: Transform.rotate(
                            angle: _controller.value * 0.5,
                            child: Text(
                              '💉🩸',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red.withOpacity(0.7),
                                shadows: [
                                  Shadow(
                                    blurRadius: 5,
                                    color: Colors.red,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Player character with weapon
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Weapon in hand (positioned above character)
                          Transform.translate(
                            offset: Offset(weaponOffset, -10),
                            child: Transform.rotate(
                              angle: _weaponSwingAnimation.value * 0.3,
                              child: Text(
                                weaponIcon,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5,
                                      color: Colors.black,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Character with gangster style
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (_playerColorAnimation.value ?? Colors.blue.shade800).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.blue.shade400,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade900.withOpacity(0.6),
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Gangster character
                                Stack(
                                  children: [
                                    Text(
                                      '👨🏽‍🦲', // Bald gangster emoji
                                      style: TextStyle(fontSize: 45),
                                    ),
                                    Positioned(
                                      right: 5,
                                      bottom: 5,
                                      child: Text(
                                        '👕', // Bandana
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                // Gang name with street style
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white, width: 1),
                                  ),
                                  child: Text(
                                    widget.gangName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Player name with style
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade400, width: 1),
                            ),
                            child: Text(
                              widget.playerName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan.shade100,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3,
                                    color: Colors.black,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Health bar with weapon info
                          Stack(
                            children: [
                              Container(
                                width: 110,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                              ),
                              Container(
                                width: 110 * playerHealthPercentage,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getHealthColor(widget.playerHealth, widget.playerMaxHealth),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${widget.playerHealth.toInt()}/${widget.playerMaxHealth.toInt()}',
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        weaponIcon,
                                        style: const TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Enemy character (right side) - Gangster with weapon
          Positioned(
            right: 15,
            bottom: 30,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final enemyWeaponIcon = _getEnemyWeaponIcon(widget.enemyType);
                final weaponOffset = -_weaponSwingAnimation.value * 20;

                return Transform.translate(
                  offset: Offset(_enemyAnimation.value, 0),
                  child: Stack(
                    children: [
                      // Blood effects on enemy if losing
                      if (!isPlayerLosing && widget.showBloodEffects)
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Transform.rotate(
                            angle: -_controller.value * 0.5,
                            child: Text(
                              '💉🩸',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red.withOpacity(0.7),
                                shadows: [
                                  Shadow(
                                    blurRadius: 5,
                                    color: Colors.red,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Enemy character with weapon
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Weapon in hand (positioned above character)
                          Transform.translate(
                            offset: Offset(weaponOffset, -10),
                            child: Transform.rotate(
                              angle: -_weaponSwingAnimation.value * 0.3,
                              child: Text(
                                enemyWeaponIcon,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5,
                                      color: Colors.black,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Enemy character with gangster style
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (_enemyColorAnimation.value ?? Colors.red.shade800).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.red.shade400,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.shade900.withOpacity(0.6),
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Enemy gangster character
                                Text(
                                  _getEnemyEmoji(widget.enemyType),
                                  style: TextStyle(fontSize: 45),
                                ),
                                const SizedBox(height: 6),
                                // Enemy gang tag
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white, width: 1),
                                  ),
                                  child: Text(
                                    'Enemy Gang',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Enemy name/type
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade400, width: 1),
                            ),
                            child: Text(
                              widget.enemyType,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade200,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3,
                                    color: Colors.black,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Enemy health bar
                          Container(
                            width: 110,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: 110 * enemyHealthPercentage,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getHealthColor(widget.enemyHealth, widget.enemyMaxHealth),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${widget.enemyHealth.toInt()}/${widget.enemyMaxHealth.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Fight indicator with animated effects
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + 0.15 * _controller.value,
                  child: Opacity(
                    opacity: 0.8 + 0.2 * _controller.value,
                    child: Text(
                      '🔪💥 GANG WAR 💥🔪',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 12.0,
                            color: Colors.red.shade800,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              },
            ),
          ),

          // Additional fight effects
          if (widget.showBloodEffects)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '🩸💀 BLOODBATH 💀🩸',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red.withOpacity(0.8),
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getEnemyEmoji(String enemyType) {
    return switch (enemyType.toLowerCase()) {
      'police officers' || 'police' => '👮‍♂️',
      'squidie hit squad' || 'squidie' => '👹',
      'loan shark enforcer' => '🕵️‍♂️',
      'rival gang members' => '👨🏽‍🦳',
      _ => '👨🏽‍🦲',
    };
  }

  String _getEnemyWeaponIcon(String enemyType) {
    return switch (enemyType.toLowerCase()) {
      'police officers' || 'police' => '🔫',
      'squidie hit squad' || 'squidie' => '🗡️',
      'loan shark enforcer' => '⚾',
      'rival gang members' => '🪓',
      _ => '🔫',
    };
  }
}
