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
      // Player side took damage
      _addSplatter(Offset(40 + _random.nextDouble() * 60, 100 + _random.nextDouble() * 50));
    }
    if (widget.enemyHealth < oldWidget.enemyHealth) {
      // Enemy side took damage
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
            // Mud ground
            Container(color: Colors.brown.shade900),
            
            // Blood splatters
            CustomPaint(
              painter: BloodSplatterPainter(_splatters),
              size: Size.infinite,
            ),

            // Battlefield
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
    final count = isPlayer ? widget.playerMembers : widget.enemyCount;
    final maxHealth = isPlayer ? widget.playerMaxHealth : widget.enemyMaxHealth;
    final currentHealth = isPlayer ? widget.playerHealth : widget.enemyHealth;
    
    final healthPerMember = maxHealth / count;
    final aliveCount = (currentHealth / healthPerMember).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: isPlayer ? WrapAlignment.start : WrapAlignment.end,
        children: List.generate(count, (index) {
          final isAlive = index < aliveCount;
          return _buildMemberWithAnimation(isPlayer, isAlive);
        }),
      ),
    );
  }

  Widget _buildMemberWithAnimation(bool isPlayer, bool isAlive) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double yOffset = 0;
        if (isAlive) {
          yOffset = sin(_controller.value * 2 * pi) * 3;
        } else {
          yOffset = 10; // Stay down
        }

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: PixelArtMember(
            isPlayer: isPlayer,
            isAlive: isAlive,
            size: 30,
          ),
        );
      },
    );
  }
}
