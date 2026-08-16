import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame/text.dart';
import 'dart:math';
import 'dart:ui' as ui;

enum GameScene { mainMenu, openWorld, room, combat }

/// Main Flame Game instance for all game animations and 3D rendering
class GangWarsGame extends FlameGame {
  final Random _random = Random();
  
  static final GangWarsGame instance = GangWarsGame._internal();
  GangWarsGame._internal() : super(
    camera: CameraComponent.withFixedResolution(width: 1920, height: 1080),
  );

  GameScene currentScene = GameScene.mainMenu;
  final world3D = World3DRenderer();

  @override
  Color backgroundColor() => Colors.black;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(world3D);
  }

  void setScene(GameScene scene) {
    currentScene = scene;
    world3D.onSceneChanged(scene);
  }

  /// Create explosion effect
  void createExplosion(Vector2 position, ExplosionType type) {
    if (!GraphicalSettings.instance.enableParticles) return;

    final particleCount = switch (type) {
      ExplosionType.small => 12,
      ExplosionType.medium => 25,
      ExplosionType.large => 50,
      ExplosionType.fire => 35,
      ExplosionType.smoke => 18,
    };

    final colors = switch (type) {
      ExplosionType.small => [Colors.orange, Colors.yellow],
      ExplosionType.medium => [Colors.red, Colors.orange, Colors.yellow],
      ExplosionType.large => [Colors.deepOrange, Colors.red, Colors.yellow, Colors.white],
      ExplosionType.fire => [Colors.yellow, Colors.orange, Colors.red],
      ExplosionType.smoke => [Colors.grey, Colors.blueGrey, Colors.black38],
    };

    world.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: particleCount,
          generator: (i) => AcceleratedParticle(
            position: Vector2.zero(),
            speed: Vector2(
              (_random.nextDouble() - 0.5) * 500,
              (_random.nextDouble() - 0.5) * 500,
            ),
            acceleration: Vector2(0, 200),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final paint = Paint()
                  ..color = colors[_random.nextInt(colors.length)]
                      .withValues(alpha: 1 - particle.progress);
                canvas.drawCircle(
                  Offset.zero,
                  5 + _random.nextDouble() * 10,
                  paint,
                );
              },
            ),
            lifespan: 0.8 + _random.nextDouble() * 0.8,
          ),
        ),
      ),
    );
  }

  /// Show damage number popups
  void showDamageNumber(Vector2 position, int damage, bool isCritical) {
    final textComponent = TextComponent(
      text: '-$damage',
      position: position,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: isCritical ? Colors.redAccent : Colors.orangeAccent,
          fontSize: isCritical ? 52 : 40,
          fontWeight: isCritical ? FontWeight.bold : FontWeight.w600,
          fontFamily: 'PixelArt',
          shadows: [const Shadow(blurRadius: 5, color: Colors.black, offset: Offset(3, 3))],
        ),
      ),
    );

    textComponent.addAll([
      MoveEffect.by(
        Vector2(0, -120),
        EffectController(duration: 1.5, curve: Curves.easeOutCubic),
      ),
      OpacityEffect.fadeOut(EffectController(duration: 1.5)),
      RemoveEffect(delay: 1.5),
    ]);

    world.add(textComponent);
  }

  /// Screen shake effect
  void shakeScreen({double intensity = 15.0, Duration duration = const Duration(milliseconds: 300)}) {
    camera.viewfinder.add(
      MoveEffect.by(
        Vector2(
          _random.nextDouble() * intensity - intensity/2,
          _random.nextDouble() * intensity - intensity/2
        ),
        EffectController(
          duration: duration.inMilliseconds / 1000,
          alternate: true,
          repeatCount: 6,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}

enum ExplosionType { small, medium, large, fire, smoke }

/// Global Graphical Settings Manager
class GraphicalSettings {
  static final GraphicalSettings instance = GraphicalSettings._internal();
  GraphicalSettings._internal();

  QualityLevel qualityLevel = QualityLevel.high;
  int targetFps = 60;
  bool enableParticles = true;
  bool enableShadows = true;
  bool enableVibrantEffects = true;
  double animationSpeed = 1.0;
  bool vsyncEnabled = true;

  void setQuality(QualityLevel level) {
    qualityLevel = level;
    switch (level) {
      case QualityLevel.low:
        targetFps = 30;
        enableParticles = false;
        enableShadows = false;
        enableVibrantEffects = false;
        break;
      case QualityLevel.medium:
        targetFps = 45;
        enableParticles = true;
        enableShadows = false;
        enableVibrantEffects = true;
        break;
      case QualityLevel.high:
        targetFps = 60;
        enableParticles = true;
        enableShadows = true;
        enableVibrantEffects = true;
        break;
      case QualityLevel.ultra:
        targetFps = 120;
        enableParticles = true;
        enableShadows = true;
        enableVibrantEffects = true;
        break;
    }
  }
}

enum QualityLevel { low, medium, high, ultra }

/// A Procedural 3D-like World Component for Open World and Rooms
class World3DRenderer extends Component with HasGameReference<GangWarsGame> {
  final Random _rnd = Random();
  GameScene _currentScene = GameScene.mainMenu;
  
  // World data
  final List<Building3D> _buildings = [];
  final List<DungeonWall> _dungeonWalls = [];
  
  void onSceneChanged(GameScene scene) {
    _currentScene = scene;
    if (scene == GameScene.openWorld) {
      _generateProceduralCity();
    } else if (scene == GameScene.room) {
      _generateDungeonRoom();
    }
  }

  void _generateProceduralCity() {
    _buildings.clear();
    for (int i = 0; i < 100; i++) {
      _buildings.add(Building3D(
        position: Vector2(_rnd.nextDouble() * 10000 - 5000, _rnd.nextDouble() * 5000 - 2500),
        height: 400 + _rnd.nextDouble() * 1200,
        width: 200 + _rnd.nextDouble() * 400,
        color: Color.fromARGB(255, _rnd.nextInt(30) + 10, _rnd.nextInt(30) + 10, _rnd.nextInt(80) + 40),
      ));
    }
    // Sort by distance (y) for simple painter's algorithm
    _buildings.sort((a, b) => b.position.y.compareTo(a.position.y));
  }

  void _generateDungeonRoom() {
    _dungeonWalls.clear();
    // Simple 3D room walls
    _dungeonWalls.add(DungeonWall(start: Vector2(-500, -500), end: Vector2(500, -500), color: Colors.grey.shade900)); // Back
    _dungeonWalls.add(DungeonWall(start: Vector2(-500, -500), end: Vector2(-500, 500), color: Colors.grey.shade800)); // Left
    _dungeonWalls.add(DungeonWall(start: Vector2(500, -500), end: Vector2(500, 500), color: Colors.grey.shade800)); // Right
  }

  @override
  void render(Canvas canvas) {
    final size = game.size;
    
    if (_currentScene == GameScene.mainMenu) {
      _renderSpace(canvas, size);
    } else if (_currentScene == GameScene.openWorld) {
      _renderOpenWorld(canvas, size);
    } else if (_currentScene == GameScene.room) {
      _renderRoom(canvas, size);
    }
  }

  void _renderSpace(Canvas canvas, Vector2 size) {
     final paint = Paint()..shader = ui.Gradient.linear(
      Offset.zero,
      Offset(0, size.y),
      [const Color(0xFF000022), const Color(0xFF000000)],
    );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    
    // Stars
    final starPaint = Paint()..color = Colors.white;
    for(int i=0; i<100; i++) {
      final r = Random(i);
      canvas.drawCircle(Offset(r.nextDouble() * size.x, r.nextDouble() * size.y), 1, starPaint);
    }
  }

  void _renderOpenWorld(Canvas canvas, Vector2 size) {
    // Sky
    final skyPaint = Paint()..shader = ui.Gradient.linear(
      Offset.zero,
      Offset(0, size.y * 0.6),
      [Colors.black, Colors.indigo.shade900, Colors.purple.shade900],
    );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y * 0.6), skyPaint);

    // Ground (City Road)
    final roadPaint = Paint()..color = const Color(0xFF151515);
    canvas.drawRect(Rect.fromLTWH(0, size.y * 0.6, size.x, size.y * 0.4), roadPaint);

    // Grid lines for perspective
    final gridPaint = Paint()..color = Colors.white10..strokeWidth = 2;
    for (int i = -10; i <= 10; i++) {
       canvas.drawLine(
         Offset(size.x / 2 + i * 200, size.y * 0.6),
         Offset(size.x / 2 + i * 1000, size.y),
         gridPaint
       );
    }

    // Buildings
    for (var b in _buildings) {
      _renderBuilding(canvas, b, size);
    }
  }

  void _renderBuilding(Canvas canvas, Building3D b, Vector2 size) {
    final horizon = size.y * 0.6;
    final scale = 1.0 / (1.0 + (b.position.y + 2500) / 5000);
    
    final screenX = size.x / 2 + b.position.x * scale;
    final screenY = horizon + b.position.y * scale * 0.2;
    
    final w = b.width * scale;
    final h = b.height * scale;

    final rect = Rect.fromLTWH(screenX - w/2, screenY - h, w, h);
    
    // Simple 3D depth (side face)
    final sidePaint = Paint()..color = b.color.withValues(alpha: 0.7);
    final sidePath = Path()
      ..moveTo(rect.right, rect.top)
      ..lineTo(rect.right + 20 * scale, rect.top - 10 * scale)
      ..lineTo(rect.right + 20 * scale, rect.bottom - 10 * scale)
      ..lineTo(rect.right, rect.bottom)
      ..close();
    canvas.drawPath(sidePath, sidePaint);

    // Front face
    canvas.drawRect(rect, Paint()..color = b.color);
    
    // Windows
    final winPaint = Paint()..color = Colors.yellow.withValues(alpha: 0.4);
    if (scale > 0.2) {
      for(int row=0; row<8; row++) {
        for(int col=0; col<4; col++) {
          if (Random((b.position.x + row*10 + col).toInt()).nextDouble() > 0.4) {
             canvas.drawRect(
               Rect.fromLTWH(
                 rect.left + 10 * scale + col * (w/5),
                 rect.top + 10 * scale + row * (h/10),
                 w/10, h/15
               ),
               winPaint
             );
          }
        }
      }
    }
  }

  void _renderRoom(Canvas canvas, Vector2 size) {
    // Floor
    final floorPaint = Paint()..color = Colors.grey.shade900;
    final floorPath = Path()
      ..moveTo(0, size.y)
      ..lineTo(size.x, size.y)
      ..lineTo(size.x * 0.8, size.y * 0.7)
      ..lineTo(size.x * 0.2, size.y * 0.7)
      ..close();
    canvas.drawPath(floorPath, floorPaint);

    // Ceiling
    final ceilPaint = Paint()..color = Colors.black;
    final ceilPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.x, 0)
      ..lineTo(size.x * 0.8, size.y * 0.3)
      ..lineTo(size.x * 0.2, size.y * 0.3)
      ..close();
    canvas.drawPath(ceilPath, ceilPaint);

    // Walls
    final wallPaint = Paint()..color = Colors.grey.shade800;
    // Left Wall
    final leftWall = Path()
      ..moveTo(0, 0)
      ..lineTo(size.x * 0.2, size.y * 0.3)
      ..lineTo(size.x * 0.2, size.y * 0.7)
      ..lineTo(0, size.y)
      ..close();
    canvas.drawPath(leftWall, wallPaint);

    // Right Wall
    final rightWall = Path()
      ..moveTo(size.x, 0)
      ..lineTo(size.x * 0.8, size.y * 0.3)
      ..lineTo(size.x * 0.8, size.y * 0.7)
      ..lineTo(size.x, size.y)
      ..close();
    canvas.drawPath(rightWall, wallPaint);

    // Back Wall
    final backWall = Rect.fromLTRB(size.x * 0.2, size.y * 0.3, size.x * 0.8, size.y * 0.7);
    canvas.drawRect(backWall, Paint()..color = Colors.grey.shade900);
    
    // Add some "dungeon" details
    final detailPaint = Paint()..color = Colors.red.withValues(alpha: 0.2)..strokeWidth = 2..style = PaintingStyle.stroke;
    canvas.drawRect(backWall, detailPaint);
    
    // Graffiti
    final textPainter = TextPainter(
      text: const TextSpan(text: "GANG TERRITORY", style: TextStyle(color: Colors.red, fontSize: 40, fontFamily: 'PixelArt')),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.x * 0.5 - textPainter.width/2, size.y * 0.5 - textPainter.height/2));
  }
}

class Building3D {
  final Vector2 position;
  final double height;
  final double width;
  final Color color;
  Building3D({required this.position, required this.height, required this.width, required this.color});
}

class DungeonWall {
  final Vector2 start;
  final Vector2 end;
  final Color color;
  DungeonWall({required this.start, required this.end, required this.color});
}

/// Wrapper widget to place Flame game overlay on all screens
class FlameGameOverlay extends StatelessWidget {
  final Widget child;

  const FlameGameOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GameWidget<GangWarsGame>(
            game: GangWarsGame.instance,
          ),
        ),
        // Overlay the standard UI
        Positioned.fill(child: child),
      ],
    );
  }
}
