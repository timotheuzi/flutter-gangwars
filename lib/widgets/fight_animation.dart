import 'package:flutter/material.dart';

class FightAnimation extends StatefulWidget {
  final String playerName;
  final String gangName;
  final String enemyType;
  final int playerHealth;
  final int enemyHealth;
  final double playerMaxHealth;
  final double enemyMaxHealth;
  final int playerMembers;
  final int enemyCount;
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
    required this.playerMembers,
    required this.enemyCount,
    this.currentWeapon,
    this.showBloodEffects = false,
  });

  @override
  FightAnimationState createState() => FightAnimationState();
}

class BloodSplatterPainter extends CustomPainter {
  final double animationValue;

  BloodSplatterPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.3 + animationValue * 0.4)
      ..style = PaintingStyle.fill;

    // Draw some random blood splatters
    final random = Offset(size.width * 0.2, size.height * 0.3);
    canvas.drawCircle(random, 15 + animationValue * 10, paint);

    final random2 = Offset(size.width * 0.7, size.height * 0.6);
    canvas.drawCircle(random2, 8 + animationValue * 6, paint);

    final random3 = Offset(size.width * 0.4, size.height * 0.8);
    canvas.drawCircle(random3, 12 + animationValue * 8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
  late Animation<double> _bloodDripAnimation;
  late Animation<double> _woundPulseAnimation;
  late Animation<double> _bloodParticleAnimation;
  late Animation<double> _goreEffectAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Player animation - moves left and right
    _playerAnimation = Tween<double>(begin: -40.0, end: 40.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    // Enemy animation - moves right and left (opposite of player)
    _enemyAnimation = Tween<double>(begin: 40.0, end: -40.0).animate(
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

    // Enhanced blood splash animation
    _bloodSplashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Blood drip animation
    _bloodDripAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.bounceIn),
      ),
    );

    // Wound pulse animation
    _woundPulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Blood particle animation
    _bloodParticleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // Gore effect animation
    _goreEffectAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Weapon swing animation
    _weaponSwingAnimation = Tween<double>(begin: -0.5, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
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
    if (weapon == null) return '👊💥'; // Bloody fists

    return switch (weapon.toLowerCase()) {
      'pistol' => '🔫💥',
      'uzi' => '🔫🔫💥',
      'ar15' => '🪖⚡',
      'grenade' => '💣💥',
      'knife' => '🔪🩸',
      'sword' => '🗡️⚔️',
      'barbed_wire_bat' => '⚾💢🩸',
      'brass_knuckles' => '🥊💥',
      'axe' => '🪓⚡',
      'fists' => '👊💥',
      'ghost_gun' => '👻🔫',
      'vampire_bat' => '🦇⚾💥',
      'missile_launcher' => '🚀💥',
      'machine_gun' => '🔫🔫🔫💥',
      'rocket_launcher' => '🚀🚀💥',
      'submachine_gun' => '🔫🔫⚡',
      'flamethrower' => '🔥💥',
      'golden_gun' => '💰🔫✨',
      _ => '👊💥',
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
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.95),
            Colors.red.shade900.withOpacity(0.8),
            Colors.black.withOpacity(0.9),
          ],
        ),
        border: Border.all(
          color: Colors.red.shade600,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          // Muddy battlefield background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.brown.shade900.withOpacity(0.6),
                    Colors.black.withOpacity(0.8),
                    Colors.red.shade900.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),

          // Player gang members (left side)
          ..._buildGangMembers(true),

          // Enemy gang members (right side)
          ..._buildGangMembers(false),

          // Blood splatter effects
          if (widget.showBloodEffects)
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: CustomPaint(
                  painter: BloodSplatterPainter(_bloodSplashAnimation.value),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildGangMembers(bool isPlayerSide) {
    final members = isPlayerSide ? widget.playerMembers : widget.enemyCount;
    final health = isPlayerSide ? widget.playerHealth : widget.enemyHealth;
    final maxHealth = isPlayerSide ? widget.playerMaxHealth : widget.enemyMaxHealth;
    final healthPerMember = maxHealth / members;
    final startX = isPlayerSide ? 20.0 : MediaQuery.of(context).size.width - 100;
    final spacing = 40.0;

    List<Widget> memberWidgets = [];

    for (int i = 0; i < members; i++) {
      final memberHealth = (health - (i * healthPerMember)).clamp(0, healthPerMember);
      final isAlive = memberHealth > 0;
      final xPos = startX + (i * spacing);

      memberWidgets.add(
        Positioned(
          left: xPos,
          bottom: isAlive ? 20 : 5, // Dead members fall to bottom
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  isPlayerSide ? _playerAnimation.value * 0.5 : _enemyAnimation.value * 0.5,
                  isAlive ? 0 : 10, // Dead members sink into mud
                ),
                child: _buildGangMemberSprite(isPlayerSide, isAlive, i),
              );
            },
          ),
        ),
      );
    }

    return memberWidgets;
  }

  Widget _buildGangMemberSprite(bool isPlayerSide, bool isAlive, int index) {
    if (!isAlive) {
      // Dead member - bloody heap
      return const Text(
        '🩸💀',
        style: TextStyle(fontSize: 20),
      );
    }

    // Alive member - simple emoji character
    final emoji = isPlayerSide ? '👨🏽‍🦲' : '👨🏽‍🦱';

    return Text(
      emoji,
      style: const TextStyle(fontSize: 24),
    );
  }
}
