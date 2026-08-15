import 'package:flutter/material.dart';
import 'dart:math';
import 'pixel_art_member.dart';
import 'pixel_art_icon.dart';

/// Advanced Animation System for Gang Wars
/// Provides smooth, pixelated animations for all game situations

class AdvancedAnimations {
  /// Create a smooth particle system with pixel art style
  static Widget createParticleSystem({
    required int particleCount,
    required Color particleColor,
    required double particleSize,
    required Duration duration,
    Offset startOffset = Offset.zero,
    Offset endOffset = const Offset(0, -50),
    bool isPixelated = true,
  }) {
    return _ParticleSystem(
      particleCount: particleCount,
      particleColor: particleColor,
      particleSize: particleSize,
      duration: duration,
      startOffset: startOffset,
      endOffset: endOffset,
      isPixelated: isPixelated,
    );
  }

  /// Create a smooth character animation with multiple states
  static Widget createCharacterAnimation({
    required bool isPlayer,
    required CharacterState state,
    required double size,
    VoidCallback? onAnimationComplete,
  }) {
    return _CharacterAnimation(
      isPlayer: isPlayer,
      state: state,
      size: size,
      onAnimationComplete: onAnimationComplete,
    );
  }

  /// Create a weapon animation with muzzle flash and recoil
  static Widget createWeaponAnimation({
    required String weaponType,
    required bool isFiring,
    required double size,
    VoidCallback? onAnimationComplete,
  }) {
    return _WeaponAnimation(
      weaponType: weaponType,
      isFiring: isFiring,
      size: size,
      onAnimationComplete: onAnimationComplete,
    );
  }

  /// Create a vehicle animation with movement and effects
  static Widget createVehicleAnimation({
    required String vehicleType,
    required bool isMoving,
    required double size,
    VoidCallback? onAnimationComplete,
  }) {
    return _VehicleAnimation(
      vehicleType: vehicleType,
      isMoving: isMoving,
      size: size,
      onAnimationComplete: onAnimationComplete,
    );
  }

  /// Create an explosion animation with pixel art debris
  static Widget createExplosionAnimation({
    required ExplosionType type,
    required double size,
    VoidCallback? onAnimationComplete,
  }) {
    return _ExplosionAnimation(
      type: type,
      size: size,
      onAnimationComplete: onAnimationComplete,
    );
  }

  /// Create a weather effect animation
  static Widget createWeatherAnimation({
    required WeatherType type,
    required double intensity,
    required Size containerSize,
  }) {
    return _WeatherAnimation(
      type: type,
      intensity: intensity,
      containerSize: containerSize,
    );
  }

  /// Create a UI transition animation
  static Widget createUITransition({
    required Widget child,
    required TransitionType type,
    required Duration duration,
  }) {
    return _UITransition(type: type, duration: duration, child: child);
  }

  /// Create a damage indicator animation
  static Widget createDamageIndicator({
    required int damage,
    required bool isCritical,
    required Offset position,
  }) {
    return _DamageIndicator(
      damage: damage,
      isCritical: isCritical,
      position: position,
    );
  }

  /// Create a status effect animation
  static Widget createStatusEffect({
    required StatusEffectType type,
    required double size,
    required Duration duration,
  }) {
    return _StatusEffect(type: type, size: size, duration: duration);
  }

  /// Create a loading animation with pixel art style
  static Widget createLoadingAnimation({
    required double size,
    required Color color,
  }) {
    return _LoadingAnimation(size: size, color: color);
  }
}

// Enums for animation types
enum CharacterState {
  idle,
  walking,
  running,
  attacking,
  hurt,
  dying,
  celebrating,
}

enum ExplosionType { small, medium, large, fire, smoke }

enum WeatherType { rain, snow, fog, dust }

enum TransitionType { fade, slide, scale, rotate }

enum StatusEffectType { poison, burn, freeze, boost, shield }

