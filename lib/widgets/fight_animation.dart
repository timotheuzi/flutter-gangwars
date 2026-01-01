import 'package:flutter/material.dart';
import 'dart:math';
import 'pixel_art_member.dart';
import 'pixel_art_icon.dart';

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

enum ParticleType { blood, gut }

class Particle {
  Offset position;
  Offset velocity;
  double size;
  double opacity;
  double rotation;
  double rotationSpeed;
  Color color;
  ParticleType type;
  int life;
  int maxLife;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.type,
    required this.maxLife,
  }) : life = maxLife;
}

class BloodSplatterPainter extends CustomPainter {
  final List<Particle> particles;

  BloodSplatterPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final bloodPaint = Paint()..style = PaintingStyle.fill;
    final gutPaint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      final currentOpacity = particle.opacity * (particle.life / particle.maxLife);
      
      if (particle.type == ParticleType.blood) {
        bloodPaint.color = particle.color.withValues(alpha: currentOpacity);
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        
        final path = Path();
        path.moveTo(0, -particle.size);
        path.quadraticBezierTo(particle.size * 0.5, -particle.size * 0.8, particle.size, 0);
        path.quadraticBezierTo(particle.size * 0.8, particle.size * 0.5, 0, particle.size);
        path.quadraticBezierTo(-particle.size * 0.8, particle.size * 0.5, -particle.size, 0);
        path.quadraticBezierTo(-particle.size * 0.5, -particle.size * 0.8, 0, -particle.size);
        
        canvas.drawPath(path, bloodPaint);
        canvas.restore();
      } else {
        // Guts/Gore: irregular shapes
        gutPaint.color = particle.color.withValues(alpha: currentOpacity);
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        
        // Rect for a "chunk"
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(-particle.size/2, -particle.size/4, particle.size, particle.size/2),
            Radius.circular(particle.size / 4)
          ),
          gutPaint
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant BloodSplatterPainter oldDelegate) => true;
}

class FightAnimationState extends State<FightAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // Approx 60fps
    )..addListener(_updateParticles)..repeat();
  }

  void _updateParticles() {
    if (!mounted) return;
    
    setState(() {
      for (int i = _particles.length - 1; i >= 0; i--) {
        final p = _particles[i];
        p.position += p.velocity;
        p.velocity += const Offset(0, 0.2); // Gravity
        p.rotation += p.rotationSpeed;
        p.life--;
        
        if (p.life <= 0) {
          _particles.removeAt(i);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addExplosion(Offset position, bool isGut) {
    int count = isGut ? 15 : 25;
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 1.0 + _random.nextDouble() * 4.0;
      
      _particles.add(Particle(
        position: position,
        velocity: Offset(cos(angle) * speed, sin(angle) * speed - 2), // Upward bias
        size: isGut ? (4 + _random.nextDouble() * 6) : (2 + _random.nextDouble() * 5),
        opacity: 0.8 + _random.nextDouble() * 0.2,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.5,
        color: isGut ? Colors.pink.shade300 : Colors.red.shade900,
        type: isGut && _random.nextDouble() > 0.6 ? ParticleType.gut : ParticleType.blood,
        maxLife: 40 + _random.nextInt(30),
      ));
    }
  }

  @override
  void didUpdateWidget(FightAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playerHealth < oldWidget.playerHealth) {
      final pos = Offset(40 + _random.nextDouble() * 60, 100 + _random.nextDouble() * 50);
      _addExplosion(pos, (oldWidget.playerHealth - widget.playerHealth) > 15);
    }
    if (widget.enemyHealth < oldWidget.enemyHealth) {
      final pos = Offset(MediaQuery.of(context).size.width - 140 + _random.nextDouble() * 60, 100 + _random.nextDouble() * 50);
       _addExplosion(pos, (oldWidget.enemyHealth - widget.enemyHealth) > 20);
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
              painter: BloodSplatterPainter(_particles),
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
    
    // Safety check
    if (totalCount <= 0) return const SizedBox();
    
    final healthPerMember = maxHealth / totalCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: isPlayer ? WrapAlignment.start : WrapAlignment.end,
        children: List.generate(totalCount, (index) {
          final memberThreshold = index * healthPerMember;
          final isAlive = currentHealth > memberThreshold;
          
          final isVictorious = (isPlayer && widget.enemyHealth <= 0) || (!isPlayer && widget.playerHealth <= 0);
          
          return _buildMemberWithAnimation(isPlayer, isAlive, isAlive && isVictorious, index);
        }),
      ),
    );
  }

  Widget _buildMemberWithAnimation(bool isPlayer, bool isAlive, bool isCheering, int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double yOffset = 0;
        if (isAlive) {
          yOffset = sin(_controller.value * 2 * pi * 0.05 + (index * 0.5)) * 3;
        } else {
          yOffset = 10;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAlive && !isCheering && widget.currentWeapon != null)
               _buildWeaponFloating(isPlayer),
            Transform.translate(
              offset: Offset(0, yOffset),
              child: PixelArtMember(
                isPlayer: isPlayer,
                isAlive: isAlive,
                isCheering: isCheering,
                size: 30,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeaponFloating(bool isPlayer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: PixelArtIcon(name: _getSanitizedWeaponName(widget.currentWeapon!), size: 16),
    );
  }

  String _getSanitizedWeaponName(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('pistol')) return 'pistol';
    if (lower.contains('uzi')) return 'uzi';
    if (lower.contains('ar15')) return 'ar15';
    if (lower.contains('sword')) return 'sword';
    if (lower.contains('bat')) return 'bat';
    if (lower.contains('grenade')) return 'grenade';
    if (lower.contains('knife')) return 'knife';
    return 'pistol';
  }
}
