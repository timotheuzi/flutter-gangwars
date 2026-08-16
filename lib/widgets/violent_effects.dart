import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/effects.dart';
import 'dart:math';
import '../flame_game.dart';

/// Ultra Violent Effects System
/// Advanced blood & gore system with SNES era quality but modern techniques
class ViolentEffects {
  static final Random _random = Random();

  /// Create brutal blood explosion on hit
  static void brutalBloodSplatter(Vector2 position, {int intensity = 3}) {
    if (!GraphicalSettings.instance.enableVibrantEffects) return;

    final particleCounts = [15, 30, 55, 90, 140];
    final count = particleCounts[intensity.clamp(0, 4)];

    // Blood particles
    GangWarsGame.instance.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: count,
          generator: (i) => AcceleratedParticle(
            speed: Vector2(
              (_random.nextDouble() - 0.5) * (180 + intensity * 60),
              -_random.nextDouble() * (220 + intensity * 80),
            ),
            acceleration: Vector2(0, 350 + _random.nextDouble() * 150),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final bloodColors = [
                  const Color(0xFF8B0000),
                  const Color(0xFFDC143C),
                  const Color(0xFFB22222),
                  const Color(0xFF7C0A02),
                  const Color(0xFFCD5C5C),
                ];

                final paint = Paint()
                  ..color = bloodColors[_random.nextInt(bloodColors.length)]
                      .withValues(alpha: 1 - particle.progress);

                if (particle.progress < 0.3) {
                  canvas.drawCircle(Offset.zero, 2 + _random.nextDouble() * 4, paint);
                } else {
                  canvas.drawRect(
                    Rect.fromLTWH(-1 - _random.nextDouble(), -1 - _random.nextDouble(),
                      2 + _random.nextDouble() * 3,
                      2 + _random.nextDouble() * 3
                    ),
                    paint
                  );
                }
              },
            ),
            lifespan: 0.5 + _random.nextDouble() * 0.7,
          ),
        ),
      ),
    );

    // Blood mist overlay
    GangWarsGame.instance.add(
      CircleComponent(
        position: position,
        radius: 20 + intensity * 15,
        paint: Paint()..color = const Color(0x668B0000),
        anchor: Anchor.center,
      )
        ..addAll([
          ScaleEffect.by(Vector2.all(1.0 + intensity * 0.5), EffectController(duration: 0.15)),
          OpacityEffect.fadeOut(EffectController(duration: 0.45)),
          RemoveEffect(delay: 0.45),
        ])
    );

    // Screen flash on strong hits
    if (intensity >= 3) {
      GangWarsGame.instance.camera.viewfinder.add(
        ColorEffect(
          const Color(0x77FF0000),
          EffectController(duration: 0.12, alternate: true),
        ),
      );
    }
  }

  /// Create dismemberment gib effect
  static void gibExplosion(Vector2 position, {int gibCount = 7}) {
    final gibColors = [
      const Color(0xFF8B4513),
      const Color(0xFFA0522D),
      const Color(0xFFCD853F),
      const Color(0xFFBC8F8F),
    ];

    for (int i = 0; i < gibCount; i++) {
      GangWarsGame.instance.add(
        RectangleComponent(
          position: position,
          size: Vector2(3 + _random.nextDouble() * 5, 3 + _random.nextDouble() * 5),
          angle: _random.nextDouble() * pi * 2,
          paint: Paint()..color = gibColors[_random.nextInt(gibColors.length)],
          anchor: Anchor.center,
        )
          ..addAll([
            MoveEffect.by(
              Vector2(
                (_random.nextDouble() - 0.5) * 200,
                -_random.nextDouble() * 250 - 100,
              ),
              EffectController(duration: 0.8, curve: Curves.decelerate),
            ),
            RotateEffect.by(
              _random.nextDouble() * 8 - 4,
              EffectController(duration: 0.8),
            ),
            OpacityEffect.fadeOut(EffectController(duration: 0.8, startDelay: 0.4)),
            RemoveEffect(delay: 0.8),
          ])
      );
    }
  }

  /// Critical hit with extreme violence
  static void criticalHitEffect(Vector2 position) {
    brutalBloodSplatter(position, intensity: 5);
    gibExplosion(position, gibCount: 12);
    GangWarsGame.instance.shakeScreen(intensity: 14, duration: const Duration(milliseconds: 350));

    // Critical flash
    GangWarsGame.instance.add(
      RectangleComponent(
        position: Vector2.zero(),
        size: Vector2(GangWarsGame.instance.size.x, GangWarsGame.instance.size.y),
        paint: Paint()..color = const Color(0x55FFFFFF),
      )
        ..addAll([
          OpacityEffect.fadeOut(EffectController(duration: 0.06)),
          RemoveEffect(delay: 0.06),
        ])
    );
  }

  /// Bullet hit effect
  static void bulletHit(Vector2 position, {bool isHeadshot = false}) {
    brutalBloodSplatter(position, intensity: isHeadshot ? 4 : 2);

    if (isHeadshot) {
      GangWarsGame.instance.shakeScreen(intensity: 8);
      gibExplosion(position, gibCount: 5);
    }
  }

  /// Melee hit with bone crunch effect
  static void meleeHit(Vector2 position, {String weaponType = 'fist'}) {
    brutalBloodSplatter(position, intensity: 3);

    // Bone fragments
    for (int i = 0; i < 4; i++) {
      GangWarsGame.instance.add(
        RectangleComponent(
          position: position,
          size: Vector2(2, 4),
          angle: _random.nextDouble() * pi * 2,
          paint: Paint()..color = Colors.white,
          anchor: Anchor.center,
        )
          ..addAll([
            MoveEffect.by(
              Vector2(
                (_random.nextDouble() - 0.5) * 120,
                -_random.nextDouble() * 150,
              ),
              EffectController(duration: 0.5),
            ),
            OpacityEffect.fadeOut(EffectController(duration: 0.5)),
            RemoveEffect(delay: 0.5),
          ])
      );
    }

    GangWarsGame.instance.shakeScreen(intensity: 10);
  }

  /// Death animation with maximum gore
  static void deathAnimation(Vector2 position) {
    brutalBloodSplatter(position, intensity: 5);
    gibExplosion(position, gibCount: 18);
    GangWarsGame.instance.shakeScreen(intensity: 18, duration: const Duration(milliseconds: 500));

    // Ground blood pool
    GangWarsGame.instance.add(
      CircleComponent(
        position: position + Vector2(0, 10),
        radius: 35,
        paint: Paint()..color = const Color(0x99440000),
        anchor: Anchor.center,
      )
        ..addAll([
          ScaleEffect.by(Vector2.all(1.8), EffectController(duration: 1.5, curve: Curves.easeOutCubic)),
          OpacityEffect.to(0.6, EffectController(duration: 1.5)),
        ])
    );
  }

  /// Screen blood splatters that stay on screen
  static void screenBloodSplatter() {
    final count = 3 + _random.nextInt(5);

    for (int i = 0; i < count; i++) {
      final pos = Vector2(
        _random.nextDouble() * GangWarsGame.instance.size.x,
        _random.nextDouble() * GangWarsGame.instance.size.y,
      );

      GangWarsGame.instance.add(
        CircleComponent(
          position: pos,
          radius: 8 + _random.nextDouble() * 15,
          paint: Paint()..color = const Color(0xAA8B0000),
          anchor: Anchor.center,
        )
          ..addAll([
            ScaleEffect.by(Vector2.all(0.7), EffectController(duration: 0.2)),
            OpacityEffect.fadeOut(EffectController(duration: 8.0, startDelay: 2.0)),
            RemoveEffect(delay: 10.0),
          ])
      );
    }
  }

  /// Explosion with fire and shrapnel
  static void massiveExplosion(Vector2 position) {
    GangWarsGame.instance.createExplosion(position, ExplosionType.large);

    // Fireball
    GangWarsGame.instance.add(
      CircleComponent(
        position: position,
        radius: 40,
        paint: Paint()..color = Colors.orangeAccent,
        anchor: Anchor.center,
      )
        ..addAll([
          ScaleEffect.by(Vector2.all(3.5), EffectController(duration: 0.3)),
          OpacityEffect.fadeOut(EffectController(duration: 0.3)),
          RemoveEffect(delay: 0.3),
        ])
    );

    GangWarsGame.instance.shakeScreen(intensity: 25, duration: const Duration(milliseconds: 600));

    // Shockwave
    GangWarsGame.instance.add(
      CircleComponent(
        position: position,
        radius: 10,
        paint: Paint()
          ..color = Colors.white.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
        anchor: Anchor.center,
      )
        ..addAll([
          ScaleEffect.by(Vector2.all(15), EffectController(duration: 0.5)),
          OpacityEffect.fadeOut(EffectController(duration: 0.5)),
          RemoveEffect(delay: 0.5),
        ])
    );
  }
}