// Particle System Implementation
class _ParticleSystem extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final double particleSize;
  final Duration duration;
  final Offset startOffset;
  final Offset endOffset;
  final bool isPixelated;

  const _ParticleSystem({
    required this.particleCount,
    required this.particleColor,
    required this.particleSize,
    required this.duration,
    required this.startOffset,
    required this.endOffset,
    required this.isPixelated,
  });

  @override
  _ParticleSystemState createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<_ParticleSystem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();

    _generateParticles();
  }

  void _generateParticles() {
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(
        _Particle(
          position: widget.startOffset,
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 4,
            -2 - _random.nextDouble() * 3,
          ),
          size: widget.particleSize * (0.5 + _random.nextDouble() * 0.5),
          life: 40 + _random.nextInt(30),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            color: widget.particleColor,
            isPixelated: widget.isPixelated,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  Offset position;
  Offset velocity;
  double size;
  int life;
  int maxLife;

  _Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.life,
  }) : maxLife = life;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;
  final bool isPixelated;
  final double progress;

  _ParticlePainter({
    required this.particles,
    required this.color,
    required this.isPixelated,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      final currentOpacity = particle.life / particle.maxLife;
      paint.color = color.withValues(alpha: currentOpacity);

      if (isPixelated) {
        // Draw pixelated particle
        final pixelSize = particle.size / 2;
        canvas.drawRect(
          Rect.fromLTWH(
            particle.position.dx - pixelSize / 2,
            particle.position.dy - pixelSize / 2,
            pixelSize,
            pixelSize,
          ),
          paint,
        );
      } else {
        // Draw smooth particle
        canvas.drawCircle(particle.position, particle.size, paint);
      }

      // Update particle position
      particle.position += particle.velocity;
      particle.velocity += const Offset(0, 0.1); // Gravity
      particle.life--;
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

// Character Animation Implementation
class _CharacterAnimation extends StatefulWidget {
  final bool isPlayer;
  final CharacterState state;
  final double size;
  final VoidCallback? onAnimationComplete;

  const _CharacterAnimation({
    required this.isPlayer,
    required this.state,
    required this.size,
    this.onAnimationComplete,
  });

  @override
  _CharacterAnimationState createState() => _CharacterAnimationState();
}

class _CharacterAnimationState extends State<_CharacterAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bobAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _getAnimationDuration(),
    );

    _bobAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward().then((_) {
      widget.onAnimationComplete?.call();
    });
  }

  Duration _getAnimationDuration() {
    switch (widget.state) {
      case CharacterState.idle:
        return const Duration(seconds: 2);
      case CharacterState.walking:
        return const Duration(milliseconds: 800);
      case CharacterState.running:
        return const Duration(milliseconds: 400);
      case CharacterState.attacking:
        return const Duration(milliseconds: 300);
      case CharacterState.hurt:
        return const Duration(milliseconds: 200);
      case CharacterState.dying:
        return const Duration(milliseconds: 500);
      case CharacterState.celebrating:
        return const Duration(milliseconds: 600);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _getOffset(),
          child: Transform.rotate(
            angle: _getRotation(),
            child: PixelArtMember(
              isPlayer: widget.isPlayer,
              isAlive: widget.state != CharacterState.dying,
              isCheering: widget.state == CharacterState.celebrating,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }

  Offset _getOffset() {
    switch (widget.state) {
      case CharacterState.idle:
        return Offset(0, sin(_bobAnimation.value) * 2);
      case CharacterState.walking:
        return Offset(sin(_bobAnimation.value) * 3, 0);
      case CharacterState.running:
        return Offset(sin(_bobAnimation.value) * 5, 0);
      case CharacterState.attacking:
        return Offset(_shakeAnimation.value * 10, 0);
      case CharacterState.hurt:
        return Offset(_shakeAnimation.value * 8, _shakeAnimation.value * 4);
      case CharacterState.dying:
        return Offset(0, _controller.value * 20);
      case CharacterState.celebrating:
        return Offset(0, sin(_bobAnimation.value) * 8);
    }
  }

  double _getRotation() {
    switch (widget.state) {
      case CharacterState.hurt:
        return _shakeAnimation.value * 0.2;
      case CharacterState.dying:
        return _controller.value * pi / 2;
      default:
        return 0.0;
    }
  }
}

// Weapon Animation Implementation
class _WeaponAnimation extends StatefulWidget {
  final String weaponType;
  final bool isFiring;
  final double size;
  final VoidCallback? onAnimationComplete;

  const _WeaponAnimation({
    required this.weaponType,
    required this.isFiring,
    required this.size,
    this.onAnimationComplete,
  });

  @override
  _WeaponAnimationState createState() => _WeaponAnimationState();
}

class _WeaponAnimationState extends State<_WeaponAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _recoilAnimation;
  late Animation<double> _flashAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _recoilAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _flashAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    if (widget.isFiring) {
      _controller.forward().then((_) {
        widget.onAnimationComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Weapon with recoil
            Transform.translate(
              offset: Offset(-_recoilAnimation.value * 5, 0),
              child: PixelArtIcon(name: widget.weaponType, size: widget.size),
            ),

            // Muzzle flash
            if (widget.isFiring && _flashAnimation.value > 0.5)
              Positioned(
                right: -widget.size * 0.3,
                top: widget.size * 0.3,
                child: Opacity(
                  opacity: 1 - _flashAnimation.value,
                  child: Container(
                    width: widget.size * 0.4,
                    height: widget.size * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// Vehicle Animation Implementation
class _VehicleAnimation extends StatefulWidget {
  final String vehicleType;
  final bool isMoving;
  final double size;
  final VoidCallback? onAnimationComplete;

  const _VehicleAnimation({
    required this.vehicleType,
    required this.isMoving,
    required this.size,
    this.onAnimationComplete,
  });

  @override
  _VehicleAnimationState createState() => _VehicleAnimationState();
}

class _VehicleAnimationState extends State<_VehicleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _wheelAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _wheelAnimation = Tween<double>(
      begin: 0.0,
      end: 4 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    if (widget.isMoving) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, sin(_bounceAnimation.value) * 2),
          child: CustomPaint(
            painter: _VehiclePainter(
              vehicleType: widget.vehicleType,
              wheelRotation: _wheelAnimation.value,
              size: widget.size,
            ),
            size: Size(widget.size * 2, widget.size),
          ),
        );
      },
    );
  }
}

class _VehiclePainter extends CustomPainter {
  final String vehicleType;
  final double wheelRotation;
  final double size;

  _VehiclePainter({
    required this.vehicleType,
    required this.wheelRotation,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()..style = PaintingStyle.fill;
    final pixelSize = size / 16;

    void drawPixel(int x, int y, Color color) {
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint..color = color,
      );
    }

    // Draw vehicle body
    final bodyColor = Colors.blue.shade800;
    for (int x = 4; x < 20; x++) {
      for (int y = 6; y < 12; y++) {
        drawPixel(x, y, bodyColor);
      }
    }

    // Draw wheels with rotation
    final wheelColor = Colors.black;
    final wheelOffset = (wheelRotation / (2 * pi)).toInt() % 2;

    // Front wheel
    for (int x = 6; x < 10; x++) {
      for (int y = 12; y < 16; y++) {
        if ((x + y + wheelOffset) % 2 == 0) {
          drawPixel(x, y, wheelColor);
        }
      }
    }

    // Back wheel
    for (int x = 16; x < 20; x++) {
      for (int y = 12; y < 16; y++) {
        if ((x + y + wheelOffset) % 2 == 0) {
          drawPixel(x, y, wheelColor);
        }
      }
    }

    // Draw windows
    final windowColor = Colors.lightBlue.shade200;
    for (int x = 8; x < 18; x++) {
      for (int y = 7; y < 10; y++) {
        drawPixel(x, y, windowColor);
      }
    }

    // Draw headlights
    final headlightColor = Colors.yellow;
    drawPixel(4, 8, headlightColor);
    drawPixel(4, 9, headlightColor);
  }

  @override
  bool shouldRepaint(covariant _VehiclePainter oldDelegate) => true;
}

// Explosion Animation Implementation
class _ExplosionAnimation extends StatefulWidget {
  final ExplosionType type;
  final double size;
  final VoidCallback? onAnimationComplete;

  const _ExplosionAnimation({
    required this.type,
    required this.size,
    this.onAnimationComplete,
  });

  @override
  _ExplosionAnimationState createState() => _ExplosionAnimationState();
}

class _ExplosionAnimationState extends State<_ExplosionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Debris> _debris = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _getDuration())
      ..forward();

    _generateDebris();
  }

  Duration _getDuration() {
    switch (widget.type) {
      case ExplosionType.small:
        return const Duration(milliseconds: 300);
      case ExplosionType.medium:
        return const Duration(milliseconds: 500);
      case ExplosionType.large:
        return const Duration(milliseconds: 800);
      case ExplosionType.fire:
        return const Duration(milliseconds: 1000);
      case ExplosionType.smoke:
        return const Duration(milliseconds: 1500);
    }
  }

  void _generateDebris() {
    final count = _getDebrisCount();
    for (int i = 0; i < count; i++) {
      _debris.add(
        _Debris(
          position: Offset(widget.size / 2, widget.size / 2),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 8,
            -2 - _random.nextDouble() * 6,
          ),
          size: 2 + _random.nextDouble() * 4,
          color: _getDebrisColor(),
          life: 30 + _random.nextInt(40),
        ),
      );
    }
  }

  int _getDebrisCount() {
    switch (widget.type) {
      case ExplosionType.small:
        return 10;
      case ExplosionType.medium:
        return 20;
      case ExplosionType.large:
        return 40;
      case ExplosionType.fire:
        return 30;
      case ExplosionType.smoke:
        return 15;
    }
  }

  Color _getDebrisColor() {
    switch (widget.type) {
      case ExplosionType.small:
        return Colors.orange;
      case ExplosionType.medium:
        return Colors.red;
      case ExplosionType.large:
        return Colors.deepOrange;
      case ExplosionType.fire:
        return Colors.yellow;
      case ExplosionType.smoke:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ExplosionPainter(
            debris: _debris,
            progress: _controller.value,
            type: widget.type,
          ),
          size: Size(widget.size, widget.size),
        );
      },
    );
  }
}

