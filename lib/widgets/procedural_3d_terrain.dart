import 'dart:math';
import 'package:flutter/material.dart';

/// 3D Procedural Terrain System for Gang Wars
/// Generates height maps and renders isometric/pseudo-3D terrain
class Procedural3DTerrain {
  final Random _random;
  final int seed;

  Procedural3DTerrain({int? seed})
      : seed = seed ?? DateTime.now().millisecondsSinceEpoch,
        _random = Random(seed ?? DateTime.now().millisecondsSinceEpoch);

  /// Generate a height map using simplex-like noise
  ProceduralHeightMap generateHeightMap({
    int width = 64,
    int height = 64,
    double frequency = 0.05,
    int octaves = 4,
    double persistence = 0.5,
    double lacunarity = 2.0,
    double heightScale = 1.0,
  }) {
    final elevations = List.generate(height, (_) => List.filled(width, 0.0));

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        double noiseVal = 0.0;
        double amplitude = 1.0;
        double freq = frequency;
        double maxVal = 0.0;

        for (int o = 0; o < octaves; o++) {
          noiseVal += _noise2D(x * freq, y * freq) * amplitude;
          maxVal += amplitude;
          amplitude *= persistence;
          freq *= lacunarity;
        }

        elevations[y][x] = (noiseVal / maxVal) * heightScale;
      }
    }

    return ProceduralHeightMap(
      width: width,
      height: height,
      elevations: elevations,
      seed: seed,
      frequency: frequency,
      octaves: octaves,
      persistence: persistence,
      lacunarity: lacunarity,
    );
  }

  /// Generate isometric tile data from a height map
  List<IsometricTile> generateIsometricTiles({
    required ProceduralHeightMap heightMap,
    required double tileWidth,
    required double tileHeight,
    required double baseHeight,
  }) {
    final tiles = <IsometricTile>[];
    final width = heightMap.width;
    final height = heightMap.height;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final elevation = heightMap.elevations[y][x];
        final screenX = (x - y) * (tileWidth / 2);
        final screenY = (x + y) * (tileHeight / 2) - elevation * baseHeight;

        Color surfaceColor = _getTerrainColor(elevation, x, y);
        Color edgeColor = _getEdgeColor(surfaceColor);

        tiles.add(
          IsometricTile(
            gridX: x,
            gridY: y,
            screenX: screenX,
            screenY: screenY,
            elevation: elevation,
            baseHeight: baseHeight,
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            surfaceColor: surfaceColor,
            edgeColor: edgeColor,
            type: _getTerrainType(elevation),
          ),
        );
      }
    }

    return tiles;
  }

  /// Generate a complete isometric world with structures
  IsometricWorldData generateWorld({
    int mapWidth = 32,
    int mapHeight = 32,
    double tileWidth = 48.0,
    double tileHeight = 28.0,
    double baseHeight = 40.0,
  }) {
    final heightMap = generateHeightMap(
      width: mapWidth,
      height: mapHeight,
      frequency: 0.06,
      octaves: 3,
      persistence: 0.5,
      heightScale: 3.0,
    );

    final tiles = generateIsometricTiles(
      heightMap: heightMap,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      baseHeight: baseHeight,
    );

    final buildings = _generateBuildings(tiles, tileWidth, tileHeight);
    final npcs = _generateNPCs(tiles, tileWidth, tileHeight);
    final props = _generateProps(tiles, tileWidth, tileHeight);

    return IsometricWorldData(
      tiles: tiles,
      buildings: buildings,
      npcs: npcs,
      props: props,
      mapWidth: mapWidth,
      mapHeight: mapHeight,
    );
  }

  /// Convert grid coords to isometric screen coords
  static Offset gridToIso(int x, int y, double tileW, double tileH) {
    return Offset((x - y) * (tileW / 2), (x + y) * (tileH / 2));
  }

  /// Convert screen coords to grid coords (inverse isometric)
  static Offset isoToGrid(Offset screen, double tileW, double tileH) {
    final gx = (screen.dx / (tileW / 2) + screen.dy / (tileH / 2)) / 2;
    final gy = (screen.dy / (tileH / 2) - screen.dx / (tileW / 2)) / 2;
    return Offset(gx, gy);
  }

  /// Get depth sort key for isometric rendering (back-to-front)
  static double depthSortKey(int x, int y, double elevation) {
    return x + y + elevation * 0.1;
  }

  // ---------- PRIVATE HELPERS ----------

  double _noise2D(double x, double y) {
    // Simple value noise as fallback if no Perlin/Simplex library
    final ix = x.floor();
    final iy = y.floor();
    final fx = x - ix;
    final fy = y - iy;

    final nw = _hash(ix, iy);
    final ne = _hash(ix + 1, iy);
    final sw = _hash(ix, iy + 1);
    final se = _hash(ix + 1, iy + 1);

    final ux = _smoothstep(fx);
    final uy = _smoothstep(fy);

    final top = _lerp(nw, ne, ux);
    final bottom = _lerp(sw, se, ux);
    return _lerp(top, bottom, uy);
  }

  double _hash(int x, int y) {
    int h = seed + x * 374761393 + y * 668265263;
    h = (h ^ (h >> 13)) * 1274126177;
    h = h ^ (h >> 16);
    return (h & 0x7FFFFFFF) / 0x7FFFFFFF;
  }

  double _smoothstep(double t) {
    return t * t * (3 - 2 * t);
  }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  Color _getTerrainColor(double elevation, int x, int y) {
    // Color based on elevation
    if (elevation < 0.3) {
      return Color.fromARGB(255, 50, 120, 50); // Grass
    } else if (elevation < 0.8) {
      return Color.fromARGB(255, 40, 100, 40); // Dark grass
    } else if (elevation < 1.5) {
      return Color.fromARGB(255, 80, 70, 50); // Dirt/hill
    } else if (elevation < 2.2) {
      return Color.fromARGB(255, 100, 90, 70); // Rock
    } else {
      return Color.fromARGB(255, 70, 70, 70); // Stone/mountain
    }
  }

  Color _getEdgeColor(Color surface) {
    return Color.fromARGB(
      255,
      (surface.r * 0.7).round().clamp(0, 255),
      (surface.g * 0.7).round().clamp(0, 255),
      (surface.b * 0.7).round().clamp(0, 255),
    );
  }

  TerrainType _getTerrainType(double elevation) {
    if (elevation < 0.3) return TerrainType.grass;
    if (elevation < 0.8) return TerrainType.darkGrass;
    if (elevation < 1.5) return TerrainType.hill;
    if (elevation < 2.2) return TerrainType.rock;
    return TerrainType.mountain;
  }

  List<IsometricBuilding> _generateBuildings(
    List<IsometricTile> tiles,
    double tileW,
    double tileH,
  ) {
    final buildings = <IsometricBuilding>[];
    final buildingTypes = ['bank', 'bar', 'crackhouse', 'gunshack', 'house'];

    // Place buildings on relatively flat terrain
    final suitableTiles = tiles
        .where(
          (t) =>
              t.elevation > 0.2 &&
              t.elevation < 1.0 &&
              t.gridX > 2 &&
              t.gridX < 29 &&
              t.gridY > 2 &&
              t.gridY < 29,
        )
        .toList();

    suitableTiles.shuffle(_random);

    final count = min(
      buildingTypes.length + _random.nextInt(3),
      suitableTiles.length,
    );
    for (int i = 0; i < count; i++) {
      final tile = suitableTiles[i];
      final type = buildingTypes[i % buildingTypes.length];

      buildings.add(
        IsometricBuilding(
          type: type,
          gridX: tile.gridX,
          gridY: tile.gridY,
          screenX: tile.screenX,
          screenY: tile.screenY - tile.elevation * tile.baseHeight,
          width: tileW * 1.5,
          height: tileH * 2.0,
          color: _getBuildingColor(type),
        ),
      );
    }

    return buildings;
  }

  Color _getBuildingColor(String type) {
    switch (type) {
      case 'bank':
        return const Color(0xFFD4AF37); // Gold
      case 'bar':
        return const Color(0xFF8B4513); // Brown
      case 'crackhouse':
        return const Color(0xFF4A4A4A); // Dark grey
      case 'gunshack':
        return const Color(0xFF6B4226); // Dark brown
      default:
        return const Color(0xFF808080); // Grey
    }
  }

  List<IsometricNPC> _generateNPCs(
    List<IsometricTile> tiles,
    double tileW,
    double tileH,
  ) {
    final npcs = <IsometricNPC>[];
    final walkableTiles =
        tiles.where((t) => t.elevation > 0.1 && t.elevation < 1.2).toList();

    walkableTiles.shuffle(_random);

    final count = min(15 + _random.nextInt(10), walkableTiles.length);
    for (int i = 0; i < count; i++) {
      final tile = walkableTiles[i];
      final npcType = _random.nextInt(5);

      npcs.add(
        IsometricNPC(
          gridX: tile.gridX,
          gridY: tile.gridY,
          screenX: tile.screenX,
          screenY:
              tile.screenY - tile.elevation * tile.baseHeight - (tileH * 0.5),
          type: npcType,
          color: _getNPCColor(npcType),
          isMoving: _random.nextBool(),
        ),
      );
    }

    return npcs;
  }

  Color _getNPCColor(int type) {
    switch (type) {
      case 0:
        return Colors.blue.shade800; // Police
      case 1:
        return Colors.red.shade700; // Gangster
      case 2:
        return Colors.green.shade700; // Civilian
      case 3:
        return Colors.purple.shade600; // Dealer
      case 4:
        return Colors.orange.shade700; // Prostitute
      default:
        return Colors.grey;
    }
  }

  List<IsometricProp> _generateProps(
    List<IsometricTile> tiles,
    double tileW,
    double tileH,
  ) {
    final props = <IsometricProp>[];
    final suitableTiles =
        tiles.where((t) => t.elevation > 0.1 && t.elevation < 1.0).toList();

    suitableTiles.shuffle(_random);

    final count = min(20 + _random.nextInt(15), suitableTiles.length);
    for (int i = 0; i < count; i++) {
      final tile = suitableTiles[i];
      final propType = _random.nextInt(4);

      props.add(
        IsometricProp(
          gridX: tile.gridX,
          gridY: tile.gridY,
          screenX: tile.screenX,
          screenY: tile.screenY - tile.elevation * tile.baseHeight,
          type: propType,
          color: _getPropColor(propType),
          size: 4 + _random.nextDouble() * 8,
        ),
      );
    }

    return props;
  }

  Color _getPropColor(int type) {
    switch (type) {
      case 0:
        return Colors.brown; // Tree trunk
      case 1:
        return Colors.green.shade400; // Bush
      case 2:
        return Colors.grey.shade600; // Rock
      case 3:
        return Colors.yellow.shade800; // Street light
      default:
        return Colors.grey;
    }
  }
}

