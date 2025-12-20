import 'package:flutter/material.dart';
import 'dart:math';
import 'pixel_art_member.dart';

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

class BloodSplatter {
  Offset position;
  double size;
  double opacity;
  double rotation;

  BloodSplatter(this.position, this.size, this.opacity, this.rotation);
}

class BloodSplatterPainter extends CustomPainter {
  final List<BloodSplatter> splatters;

  BloodSplatterPainter(this.splatters);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var splatter in splatters) {
      paint.color = Colors.red.shade900.withOpacity(splatter.opacity);
      canvas.save();
      canvas.translate(splatter.position.dx, splatter.position.dy);
      canvas.rotate(splatter.rotation);
      
      final path = Path();
      path.moveTo(0, -splatter.size);
      path.quadraticBezierTo(splatter.size * 0.5, -splatter.size * 0.8, splatter.size, 0);
      path.quadraticBezierTo(splatter.size * 0.8, splatter.size * 0.5, 0, splatter.size);
      path.quadraticBezierTo(-splatter.size * 0.8, splatter.size * 0.5, -splatter.size, 0);
      path.quadraticBezierTo(-splatter.size * 0.5, -splatter.size * 0.8, 0, -splatter.size);
      
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant BloodSplatterPainter oldDelegate) => true;
}

class FightAnimationState extends State<FightAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<BloodSplatter> _splatters = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addSplatter(Offset position) {
    setState(() {
      _splatters.add(BloodSplatter(
        position,
        10 + _random.nextDouble() * 15,
        0.6 + _random.nextDouble() * 0.4,
        _random.nextDouble() * 2 * pi,
      ));
    });
  }

  @override
  void didUpdateWidget(FightAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playerHealth < oldWidget.playerHealth) {
      _addSplatter(Offset(40 + _random.nextDouble() * 60, 100 + _random.nextDouble() * 50));
    }
    if (widget.enemyHealth < oldWidget.enemyHealth) {
      _addSplatter(Offset(MediaQuery.of(context).size.width - 140 + _random.nextDouble() * 60, 100 + _random.nextDouble() * 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.brown.shade900,
        border: Border.all(color: Colors.brown.shade700, width: 4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Container(color: Colors.brown.shade900),
            CustomPaint(
              painter: BloodSplatterPainter(_splatters),
              size: Size.infinite,
            ),
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(child: _buildSide(true)),
                  const SizedBox(width: 40),
                  Expanded(child: _buildSide(false)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSide(bool isPlayer) {
    final totalCount = isPlayer ? widget.playerMembers : widget.enemyCount;
    final currentHealth = isPlayer ? widget.playerHealth : widget.enemyHealth;
    final maxHealth = isPlayer ? widget.playerMaxHealth : widget.enemyMaxHealth;
    
    // We treat each member as having an equal share of the total health.
    // If a side has 100 max health and 4 members, each member has 25 health.
    // If current health is 60, then 2 members are fully alive, 1 is wounded (still alive sprite), and 1 is dead.
    final healthPerMember = maxHealth / totalCount;
    
    // Any member whose index corresponds to health > 0 is alive.
    // Index 0 is the "last" to die, index (totalCount-1) is the "first" to die.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: isPlayer ? WrapAlignment.start : WrapAlignment.end,
        children: List.generate(totalCount, (index) {
          // Check if this specific member is alive
          // We count from the end of the list for who dies first
          final memberThreshold = (totalCount - 1 - index) * healthPerMember;
          final isAlive = currentHealth > memberThreshold;
          
          final isVictorious = (isPlayer && widget.enemyHealth <= 0) || (!isPlayer && widget.playerHealth <= 0);
          
          return _buildMemberWithAnimation(isPlayer, isAlive, isAlive && isVictorious);
        }),
      ),
    );
  }

  Widget _buildMemberWithAnimation(bool isPlayer, bool isAlive, bool isCheering) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double yOffset = 0;
        if (isAlive) {
          yOffset = sin(_controller.value * 2 * pi) * 3;
        } else {
          yOffset = 10;
        }

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: PixelArtMember(
            isPlayer: isPlayer,
            isAlive: isAlive,
            isCheering: isCheering,
            size: 30,
          ),
        );
      },
    );
  }
}