class _Debris {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  int life;
  int maxLife;

  _Debris({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.life,
  }) : maxLife = life;
}

class _ExplosionPainter extends CustomPainter {
  final List<_Debris> debris;
  final double progress;
  final ExplosionType type;

  _ExplosionPainter({
    required this.debris,
    required this.progress,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw explosion core
    final corePaint = Paint()..style = PaintingStyle.fill;
    final coreRadius = size.width / 2 * (1 - progress);

    switch (type) {
      case ExplosionType.small:
        corePaint.color = Colors.orange.withValues(alpha: 1 - progress);
        break;
      case ExplosionType.medium:
        corePaint.color = Colors.red.withValues(alpha: 1 - progress);
        break;
      case ExplosionType.large:
        corePaint.color = Colors.deepOrange.withValues(alpha: 1 - progress);
        break;
      case ExplosionType.fire:
        corePaint.color = Colors.yellow.withValues(alpha: 1 - progress);
        break;
      case ExplosionType.smoke:
        corePaint.color = Colors.grey.withValues(alpha: 1 - progress);
        break;
    }

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      coreRadius,
      corePaint,
    );

    // Draw debris
    for (var d in debris) {
      final currentOpacity = d.life / d.maxLife;
      paint.color = d.color.withValues(alpha: currentOpacity);

      canvas.drawRect(
        Rect.fromLTWH(
          d.position.dx - d.size / 2,
          d.position.dy - d.size / 2,
          d.size,
          d.size,
        ),
        paint,
      );

      // Update debris
      d.position += d.velocity;
      d.velocity += const Offset(0, 0.2); // Gravity
      d.life--;
    }
  }