// ---------- DATA MODELS ----------

class ProceduralHeightMap {
  final int width;
  final int height;
  final List<List<double>> elevations;
  final int seed;
  final double frequency;
  final int octaves;
  final double persistence;
  final double lacunarity;

  ProceduralHeightMap({
    required this.width,
    required this.height,
    required this.elevations,
    required this.seed,
    required this.frequency,
    required this.octaves,
    required this.persistence,
    required this.lacunarity,
  });

  double getElevation(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return 0;
    return elevations[y][x];
  }

  double getMaxElevation() {
    double max = 0;
    for (final row in elevations) {
      for (final val in row) {
        if (val > max) max = val;
      }
    }
    return max;
  }
}

enum TerrainType { grass, darkGrass, hill, rock, mountain }

class IsometricTile {
  final int gridX;
  final int gridY;
  final double screenX;
  final double screenY;
  final double elevation;
  final double baseHeight;
  final double tileWidth;
  final double tileHeight;
  final Color surfaceColor;
  final Color edgeColor;
  final TerrainType type;

  IsometricTile({
    required this.gridX,
    required this.gridY,
    required this.screenX,
    required this.screenY,
    required this.elevation,
    required this.baseHeight,
    required this.tileWidth,
    required this.tileHeight,
    required this.surfaceColor,
    required this.edgeColor,
    required this.type,
  });

