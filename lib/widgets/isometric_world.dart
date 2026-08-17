import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'procedural_3d_terrain.dart';

/// Flame Game Component for the 3D Isometric Open World
class IsometricOpenWorld extends FlameGame {
  late IsometricWorldPainterComponent _worldPainter;
  late IsometricJoystickComponent _joystick;
  late IsometricCamera _isoCamera;

  final Function(String)? onEnterBuilding;
  IsometricWorldData? worldData;
  Procedural3DTerrain? terrain;
  
  // Track the last building we were "near" to avoid spamming dialogs
  String? _lastNearbyBuilding;
  double _entryCooldown = 0;

  /// Custom isometric camera (separate from Flame's CameraComponent)
  IsometricCamera get isoCamera => _isoCamera;

  /// Apply offset for rendering via the camera
  Offset get cameraOffset => _isoCamera.offset;
  double get cameraZoom => _isoCamera.zoom;

  IsometricOpenWorld({this.onEnterBuilding});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize terrain generator
    terrain = Procedural3DTerrain(seed: DateTime.now().millisecondsSinceEpoch);

    // Generate the 3D isometric world data
    worldData = terrain!.generateWorld(
      mapWidth: 32,
      mapHeight: 32,
      tileWidth: 48.0,
      tileHeight: 28.0,
      baseHeight: 40.0,
    );

    // Add the world painter component
    _worldPainter = IsometricWorldPainterComponent(
      worldData: worldData!,
      size: size,
    );
    await add(_worldPainter);

    // Add the isometric camera
    _isoCamera = IsometricCamera(worldData: worldData!, screenSize: size);
    await add(_isoCamera);