  @override
  bool shouldRepaint(covariant _ExplosionPainter oldDelegate) => true;
}

// Weather Animation Implementation
class _WeatherAnimation extends StatefulWidget {
  final WeatherType type;
  final double intensity;
  final Size containerSize;

  const _WeatherAnimation({
    required this.type,
    required this.intensity,
    required this.containerSize,
  });

  @override
  _WeatherAnimationState createState() => _WeatherAnimationState();
}

class _WeatherAnimationState extends State<_WeatherAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_WeatherParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _generateParticles();
  }

  void _generateParticles() {
    final count = (widget.intensity * 100).toInt();
    for (int i = 0; i < count; i++) {
      _particles.add(
        _WeatherParticle(
          position: Offset(
            _random.nextDouble() * widget.containerSize.width,
            _random.nextDouble() * widget.containerSize.height,
          ),
          velocity: _getVelocity(),
          size: _getSize(),
          opacity: 0.3 + _random.nextDouble() * 0.7,
        ),
      );
    }
  }

  Offset _getVelocity() {
    switch (widget.type) {
      case WeatherType.rain:
        return Offset(0, 5 + _random.nextDouble() * 5);
      case WeatherType.snow:
        return Offset(
          (_random.nextDouble() - 0.5) * 2,
          1 + _random.nextDouble() * 2,
        );
      case WeatherType.fog:
        return Offset(
          (_random.nextDouble() - 0.5) * 0.5,
          (_random.nextDouble() - 0.5) * 0.5,
        );
      case WeatherType.dust:
        return Offset(
          1 + _random.nextDouble() * 2,
          (_random.nextDouble() - 0.5) * 1,
        );
    }
  }

  double _getSize() {
    switch (widget.type) {
      case WeatherType.rain:
        return 1 + _random.nextDouble() * 2;
      case WeatherType.snow:
        return 2 + _random.nextDouble() * 3;
      case WeatherType.fog:
        return 10 + _random.nextDouble() * 20;
      case WeatherType.dust:
        return 1 + _random.nextDouble() * 2;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _WeatherPainter(
            particles: _particles,
            type: widget.type,
            containerSize: widget.containerSize,
          ),
          size: widget.containerSize,
        );
      },
    );
  }
}

