import 'package:flutter/material.dart';
import 'dart:math';
import 'pixel_art_member.dart';
import 'pixel_art_icon.dart';

class DrugDealAnimation extends StatefulWidget {
  final String dealerName;
  final String drugType;
  final int quantity;
  final int price;
  final bool isSuccessful;

  const DrugDealAnimation({
    super.key,
    required this.dealerName,
    required this.drugType,
    required this.quantity,
    required this.price,
    required this.isSuccessful,
  });

  @override
  DrugDealAnimationState createState() => DrugDealAnimationState();
}

class DrugDealAnimationState extends State<DrugDealAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<MoneyParticle> _moneyParticles = [];
  final List<DrugParticle> _drugParticles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    // Spawn particles based on deal success
    if (widget.isSuccessful) {
      _spawnSuccessfulDeal();
    } else {
      _spawnFailedDeal();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spawnSuccessfulDeal() {
    // Money flying from player to dealer
    for (int i = 0; i < 8; i++) {
      _moneyParticles.add(
        MoneyParticle(
          position: const Offset(100, 150),
          velocity: Offset(
            2 + _random.nextDouble() * 3,
            -1 + _random.nextDouble() * 2,
          ),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.5,
          life: 60 + _random.nextInt(20),
        ),
      );
    }

    // Drugs flying from dealer to player
    for (int i = 0; i < 6; i++) {
      _drugParticles.add(
        DrugParticle(
          position: const Offset(300, 150),
          velocity: Offset(
            -2 - _random.nextDouble() * 3,
            -1 + _random.nextDouble() * 2,
          ),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.3,
          life: 50 + _random.nextInt(20),
        ),
      );
    }
  }

  void _spawnFailedDeal() {
    // Angry dealer animation
    for (int i = 0; i < 10; i++) {
      _moneyParticles.add(
        MoneyParticle(
          position: const Offset(300, 150),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 4,
            -2 - _random.nextDouble() * 3,
          ),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 1.0,
          life: 40 + _random.nextInt(20),
        ),
      );
    }

    // Threatening gesture
    for (int i = 0; i < 5; i++) {
      _drugParticles.add(
        DrugParticle(
          position: const Offset(300, 120),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 2,
            -3 - _random.nextDouble() * 2,
          ),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.8,
          life: 30 + _random.nextInt(15),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.brown.shade800,
        border: Border.all(color: Colors.brown.shade600, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(color: Colors.brown.shade900),

            // Background alley
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(color: Colors.grey.shade800),
            ),

            // Title
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.isSuccessful ? 'DEAL COMPLETED' : 'DEAL FAILED',
                  style: TextStyle(
                    color: widget.isSuccessful
                        ? Colors.green.shade400
                        : Colors.red.shade400,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Animated particles
            CustomPaint(
              painter: DealPainter(
                moneyParticles: _moneyParticles,
                drugParticles: _drugParticles,
              ),
              size: Size.infinite,
            ),

            // Characters
            Positioned(
              left: 80,
              bottom: 90,
              child: Column(
                children: [
                  const Text(
                    'YOU',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  PixelArtMember(
                    isPlayer: true,
                    isAlive: true,
                    isCheering: widget.isSuccessful,
                    size: 36,
                  ),
                ],
              ),
            ),

            Positioned(
              right: 80,
              bottom: 90,
              child: Column(
                children: [
                  Text(
                    widget.dealerName.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  PixelArtMember(
                    isPlayer: false,
                    isAlive: true,
                    isCheering: widget.isSuccessful,
                    size: 36,
                  ),
                ],
              ),
            ),

            // Floating icons
            if (widget.isSuccessful) ...[
              Positioned(
                left: 120,
                top: 80,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, sin(_controller.value * 4 * pi) * 10),
                      child: child,
                    );
                  },
                  child: PixelArtIcon(name: widget.drugType, size: 32),
                ),
              ),
              Positioned(
                right: 120,
                top: 80,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        sin(_controller.value * 4 * pi + 1) * 10,
                      ),
                      child: child,
                    );
                  },
                  child: const Text(
                    '\$',
                    style: TextStyle(fontSize: 32, color: Colors.yellow),
                  ),
                ),
              ),
            ],

            // Deal info
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${widget.quantity}x ${widget.drugType.toUpperCase()} - \$${widget.price}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoneyParticle {
  Offset position;
  Offset velocity;
  double rotation;
  double rotationSpeed;
  int life;
  int maxLife;

  MoneyParticle({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
    required this.life,
  }) : maxLife = life;
}

class DrugParticle {
  Offset position;
  Offset velocity;
  double rotation;
  double rotationSpeed;
  int life;
  int maxLife;

  DrugParticle({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
    required this.life,
  }) : maxLife = life;
}

class DealPainter extends CustomPainter {
  final List<MoneyParticle> moneyParticles;
  final List<DrugParticle> drugParticles;

  DealPainter({required this.moneyParticles, required this.drugParticles});

  @override
  void paint(Canvas canvas, Size size) {
    final moneyPaint = Paint()..style = PaintingStyle.fill;
    final drugPaint = Paint()..style = PaintingStyle.fill;

    // Draw money particles
    for (var particle in moneyParticles) {
      moneyPaint.color = Colors.yellow;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw dollar sign shape
      final path = Path();
      path.moveTo(-8, -8);
      path.lineTo(8, -8);
      path.lineTo(8, 8);
      path.lineTo(-8, 8);
      path.close();
      path.moveTo(-4, -4);
      path.lineTo(4, -4);
      path.lineTo(4, 4);
      path.lineTo(-4, 4);
      path.close();

      canvas.drawPath(path, moneyPaint);
      canvas.restore();
    }

    // Draw drug particles
    for (var particle in drugParticles) {
      drugPaint.color = _getDrugColor(particle.position.dx.toInt() % 3);

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw drug shape based on position
      if (particle.position.dx > 200) {
        // Crack rock shape
        final path = Path();
        path.moveTo(-6, -6);
        path.lineTo(6, -3);
        path.lineTo(4, 6);
        path.lineTo(-6, 4);
        path.close();
        canvas.drawPath(path, drugPaint);
      } else {
        // Weed leaf shape
        canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: 12, height: 8),
          drugPaint,
        );
      }

      canvas.restore();
    }
  }

  Color _getDrugColor(int index) {
    switch (index) {
      case 0:
        return Colors.green.shade700;
      case 1:
        return Colors.brown.shade600;
      case 2:
        return Colors.white;
      default:
        return Colors.purple.shade400;
    }
  }

  @override
  bool shouldRepaint(covariant DealPainter oldDelegate) => true;
}