    // Joystick for movement
    final knobPaint = Paint()..color = BasicPalette.blue.color.withValues(alpha: 0.78);
    final backgroundPaint = Paint()..color = BasicPalette.blue.color.withValues(alpha: 0.39);
    _joystick = IsometricJoystickComponent(
      isometricCamera: _isoCamera,
      knob: CircleComponent(radius: 25, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    await add(_joystick);

    _addWorldEntities();
  }

  void _addWorldEntities() {
    if (worldData == null) return;

    // Add animated NPCs
    for (final npc in worldData!.npcs) {
      add(
        IsometricNPCComponent(
          npc: npc,
          worldData: worldData!,
          tileWidth: 48.0,
          tileHeight: 28.0,
        ),
      );
    }
    
    // Add Items
    for (final item in worldData!.items) {
       add(
        IsometricItemComponent(
          item: item,
          tileWidth: 48.0,
          tileHeight: 28.0,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update camera
    _isoCamera.update(dt);
    
    if (_entryCooldown > 0) {
      _entryCooldown -= dt;
    } else {
      _checkBuildingInteraction();
    }
  }
  
  void _checkBuildingInteraction() {
    if (worldData == null || onEnterBuilding == null) return;
    
    // The "player" position is the center of the screen relative to the world offset
    final playerWorldX = size.x / 2 - _isoCamera.offset.dx;
    final playerWorldY = size.y / 2 - _isoCamera.offset.dy;
    
    String? currentNearby;
    for (final building in worldData!.buildings) {
      final dx = playerWorldX - building.screenX;
      final dy = playerWorldY - building.screenY;
      final distance = math.sqrt(dx * dx + dy * dy);
      
      // If close to a building (approx one tile width)
      if (distance < 40.0) {
        currentNearby = building.type;
        break;
      }
    }
    
    if (currentNearby != null && currentNearby != _lastNearbyBuilding) {
      _lastNearbyBuilding = currentNearby;
      _entryCooldown = 2.0; // 2 second cooldown before another check
      onEnterBuilding!(currentNearby);
    } else if (currentNearby == null) {
      _lastNearbyBuilding = null;
    }
  }

  /// Regenerate the world with a new seed
  void regenerateWorld() {
    terrain = Procedural3DTerrain(seed: DateTime.now().millisecondsSinceEpoch);
    worldData = terrain!.generateWorld(
      mapWidth: 32,
      mapHeight: 32,
      tileWidth: 48.0,
      tileHeight: 28.0,
      baseHeight: 40.0,
    );

    // Remove old components
    children.whereType<IsometricNPCComponent>().forEach((c) => c.removeFromParent());
    children.whereType<IsometricItemComponent>().forEach((c) => c.removeFromParent());
    _worldPainter.removeFromParent();

    // Re-add components
    _worldPainter = IsometricWorldPainterComponent(
      worldData: worldData!,
      size: size,
    );
    add(_worldPainter);
    _addWorldEntities();
    
    _lastNearbyBuilding = null;
    _entryCooldown = 0;
  }
}

/// Custom painter component for the isometric world
class IsometricWorldPainterComponent extends PositionComponent {
  final IsometricWorldData worldData;
  final Paint _paint = Paint();
  final Paint _edgePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5;
  final Paint _shadowPaint = Paint();
  final Paint _sidePaint = Paint();

  IsometricWorldPainterComponent({
    required this.worldData,
    required Vector2 size,
  }) : super(size: size);

  @override
  void render(Canvas canvas) {
    _drawTiles(canvas);
    _drawProps(canvas);
    _drawBuildings(canvas);
  }

  void _drawTiles(Canvas canvas) {
    // Sort tiles by depth (painter's algorithm - back to front)
    final sortedTiles = List<IsometricTile>.from(worldData.tiles)
      ..sort(
        (a, b) =>
            Procedural3DTerrain.depthSortKey(
              a.gridX,
              a.gridY,
              a.elevation,
            ).compareTo(
              Procedural3DTerrain.depthSortKey(b.gridX, b.gridY, b.elevation),
            ),
      );

    for (final tile in sortedTiles) {
      final cx = tile.screenX;
      final cy = tile.screenY;
      final hw = tile.tileWidth / 2;
      final hh = tile.tileHeight / 2;

      // Top surface diamond
      final path = Path();
      path.moveTo(cx, cy - hh);
      path.lineTo(cx + hw, cy);
      path.lineTo(cx, cy + hh);
      path.lineTo(cx - hw, cy);
      path.close();

      _paint.style = PaintingStyle.fill;
      _paint.color = tile.surfaceColor;
      canvas.drawPath(path, _paint);

      // Side faces for elevation
      final elev = tile.worldHeight;
      if (elev > 1.0) {
        // Right side face
        final rightPath = Path();
        rightPath.moveTo(cx + hw, cy);
        rightPath.lineTo(cx + hw, cy + elev);
        rightPath.lineTo(cx, cy + hh + elev);
        rightPath.lineTo(cx, cy + hh);
        rightPath.close();

        _sidePaint.color = Color.fromARGB(
          255,
          (tile.surfaceColor.r * 255 * 0.7).round().clamp(0, 255),
          (tile.surfaceColor.g * 255 * 0.7).round().clamp(0, 255),
          (tile.surfaceColor.b * 255 * 0.7).round().clamp(0, 255),
        );
        canvas.drawPath(rightPath, _sidePaint);

        // Left side face
        final leftPath = Path();
        leftPath.moveTo(cx - hw, cy);
        leftPath.lineTo(cx - hw, cy + elev);
        leftPath.lineTo(cx, cy + hh + elev);
        leftPath.lineTo(cx, cy + hh);
        leftPath.close();

        _sidePaint.color = Color.fromARGB(
          255,
          (tile.surfaceColor.r * 255 * 0.85).round().clamp(0, 255),
          (tile.surfaceColor.g * 255 * 0.85).round().clamp(0, 255),
          (tile.surfaceColor.b * 255 * 0.85).round().clamp(0, 255),
        );
        canvas.drawPath(leftPath, _sidePaint);
      }

      // Edge border
      _edgePaint.color = Color.fromARGB(
        255,
        (tile.surfaceColor.r * 255 * 0.6).round().clamp(0, 255),
        (tile.surfaceColor.g * 255 * 0.6).round().clamp(0, 255),
        (tile.surfaceColor.b * 255 * 0.6).round().clamp(0, 255),
      );
      canvas.drawPath(path, _edgePaint);
    }
  }

  void _drawProps(Canvas canvas) {
    for (final prop in worldData.props) {
      // Shadow
      _shadowPaint.color = Colors.black.withValues(alpha: 0.15);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(prop.screenX + 2, prop.screenY + 2),
          width: prop.size * 1.5,
          height: prop.size * 0.5,
        ),
        _shadowPaint,
      );

      // Prop body
      _paint.style = PaintingStyle.fill;
      _paint.color = prop.color;
      canvas.drawCircle(Offset(prop.screenX, prop.screenY), prop.size, _paint);
    }
  }

  void _drawBuildings(Canvas canvas) {
    final windowPaint = Paint()..color = const Color(0xFFFFDD44);

    for (final building in worldData.buildings) {
      final bw = building.width;
      final bh = building.height;
      final cx = building.screenX;
      final cy = building.screenY;

      // Building left face
      final leftFace = Path();
      leftFace.moveTo(cx - bw / 2, cy);
      leftFace.lineTo(cx, cy + bh * 0.4);
      leftFace.lineTo(cx, cy);
      leftFace.close();
      _paint.color = Color.fromARGB(
        255,
        (building.color.r * 255 * 0.7).round().clamp(0, 255),
        (building.color.g * 255 * 0.7).round().clamp(0, 255),
        (building.color.b * 255 * 0.7).round().clamp(0, 255),
      );
      canvas.drawPath(leftFace, _paint);

      // Building front face
      final frontFace = Path();
      frontFace.moveTo(cx, cy + bh * 0.4);
      frontFace.lineTo(cx + bw / 2, cy);
      frontFace.lineTo(cx, cy - bh * 0.4);
      frontFace.close();
      _paint.color = building.color;
      canvas.drawPath(frontFace, _paint);

      // Building roof
      final roof = Path();
      roof.moveTo(cx - bw / 2 - 3, cy - bh * 0.15);
      roof.lineTo(cx, cy - bh / 2 - 4);
      roof.lineTo(cx + bw / 2 + 3, cy - bh * 0.15);
      roof.lineTo(cx, cy + bh * 0.1);
      roof.close();
      _paint.color = Color.fromARGB(
        255,
        (building.color.r * 255 * 0.85).round().clamp(0, 255),
        (building.color.g * 255 * 0.85).round().clamp(0, 255),
        (building.color.b * 255 * 0.85).round().clamp(0, 255),
      );
      canvas.drawPath(roof, _paint);

      // Windows on front face
      final winW = bw * 0.08;
      final winH = bh * 0.08;
      for (int i = -1; i <= 1; i += 2) {
        final wx = cx + i * bw * 0.25;
        final wy = cy - i * bh * 0.05;
        canvas.drawRect(
          Rect.fromCenter(center: Offset(wx, wy), width: winW, height: winH),
          windowPaint,
        );
      }
    }
  }
}

/// Isometric Camera component for pan and zoom
class IsometricCamera extends Component {
  Offset _offset = Offset.zero;
  double _zoom = 1.0;
  Offset _targetOffset = Offset.zero;
  double _targetZoom = 1.0;
  final IsometricWorldData worldData;
  final Vector2 screenSize;

  IsometricCamera({required this.worldData, required this.screenSize}) {
    // Center camera on the middle of the world
    final centerX = worldData.mapWidth * 24.0;
    final centerY = worldData.mapHeight * 14.0;
    _offset = Offset(screenSize.x / 2 - centerX, screenSize.y / 2 - centerY);
    _targetOffset = _offset;
  }

  Offset get offset => _offset;
  double get zoom => _zoom;

  void panBy(Offset delta) {
    _targetOffset += delta * (1.0 / _zoom);
  }

  void zoomBy(double factor) {
    _targetZoom = (_targetZoom * factor).clamp(0.3, 3.0);
  }

  void moveTo(Offset target) {
    _targetOffset = target;
  }

  @override
  void update(double dt) {
    // Smooth lerp for offset
    _offset = Offset(
      _offset.dx + (_targetOffset.dx - _offset.dx) * 8.0 * dt,
      _offset.dy + (_targetOffset.dy - _offset.dy) * 8.0 * dt,
    );

    // Smooth lerp for zoom
    _zoom += (_targetZoom - _zoom) * 6.0 * dt;
  }
}

/// Joystick component customized for isometric world navigation
class IsometricJoystickComponent extends JoystickComponent {
  final IsometricCamera isometricCamera;

  IsometricJoystickComponent({
    required this.isometricCamera,
    required super.knob,
    required super.background,
    super.margin,
  });

  @override
  void update(double dt) {
    super.update(dt);

    if (!relativeDelta.isZero()) {
      // Increased sensitivity and using relativeDelta for smoother response
      const panSpeed = 600.0;
      isometricCamera.panBy(
        Offset(-relativeDelta.x * panSpeed * dt, -relativeDelta.y * panSpeed * dt),
      );
    }
  }
}

/// Animated NPC component that moves around the isometric world
class IsometricNPCComponent extends PositionComponent {
  final IsometricNPC npc;
  final IsometricWorldData worldData;
  final double tileWidth;
  final double tileHeight;
  final math.Random _random = math.Random();
  double _moveTimer = 0;
  Offset _moveDirection = Offset.zero;
  double _animTimer = 0;
  bool _isMoving = false;
  double _drawX;
  double _drawY;
  final Paint _bodyPaint = Paint()..style = PaintingStyle.fill;
  final Paint _skinPaint = Paint()..style = PaintingStyle.fill;
  final Paint _shadowPaint = Paint();
  final Paint _legPaint = Paint();

  IsometricNPCComponent({
    required this.npc,
    required this.worldData,
    required this.tileWidth,
    required this.tileHeight,
  }) : _drawX = npc.screenX,
       _drawY = npc.screenY;

  @override
  void update(double dt) {
    super.update(dt);

    if (npc.isMoving) {
      _moveTimer += dt;
      _animTimer += dt;

      // Change direction every 2 to 4 seconds
      if (_moveTimer > 2.0 + _random.nextDouble() * 3.0) {
        _moveTimer = 0;
        final angle = _random.nextDouble() * 2 * math.pi;
        _moveDirection = Offset(math.cos(angle), math.sin(angle));
        _isMoving = true;
      }

      // Move the NPC
      if (_isMoving && _moveTimer < 2.0) {
        _drawX += _moveDirection.dx * 30.0 * dt;
        _drawY += _moveDirection.dy * 15.0 * dt;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final nx = _drawX;
    final ny = _drawY;

    // Shadow
    _shadowPaint.color = Colors.black.withValues(alpha: 0.12);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(nx + 1, ny + 1), width: 10, height: 4),
      _shadowPaint,
    );

    // Walking animation bob
    final walkBob = _isMoving ? math.sin(_animTimer * 8) * 1.5 : 0.0;

    // Legs
    _legPaint.color = Color.fromARGB(
      255,
      (npc.color.r * 255 * 0.7).round().clamp(0, 255),
      (npc.color.g * 255 * 0.7).round().clamp(0, 255),
      (npc.color.b * 255 * 0.7).round().clamp(0, 255),
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(nx - 2 + walkBob * 0.5, ny - walkBob),
        width: 3,
        height: 4,
      ),
      _legPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(nx + 2 - walkBob * 0.5, ny - walkBob),
        width: 3,
        height: 4,
      ),
      _legPaint,
    );

    // Body
    _bodyPaint.color = npc.color;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(nx, ny - 5 - walkBob),
        width: 6,
        height: 7,
      ),
      _bodyPaint,
    );

    // Head
    _skinPaint.color = const Color(0xFFDCB48C);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(nx, ny - 11 - walkBob),
        width: 5,
        height: 5,
      ),
      _skinPaint,
    );
  }
}