class _WeatherParticle {
  Offset position;
  Offset velocity;
  double size;
  double opacity;

  _WeatherParticle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
  });
}

class _WeatherPainter extends CustomPainter {
  final List<_WeatherParticle> particles;
  final WeatherType type;
  final Size containerSize;

  _WeatherPainter({
    required this.particles,
    required this.type,
    required this.containerSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      switch (type) {
        case WeatherType.rain:
          paint.color = Colors.blue.withValues(alpha: particle.opacity);
          canvas.drawRect(
            Rect.fromLTWH(
              particle.position.dx,
              particle.position.dy,
              particle.size,
              particle.size * 3,
            ),
            paint,
          );
          break;
        case WeatherType.snow:
          paint.color = Colors.white.withValues(alpha: particle.opacity);
          canvas.drawCircle(particle.position, particle.size, paint);
          break;
        case WeatherType.fog:
          paint.color = Colors.grey.withValues(alpha: particle.opacity * 0.3);
          canvas.drawCircle(particle.position, particle.size, paint);
          break;
        case WeatherType.dust:
          paint.color = Colors.brown.withValues(alpha: particle.opacity);
          canvas.drawCircle(particle.position, particle.size, paint);
          break;
      }

      // Update particle position
      particle.position += particle.velocity;

      // Wrap around screen
      if (particle.position.dy > containerSize.height) {
        var random = Random();
        particle.position = Offset(
          random.nextDouble() * containerSize.width,
          -particle.size,
        );
      }
      if (particle.position.dx > containerSize.width) {
        particle.position = Offset(-particle.size, particle.position.dy);
      }
      if (particle.position.dx < -particle.size) {
        particle.position = Offset(containerSize.width, particle.position.dy);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherPainter oldDelegate) => true;
}

// UI Transition Implementation
class _UITransition extends StatefulWidget {
  final Widget child;
  final TransitionType type;
  final Duration duration;

  const _UITransition({
    required this.child,
    required this.type,
    required this.duration,
  });

  @override
  _UITransitionState createState() => _UITransitionState();
}

class _UITransitionState extends State<_UITransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        switch (widget.type) {
          case TransitionType.fade:
            return Opacity(opacity: _animation.value, child: widget.child);
          case TransitionType.slide:
            return Transform.translate(
              offset: Offset(0, (1 - _animation.value) * 100),
              child: widget.child,
            );
          case TransitionType.scale:
            return Transform.scale(
              scale: _animation.value,
              child: widget.child,
            );
          case TransitionType.rotate:
            return Transform.rotate(
              angle: _animation.value * 2 * pi,
              child: widget.child,
            );
        }
      },
    );
  }
}