  /// The 3D height at this tile's position
  double get worldHeight => elevation * baseHeight;
}

class IsometricBuilding {
  final String type;
  final int gridX;
  final int gridY;
  final double screenX;
  final double screenY;
  final double width;
  final double height;
  final Color color;

  IsometricBuilding({
    required this.type,
    required this.gridX,
    required this.gridY,
    required this.screenX,
    required this.screenY,
    required this.width,
    required this.height,
    required this.color,
  });
}

class IsometricNPC {
  final int gridX;
  final int gridY;
  final double screenX;
  final double screenY;
  final int type;
  final Color color;
  final bool isMoving;

  IsometricNPC({
    required this.gridX,
    required this.gridY,
    required this.screenX,
    required this.screenY,
    required this.type,
    required this.color,
    required this.isMoving,
  });
}

class IsometricProp {
  final int gridX;
  final int gridY;
  final double screenX;
  final double screenY;
  final int type;
  final Color color;
  final double size;

  IsometricProp({
    required this.gridX,
    required this.gridY,
    required this.screenX,
    required this.screenY,
    required this.type,
    required this.color,
    required this.size,
  });
}

class IsometricWorldData {
  final List<IsometricTile> tiles;
  final List<IsometricBuilding> buildings;
  final List<IsometricNPC> npcs;
  final List<IsometricProp> props;
  final int mapWidth;
  final int mapHeight;

