import 'package:flutter/material.dart';
import 'dart:math';
import 'pixel_art_member.dart';
import 'pixel_art_icon.dart';

class KillAnimation extends StatefulWidget {
  final String victimName;
  final String weaponUsed;
  final bool isPlayerKiller;

  const KillAnimation({
    super.key,
    required this.victimName,
    required this.weaponUsed,
    required this.isPlayerKiller,
  });

  @override
  KillAnimationState createState() => KillAnimationState();
}

class KillAnimationState extends State<KillAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<BloodParticle> _bloodParticles = [];
  final List<GoreParticle> _goreParticles = [];
  final List<WeaponParticle> _weaponParticles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _spawnKillEffects();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spawnKillEffects() {
    // Blood explosion
    for (int i = 0; i < 20; i++) {
      _bloodParticles.add(
        BloodParticle(
          position: const Offset(200, 150),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 8,
            -2 - _random.nextDouble() * 6,
          ),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 1.0,
          life: 40 + _random.nextInt(30),
        ),
      );
    }

    // Gore chunks
    for (int i = 0; i < 8; i++) {
      _goreParticles.add(
        GoreParticle(
          position: const Offset(200, 150),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 4,
            -1 - _random.nextDouble() * 3,
          ),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.5,
          life: 60 + _random.nextInt(40),
        ),
      );
    }

    // Weapon impact
    for (int i = 0; i < 5; i++) {
      _weaponParticles.add(
        WeaponParticle(
          position: const Offset(200, 150),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 2,
            -1 - _random.nextDouble() * 2,
          ),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.3,
          life: 20 + _random.nextInt(15),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: Colors.red.shade900, width: 4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(color: Colors.black),

            // Background blood splatter
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomPaint(painter: BackgroundBloodPainter()),
            ),

            // Animated particles
            CustomPaint(
              painter: KillPainter(
                bloodParticles: _bloodParticles,
                goreParticles: _goreParticles,
                weaponParticles: _weaponParticles,
              ),
              size: Size.infinite,
            ),

            // Characters
            Positioned(
              left: 100,
              bottom: 80,
              child: Column(
                children: [
                  Text(
                    widget.isPlayerKiller ? 'YOU' : 'ENEMY',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  PixelArtMember(
                    isPlayer: widget.isPlayerKiller,
                    isAlive: true,
                    isCheering: widget.isPlayerKiller,
                    size: 40,
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
                    widget.victimName.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  PixelArtMember(
                    isPlayer: !widget.isPlayerKiller,
                    isAlive: false,
                    isCheering: false,
                    size: 40,
                  ),
                ],
              ),
            ),

            // Floating weapon
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
                child: PixelArtIcon(name: widget.weaponUsed, size: 40),
              ),
            ),

            // Title
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'KILL CONFIRMED',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 24,
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
            ),

            // Kill info
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${widget.isPlayerKiller ? 'YOU' : 'ENEMY'} killed ${widget.victimName} with ${widget.weaponUsed}',
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

class BloodParticle {
  Offset position;
  Offset velocity;
  double rotation;
  double rotationSpeed;
  int life;
  int maxLife;

  BloodParticle({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
    required this.life,
  }) : maxLife = life;
}

class GoreParticle {
  Offset position;
  Offset velocity;
  double rotation;
  double rotationSpeed;
  int life;
  int maxLife;

  GoreParticle({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
    required this.life,
  }) : maxLife = life;
}

class WeaponParticle {
  Offset position;
  Offset velocity;
  double rotation;
  double rotationSpeed;
  int life;
  int maxLife;

  WeaponParticle({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
    required this.life,
  }) : maxLife = life;
}

class BackgroundBloodPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw background blood splatters
    paint.color = Colors.red.shade900.withValues(alpha: 0.3);

    // Large blood splatter
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.4),
        width: 100,
        height: 60,
      ),
      paint,
    );

    // Smaller splatters
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.3, size.height * 0.6),
        width: 60,
        height: 40,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.7, size.height * 0.6),
        width: 60,
        height: 40,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class KillPainter extends CustomPainter {
  final List<BloodParticle> bloodParticles;
  final List<GoreParticle> goreParticles;
  final List<WeaponParticle> weaponParticles;

  KillPainter({
    required this.bloodParticles,
    required this.goreParticles,
    required this.weaponParticles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bloodPaint = Paint()..style = PaintingStyle.fill;
    final gorePaint = Paint()..style = PaintingStyle.fill;
    final weaponPaint = Paint()..style = PaintingStyle.fill;

    // Draw blood particles
    for (var particle in bloodParticles) {
      final currentOpacity = particle.life / particle.maxLife;
      bloodPaint.color = Colors.red.shade900.withValues(alpha: currentOpacity);

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw blood droplet
      final path = Path();
      path.moveTo(0, -particle.life * 0.1);
      path.quadraticBezierTo(particle.life * 0.05, 0, 0, particle.life * 0.1);
      path.quadraticBezierTo(-particle.life * 0.05, 0, 0, -particle.life * 0.1);
      path.close();

      canvas.drawPath(path, bloodPaint);
      canvas.restore();
    }

    // Draw gore particles
    for (var particle in goreParticles) {
      final currentOpacity = particle.life / particle.maxLife;
      gorePaint.color = Colors.pink.shade300.withValues(alpha: currentOpacity);

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw gore chunk
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            -particle.life * 0.05,
            -particle.life * 0.03,
            particle.life * 0.1,
            particle.life * 0.06,
          ),
          Radius.circular(particle.life * 0.02),
        ),
        gorePaint,
      );
      canvas.restore();
    }

    // Draw weapon particles
    for (var particle in weaponParticles) {
      final currentOpacity = particle.life / particle.maxLife;
      weaponPaint.color = Colors.yellow.withValues(alpha: currentOpacity);

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw weapon impact spark
      final path = Path();
      path.moveTo(0, -4);
      path.lineTo(2, 0);
      path.lineTo(0, 4);
      path.lineTo(-2, 0);
      path.close();

      canvas.drawPath(path, weaponPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant KillPainter oldDelegate) => true;
}