// Damage Indicator Implementation
class _DamageIndicator extends StatefulWidget {
  final int damage;
  final bool isCritical;
  final Offset position;

  const _DamageIndicator({
    required this.damage,
    required this.isCritical,
    required this.position,
  });

  @override
  _DamageIndicatorState createState() => _DamageIndicatorState();
}

class _DamageIndicatorState extends State<_DamageIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: -50.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.position.dx,
          top: widget.position.dy + _floatAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: 1 - _controller.value,
              child: Text(
                '-${widget.damage}',
                style: TextStyle(
                  color: widget.isCritical ? Colors.red : Colors.white,
                  fontSize: widget.isCritical ? 24 : 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 2,
                      offset: const Offset(1, 1),
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
}

// Status Effect Implementation
class _StatusEffect extends StatefulWidget {
  final StatusEffectType type;
  final double size;
  final Duration duration;

  const _StatusEffect({
    required this.type,
    required this.size,
    required this.duration,
  });

  @override
  _StatusEffectState createState() => _StatusEffectState();
}

class _StatusEffectState extends State<_StatusEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _getColor().withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(color: _getColor(), width: 2),
            ),
            child: Center(
              child: Icon(
                _getIcon(),
                color: _getColor(),
                size: widget.size * 0.6,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getColor() {
    switch (widget.type) {
      case StatusEffectType.poison:
        return Colors.green;
      case StatusEffectType.burn:
        return Colors.orange;
      case StatusEffectType.freeze:
        return Colors.blue;
      case StatusEffectType.boost:
        return Colors.yellow;
      case StatusEffectType.shield:
        return Colors.purple;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case StatusEffectType.poison:
        return Icons.bug_report;
      case StatusEffectType.burn:
        return Icons.local_fire_department;
      case StatusEffectType.freeze:
        return Icons.ac_unit;
      case StatusEffectType.boost:
        return Icons.arrow_upward;
      case StatusEffectType.shield:
        return Icons.shield;
    }
  }
}

// Loading Animation Implementation
class _LoadingAnimation extends StatefulWidget {
  final double size;
  final Color color;

  const _LoadingAnimation({required this.size, required this.color});

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<_LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: CustomPaint(
            painter: _LoadingPainter(color: widget.color, size: widget.size),
            size: Size(widget.size, widget.size),
          ),
        );
      },
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final Color color;
  final double size;

  _LoadingPainter({required this.color, required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = color;

    final pixelSize = size / 8;
    final center = Offset(size / 2, size / 2);

    // Draw pixelated loading circle
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final x = center.dx + cos(angle) * (size / 2 - pixelSize);
      final y = center.dy + sin(angle) * (size / 2 - pixelSize);

      canvas.drawRect(
        Rect.fromLTWH(
          x - pixelSize / 2,
          y - pixelSize / 2,
          pixelSize,
          pixelSize,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LoadingPainter oldDelegate) => false;
}
