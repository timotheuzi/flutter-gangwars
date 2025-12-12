import 'package:flutter/material.dart';

class FightAnimation extends StatefulWidget {
  final String playerName;
  final String gangName;
  final String enemyType;
  final int playerHealth;
  final int enemyHealth;
  final double playerMaxHealth;
  final double enemyMaxHealth;

  const FightAnimation({
    super.key,
    required this.playerName,
    required this.gangName,
    required this.enemyType,
    required this.playerHealth,
    required this.enemyHealth,
    required this.playerMaxHealth,
    required this.enemyMaxHealth,
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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Player animation - moves left and right
    _playerAnimation = Tween<double>(begin: -50.0, end: 50.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    // Enemy animation - moves right and left (opposite of player)
    _enemyAnimation = Tween<double>(begin: 50.0, end: -50.0).animate(
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

  @override
  void didUpdateWidget(FightAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerHealth != widget.playerHealth ||
        oldWidget.enemyHealth != widget.enemyHealth) {
      // Update color animations when health changes
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
            Colors.black.withOpacity(0.8),
            Colors.red.shade900.withOpacity(0.6),
          ],
        ),
        border: Border.all(
          color: Colors.red.shade700,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Battlefield background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.red.shade900.withOpacity(0.2),
                    Colors.black.withOpacity(0.3),
                    Colors.red.shade800.withOpacity(0.2),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Player character (left side)
          Positioned(
            left: 20,
            bottom: 20,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_playerAnimation.value, 0),
                  child: _buildCharacter(
                    widget.playerName,
                    widget.gangName,
                    '👨‍🦰', // Player emoji
                    _playerColorAnimation.value ?? Colors.blue.shade800,
                    widget.playerHealth,
                    widget.playerMaxHealth,
                    true, // isPlayer
                  ),
                );
              },
            ),
          ),

          // Enemy character (right side)
          Positioned(
            right: 20,
            bottom: 20,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_enemyAnimation.value, 0),
                  child: _buildCharacter(
                    widget.enemyType,
                    'Enemy Gang',
                    _getEnemyEmoji(widget.enemyType),
                    _enemyColorAnimation.value ?? Colors.red.shade800,
                    widget.enemyHealth,
                    widget.enemyMaxHealth,
                    false, // isPlayer
                  ),
                );
              },
            ),
          ),

          // Fight indicator
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + 0.1 * _controller.value,
                  child: Text(
                    '💥 FIGHT TO THE DEATH 💥',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.red.shade800,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
      'rival gang members' => '👨‍🦳',
      _ => '👨‍🦲',
    };
  }

  Widget _buildCharacter(
    String name,
    String gang,
    String emoji,
    Color color,
    int health,
    double maxHealth,
    bool isPlayer,
  ) {
    final healthPercentage = health / maxHealth;
    final borderColor = isPlayer ? Colors.blue : Colors.red;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Character emoji with gang tag
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 4),
              Text(
                gang,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Character name
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: Colors.black,
                offset: const Offset(1.0, 1.0),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),

        // Health bar
        Container(
          width: 100,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Container(
                width: 100 * healthPercentage,
                height: 10,
                decoration: BoxDecoration(
                  color: _getHealthColor(health, maxHealth),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Center(
                child: Text(
                  '${health.toInt()}/${maxHealth.toInt()}',
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