/// Item component for the isometric world
class IsometricItemComponent extends PositionComponent {
  final IsometricItem item;
  final double tileWidth;
  final double tileHeight;
  double _hoverTimer = 0;
  final Paint _paint = Paint()..style = PaintingStyle.fill;

  IsometricItemComponent({
    required this.item,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  void update(double dt) {
    super.update(dt);
    _hoverTimer += dt;
  }

  @override
  void render(Canvas canvas) {
    final ix = item.screenX;
    final iy = item.screenY + math.sin(_hoverTimer * 4) * 3;

    _paint.color = item.color;
    // Draw a small diamond for items
    final path = Path();
    const double s = 6.0;
    path.moveTo(ix, iy - s);
    path.lineTo(ix + s, iy);
    path.lineTo(ix, iy + s);
    path.lineTo(ix - s, iy);
    path.close();
    canvas.drawPath(path, _paint);

    // Add a glow
    final glowPaint = Paint()
      ..color = item.color.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawCircle(Offset(ix, iy), s * 1.5, glowPaint);
  }
}

/// Widget wrapper for the isometric open world Flame game
class IsometricOpenWorldWidget extends StatelessWidget {
  final Function(String)? onEnterBuilding;
  final VoidCallback? onExit;

  const IsometricOpenWorldWidget({
    super.key,
    this.onEnterBuilding,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget(
          game: IsometricOpenWorld(
            onEnterBuilding: (buildingType) {
              onEnterBuilding?.call(buildingType);
            },
          ),
        ),
        // Exit button overlay
        Positioned(
          top: 40,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => onExit?.call(),
            ),
          ),
        ),
      ],
    );
  }
}
