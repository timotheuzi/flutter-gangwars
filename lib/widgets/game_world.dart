import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/procedural_pixel_art.dart';

class GangwarWorld extends FlameGame
    with DragCallbacks, TapCallbacks, HasCollisionDetection {
  late PlayerComponent player;
  late JoystickComponent joystick;
  final Function(String) onEnterBuilding;

  GangwarWorld({required this.onEnterBuilding});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final generator = ProceduralPixelArt(seed: 42);

    // Add procedural background tiles
    for (int tx = 0; tx < 20; tx++) {
      for (int ty = 0; ty < 20; ty++) {
        final env = generator.generateEnvironment(
          type: EnvironmentType.city,
          variant: tx * 20 + ty,
        );
        add(
          EnvironmentTileComponent(
            environment: env,
            position: Vector2(tx.toDouble() * 256, ty.toDouble() * 256),
            pixelSize: 4.0,
          ),
        );
      }
    }

    // Add Buildings
    List<String> types = [
      'bank',
      'bar',
      'crackhouse',
      'gunshack',
      'alleyway',
    ];
    types.shuffle();
    List<Map<String, dynamic>> buildings = [];
    double currentX = 500;
    double currentY = 500;
    double spacing = 600;
    for (var type in types) {
      double offsetX = math.Random().nextDouble() * 200 - 100;
      double offsetY = math.Random().nextDouble() * 200 - 100;
      buildings.add({
        'type': type,
        'pos': Vector2(currentX + offsetX, currentY + offsetY),
      });
      currentX += spacing;
      if (currentX > 4000) {
        currentX = 500;
        currentY += spacing;
      }
    }

    for (var b in buildings) {
      add(
        BuildingComponent(
          type: b['type'] as String,
          position: b['pos'] as Vector2,
          onEnter: onEnterBuilding,
          generator: generator,
        ),
      );
    }

    // Add NPCs (Wandering)
    for (int i = 0; i < 50; i++) {
      CharacterType randomType = CharacterType
          .values[math.Random().nextInt(CharacterType.values.length)];
      add(
        NpcComponent(
          position: Vector2(
            100 + math.Random().nextDouble() * 4800,
            100 + math.Random().nextDouble() * 4800,
          ),
          character: generator.generateCharacter(type: randomType),
        ),
      );
    }

    // Initialize Player
    player = PlayerComponent();
    player.character = generator.generateCharacter(
      type: CharacterType.gangster,
    );
    add(player);

    // Camera follow
    camera.follow(player);

    // Joystick
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 25, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      player.move(joystick.relativeDelta, dt);
    }
  }
}

class EnvironmentTileComponent extends PositionComponent {
  final ProceduralEnvironment environment;
  final double pixelSize;

  EnvironmentTileComponent({
    required this.environment,
    required Vector2 position,
    required this.pixelSize,
  }) : super(position: position);