  IsometricWorldData({
    required this.tiles,
    required this.buildings,
    required this.npcs,
    required this.props,
    required this.mapWidth,
    required this.mapHeight,
  });
}

/// Custom painter for rendering the isometric world
class IsometricWorldPainter extends CustomPainter {
  final IsometricWorldData worldData;
  final Offset cameraOffset;
  final double zoom;
  final double animProgress;

  IsometricWorldPainter({
    required this.worldData,
    required this.cameraOffset,
    required this.zoom,
    required this.animProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(cameraOffset.dx, cameraOffset.dy);
    canvas.scale(zoom);

    _drawTiles(canvas, size);
    _drawProps(canvas);
    _drawBuildings(canvas);
    _drawNPCs(canvas);

    canvas.restore();
  }

  void _drawTiles(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Sort tiles by depth (painter's algorithm)
    final sortedTiles = List<IsometricTile>.from(worldData.tiles)
      ..sort(
        (a, b) => Procedural3DTerrain.depthSortKey(
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

      // Draw the top surface (diamond)
      final path = Path();
      path.moveTo(cx, cy - hh);
      path.lineTo(cx + hw, cy);
      path.lineTo(cx, cy + hh);
      path.lineTo(cx - hw, cy);
      path.close();

      paint.color = tile.surfaceColor;
      canvas.drawPath(path, paint);

      // Draw edge lines for elevation
      if (tile.elevation > 0.1) {
        edgePaint.color = tile.edgeColor;
        canvas.drawPath(path, edgePaint);

        // Draw side faces for elevation
        final elev = tile.worldHeight;
        final sidePaint = Paint()
          ..color = Color.fromARGB(
            255,
            (tile.edgeColor.r * 0.6).round().clamp(0, 255),
            (tile.edgeColor.g * 0.6).round().clamp(0, 255),
            (tile.edgeColor.b * 0.6).round().clamp(0, 255),
          );

        // Right side face
        final rightPath = Path();
        rightPath.moveTo(cx + hw, cy);
        rightPath.lineTo(cx + hw, cy + elev);
        rightPath.lineTo(cx, cy + hh + elev);
        rightPath.lineTo(cx, cy + hh);
        rightPath.close();
        canvas.drawPath(rightPath, sidePaint);

        // Left side face
        final leftPath = Path();
        leftPath.moveTo(cx - hw, cy);
        leftPath.lineTo(cx - hw, cy + elev);
        leftPath.lineTo(cx, cy + hh + elev);
        leftPath.lineTo(cx, cy + hh);
        leftPath.close();
        final leftPaint = Paint()
          ..color = Color.fromARGB(
            255,
            (sidePaint.color.r * 0.8).round().clamp(0, 255),
            (sidePaint.color.g * 0.8).round().clamp(0, 255),
            (sidePaint.color.b * 0.8).round().clamp(0, 255),
          );
        canvas.drawPath(leftPath, leftPaint);
      }
    }
  }

  void _drawProps(Canvas canvas) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final prop in worldData.props) {
      paint.color = prop.color;
      canvas.drawCircle(Offset(prop.screenX, prop.screenY), prop.size, paint);

      // Draw shadow
      final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.2);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(prop.screenX + 2, prop.screenY + 2),
          width: prop.size * 1.5,
          height: prop.size * 0.5,
        ),
        shadowPaint,
      );
    }
  }

  void _drawBuildings(Canvas canvas) {
    final paint = Paint()..style = PaintingStyle.fill;
    final windowPaint = Paint()..color = const Color(0xFFFFDD44);

    for (final building in worldData.buildings) {
      final bw = building.width;
      final bh = building.height;

      // Building body
      paint.color = building.color;
      final bodyPath = Path();
      bodyPath.moveTo(building.screenX - bw / 2, building.screenY);
      bodyPath.lineTo(building.screenX, building.screenY - bh / 2);
      bodyPath.lineTo(building.screenX + bw / 2, building.screenY);
      bodyPath.lineTo(building.screenX, building.screenY + bh / 2);
      bodyPath.close();
      canvas.drawPath(bodyPath, paint);

      // Lighter front face
      final frontPaint = Paint()
        ..color = Color.fromARGB(
          255,
          (building.color.r * 1.2).round().clamp(0, 255),
          (building.color.g * 1.2).round().clamp(0, 255),
          (building.color.b * 1.2).round().clamp(0, 255),
        );
      final frontPath = Path();
      frontPath.moveTo(building.screenX, building.screenY + bh / 2 - bh * 0.3);
      frontPath.lineTo(building.screenX + bw / 2, building.screenY);
      frontPath.lineTo(building.screenX, building.screenY - bh / 2 + bh * 0.3);
      frontPath.close();
      canvas.drawPath(frontPath, frontPaint);

      // Roof
      paint.color = Color.fromARGB(
        255,
        (building.color.r * 0.8).round().clamp(0, 255),
        (building.color.g * 0.8).round().clamp(0, 255),
        (building.color.b * 0.8).round().clamp(0, 255),
      );
      final roofPath = Path();
      roofPath.moveTo(
        building.screenX - bw / 2 - 4,
        building.screenY - bh * 0.15,
      );
      roofPath.lineTo(building.screenX, building.screenY - bh / 2 - 6);
      roofPath.lineTo(
        building.screenX + bw / 2 + 4,
        building.screenY - bh * 0.15,
      );
      roofPath.lineTo(building.screenX, building.screenY + bh * 0.1);
      roofPath.close();
      canvas.drawPath(roofPath, paint);

      // Windows
      final winW = bw * 0.12;
      final winH = bh * 0.1;
      for (int i = -1; i <= 1; i += 2) {
        final wx = building.screenX + i * bw * 0.25;
        final wy = building.screenY - i * bh * 0.05;
        canvas.drawRect(
          Rect.fromCenter(center: Offset(wx, wy), width: winW, height: winH),
          windowPaint,
        );
      }
    }
  }

  void _drawNPCs(Canvas canvas) {
    final paint = Paint()..style = PaintingStyle.fill;
    final bodyPaint = Paint();

    for (final npc in worldData.npcs) {
      // Shadow
      final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.15);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(npc.screenX + 1, npc.screenY + 1),
          width: 10,
          height: 4,
        ),
        shadowPaint,
      );

      // Body (small isometric character)
      bodyPaint.color = npc.color;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(npc.screenX, npc.screenY - 6),
          width: 6,
          height: 8,
        ),
        bodyPaint,
      );

      // Head
      paint.color = Color.fromARGB(255, 220, 180, 140);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(npc.screenX, npc.screenY - 12),
          width: 5,
          height: 5,
        ),
        paint,
      );

      // Legs
      paint.color = Color.fromARGB(
        255,
        (npc.color.r * 0.7).round().clamp(0, 255),
        (npc.color.g * 0.7).round().clamp(0, 255),
        (npc.color.b * 0.7).round().clamp(0, 255),
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(npc.screenX - 2, npc.screenY),
          width: 3,
          height: 4,
        ),
        paint,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(npc.screenX + 2, npc.screenY),
          width: 3,
          height: 4,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant IsometricWorldPainter oldDelegate) {
    return oldDelegate.worldData != worldData ||
        oldDelegate.cameraOffset != cameraOffset ||
        oldDelegate.zoom != zoom ||
        oldDelegate.animProgress != animProgress;
  }
}
