import 'package:flutter/material.dart';
import 'dart:math';
import 'pixel_art_member.dart';

class ProstitutionAnimation extends StatefulWidget {
  final String prostituteName;
  final int price;
  final bool isSuccessful;

  const ProstitutionAnimation({
    super.key,
    required this.prostituteName,
    required this.price,
    required this.isSuccessful,
  });

  @override
  ProstitutionAnimationState createState() => ProstitutionAnimationState();
}

class ProstitutionAnimationState extends State<ProstitutionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<HeartParticle> _heartParticles = [];
  final List<MoneyParticle> _moneyParticles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    if (widget.isSuccessful) {
      _spawnHearts();
    } else {
      _spawnAngryParticles();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spawnHearts() {
    for (int i = 0; i < 12; i++) {
      _heartParticles.add(
        HeartParticle(
          position: Offset(
            200 + _random.nextDouble() * 100,
            100 + _random.nextDouble() * 50,
          ),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 2,
            -1 - _random.nextDouble() * 2,
          ),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.3,
          life: 80 + _random.nextInt(40),
        ),
      );
    }
  }

  void _spawnAngryParticles() {
    for (int i = 0; i < 8; i++) {
      _moneyParticles.add(
        MoneyParticle(
          position: const Offset(150, 150),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 3,
            -2 - _random.nextDouble() * 3,
          ),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 1.0,
          life: 40 + _random.nextInt(20),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purple.shade900,
        border: Border.all(color: Colors.purple.shade700, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(color: Colors.purple.shade800),

            // Background neon sign
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'NEON DREAMS',
                  style: TextStyle(
                    color: Colors.pink.shade300,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.purple.shade900,
                        blurRadius: 10,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Animated particles
            CustomPaint(
              painter: ProstitutionPainter(
                heartParticles: _heartParticles,
                moneyParticles: _moneyParticles,
              ),
              size: Size.infinite,
            ),

            // Characters
            Positioned(
              left: 100,
              bottom: 80,
              child: Column(
                children: [
                  const Text(
                    'YOU',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, sin(_controller.value * 4 * pi) * 3),
                        child: child,
                      );
                    },
                    child: PixelArtMember(
                      isPlayer: true,
                      isAlive: true,
                      isCheering: widget.isSuccessful,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              right: 100,
              bottom: 80,
              child: Column(
                children: [
                  Text(
                    widget.prostituteName.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          sin(_controller.value * 4 * pi + 1) * 3,
                        ),
                        child: child,
                      );
                    },
                    child: PixelArtMember(
                      isPlayer: false,
                      isAlive: true,
                      isCheering: widget.isSuccessful,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),

            // Floating icons
            if (widget.isSuccessful) ...[
              Positioned(
                top: 120,
                left: 180,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * pi,
                      child: child,
                    );
                  },
                  child: const Text('❤️', style: TextStyle(fontSize: 40)),
                ),
              ),
            ],

            // Title
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.isSuccessful ? 'SERVICE COMPLETED' : 'SERVICE DENIED',
                  style: TextStyle(
                    color: widget.isSuccessful
                        ? Colors.pink.shade300
                        : Colors.red.shade400,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Price info
            if (!widget.isSuccessful)
              Positioned(
                top: 180,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Price: \$${widget.price}',
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

class HeartParticle {
  Offset position;
  Offset velocity;
  double rotation;
  double rotationSpeed;
  int life;
  int maxLife;

  HeartParticle({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
    required this.life,
  }) : maxLife = life;
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

class ProstitutionPainter extends CustomPainter {
  final List<HeartParticle> heartParticles;
  final List<MoneyParticle> moneyParticles;

  ProstitutionPainter({
    required this.heartParticles,
    required this.moneyParticles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final heartPaint = Paint()..style = PaintingStyle.fill;
    final moneyPaint = Paint()..style = PaintingStyle.fill;

    // Draw heart particles
    for (var particle in heartParticles) {
      final currentOpacity = 1.0;
      heartPaint.color = Colors.pink.shade300.withValues(alpha: currentOpacity);

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw heart shape
      final path = Path();
      path.moveTo(0, 8);
      path.cubicTo(-8, 0, -16, -8, -8, -16);
      path.cubicTo(0, -24, 8, -24, 16, -16);
      path.cubicTo(24, -8, 16, 0, 8, 8);
      path.close();

      canvas.drawPath(path, heartPaint);
      canvas.restore();
    }

    // Draw money particles
    for (var particle in moneyParticles) {
      final currentOpacity = 1.0;
      moneyPaint.color = Colors.yellow.withValues(alpha: currentOpacity);

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
  }

  @override
  bool shouldRepaint(covariant ProstitutionPainter oldDelegate) => true;
}