  @override
  void render(Canvas canvas) {
    final paint = Paint();
    for (int y = 0; y < environment.pixels.length; y++) {
      for (int x = 0; x < environment.pixels[y].length; x++) {
        if (environment.pixels[y][x] != Colors.transparent) {
          paint.color = environment.pixels[y][x];
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }
}

class PlayerComponent extends PositionComponent with CollisionCallbacks {
  static const double speed = 300.0;
  ProceduralCharacter? character;
  int currentFrame = 0;
  double frameTimer = 0;
  AnimationType currentAnimationType = AnimationType.idle;
  double pixelSize = 3.0;

  PlayerComponent() {
    size = Vector2(48, 48);
    anchor = Anchor.center;
    position = Vector2(100, 100);
    add(RectangleHitbox());
  }

  void move(Vector2 delta, double dt) {
    position.add(delta * speed * dt);
    position.x = position.x.clamp(24, 4976);
    position.y = position.y.clamp(24, 4976);

    if (delta.x > 0) {
      scale.x = 1;
    } else if (delta.x < 0) {
      scale.x = -1;
    }

    if (delta.isZero()) {
      currentAnimationType = AnimationType.idle;
    } else {
      currentAnimationType = AnimationType.walk;
    }

    frameTimer += dt * 1000;
    if (character != null) {
      var animation = character!.animations.firstWhere(
        (a) => a.type == currentAnimationType,
        orElse: () => character!.animations.first,
      );
      if (frameTimer >= animation.frameDuration) {
        frameTimer = 0;
        currentFrame = (currentFrame + 1) % animation.frames.length;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (character == null) return;

    var animation = character!.animations.firstWhere(
      (a) => a.type == currentAnimationType,
      orElse: () => character!.animations.first,
    );
    var frame = animation.frames[currentFrame];

    for (int y = 0; y < frame.length; y++) {
      for (int x = 0; x < frame[y].length; x++) {
        if (frame[y][x] != Colors.transparent) {
          final paint = Paint()..color = frame[y][x];
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }
}

class BuildingComponent extends PositionComponent with CollisionCallbacks {
  final String type;
  final Function(String) onEnter;
  final ProceduralPixelArt generator;
  late ProceduralBuilding building;
  bool isPlayerInside = false;
  double pixelSize = 4.0;

  BuildingComponent({
    required this.type,
    required Vector2 position,
    required this.onEnter,
    required this.generator,
  }) {
    this.position = position;
    size = Vector2(128, 128);
    anchor = Anchor.center;
    building = generator.generateBuilding(type: _getBuildingType(type));
    add(
      RectangleHitbox(size: Vector2(64, 38), position: Vector2(32, 90)),
    ); // Entrance area
  }

  BuildingType _getBuildingType(String t) {
    return switch (t) {
      'bank' => BuildingType.bank,
      'bar' => BuildingType.bar,
      'crackhouse' => BuildingType.crackhouse,
      'gunshack' => BuildingType.gunshack,
      'alleyway' => BuildingType.alleyway,
      _ => BuildingType.crackhouse,
    };
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerComponent && !isPlayerInside) {
      isPlayerInside = true;
      onEnter(type);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is PlayerComponent) {
      isPlayerInside = false;
    }
  }

  @override
  void render(Canvas canvas) {
    for (int y = 0; y < building.pixels.length; y++) {
      for (int x = 0; x < building.pixels[y].length; x++) {
        if (building.pixels[y][x] != Colors.transparent) {
          final paint = Paint()..color = building.pixels[y][x];
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }
}

class NpcComponent extends PositionComponent with CollisionCallbacks {
  double timer = 0;
  Vector2 direction = Vector2(1, 0);
  final ProceduralCharacter character;
  int currentFrame = 0;
  double frameTimer = 0;
  AnimationType currentAnimationType = AnimationType.walk;
  double pixelSize = 3.0;

  NpcComponent({required Vector2 position, required this.character}) {
    this.position = position;
    size = Vector2(48, 48);
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer += dt;
    if (timer > 2 + math.Random().nextDouble() * 2) {
      timer = 0;
      final angle = math.Random().nextDouble() * 2 * math.pi;
      direction = Vector2(math.cos(angle), math.sin(angle));
    }
    position.add(direction * 80 * dt);

    // Bounce off walls
    if (position.x < 50 || position.x > 4950) direction.x *= -1;
    if (position.y < 50 || position.y > 4950) direction.y *= -1;

    position.x = position.x.clamp(50, 4950);
    position.y = position.y.clamp(50, 4950);

    if (direction.x < 0) {
      scale.x = -1;
    } else {
      scale.x = 1;
    }

    frameTimer += dt * 1000;
    var animation = character.animations.firstWhere(
      (a) => a.type == currentAnimationType,
      orElse: () => character.animations.first,
    );
    if (frameTimer >= animation.frameDuration) {
      frameTimer = 0;
      currentFrame = (currentFrame + 1) % animation.frames.length;
    }
  }

  @override
  void render(Canvas canvas) {
    var animation = character.animations.firstWhere(
      (a) => a.type == currentAnimationType,
      orElse: () => character.animations.first,
    );
    var frame = animation.frames[currentFrame];

    for (int y = 0; y < frame.length; y++) {
      for (int x = 0; x < frame[y].length; x++) {
        if (frame[y][x] != Colors.transparent) {
          final paint = Paint()..color = frame[y][x];
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }
}
