import 'dart:math';
import 'package:flutter/material.dart';

/// Procedural Pixel Art Generator System
/// Creates all game visuals algorithmically with consistent pixel art style

class ProceduralPixelArt {
  final Random _random;
  final int seed;

  ProceduralPixelArt({int? seed})
    : seed = seed ?? DateTime.now().millisecondsSinceEpoch,
      _random = Random(seed ?? DateTime.now().millisecondsSinceEpoch);

  /// Generate a procedural character with random but consistent features
  ProceduralCharacter generateCharacter({
    CharacterType type = CharacterType.gangster,
    ColorScheme? colorScheme,
    int? variant,
  }) {
    final scheme = colorScheme ?? generateColorScheme(type.colorTheme);
    final charVariant = variant ?? _random.nextInt(8);

    return ProceduralCharacter(
      type: type,
      colorScheme: scheme,
      variant: charVariant,
      pixels: _generateCharacterPixels(type, scheme, charVariant),
      animations: _generateCharacterAnimations(type, scheme, charVariant),
    );
  }

  /// Generate a procedural building/environment
  ProceduralBuilding generateBuilding({
    BuildingType type = BuildingType.crackhouse,
    ColorScheme? colorScheme,
    int? variant,
  }) {
    final scheme = colorScheme ?? generateColorScheme(type.colorTheme);
    final buildVariant = variant ?? _random.nextInt(6);

    return ProceduralBuilding(
      type: type,
      colorScheme: scheme,
      variant: buildVariant,
      pixels: _generateBuildingPixels(type, scheme, buildVariant),
      animations: _generateBuildingAnimations(type, scheme, buildVariant),
    );
  }

  /// Generate a procedural weapon
  ProceduralWeapon generateWeapon({
    WeaponType type = WeaponType.pistol,
    ColorScheme? colorScheme,
    int? variant,
  }) {
    final scheme = colorScheme ?? generateColorScheme(type.colorTheme);
    final wepVariant = variant ?? _random.nextInt(4);

    return ProceduralWeapon(
      type: type,
      colorScheme: scheme,
      variant: wepVariant,
      pixels: _generateWeaponPixels(type, scheme, wepVariant),
      animations: _generateWeaponAnimations(type, scheme, wepVariant),
    );
  }

  /// Generate a procedural vehicle
  ProceduralVehicle generateVehicle({
    VehicleType type = VehicleType.car,
    ColorScheme? colorScheme,
    int? variant,
  }) {
    final scheme = colorScheme ?? generateColorScheme(type.colorTheme);
    final vehVariant = variant ?? _random.nextInt(5);

    return ProceduralVehicle(
      type: type,
      colorScheme: scheme,
      variant: vehVariant,
      pixels: _drawVehiclePixels(type, scheme, vehVariant),
      animations: _generateVehicleAnimations(type, scheme, vehVariant),
    );
  }

  /// Generate a procedural environment/background
  ProceduralEnvironment generateEnvironment({
    EnvironmentType type = EnvironmentType.city,
    ColorScheme? colorScheme,
    int? variant,
  }) {
    final scheme = colorScheme ?? generateColorScheme(type.colorTheme);
    final envVariant = variant ?? _random.nextInt(10);

    return ProceduralEnvironment(
      type: type,
      colorScheme: scheme,
      variant: envVariant,
      pixels: _generateEnvironmentPixels(type, scheme, envVariant),
      parallaxLayers: _generateParallaxLayers(type, scheme, envVariant),
    );
  }

  /// Generate a color scheme based on theme
  ColorScheme generateColorScheme(ColorTheme theme) {
    switch (theme) {
      case ColorTheme.gangster:
        return ColorScheme(
          primary: Color(_randomColor(0xFF, 0x80, 0x00, 0xFF)),
          secondary: Color(_randomColor(0x00, 0x00, 0x80, 0xFF)),
          background: Color(_randomColor(0x10, 0x10, 0x20, 0x40)),
          surface: Color(_randomColor(0x20, 0x20, 0x30, 0x80)),
          error: Color(_randomColor(0x80, 0x00, 0x00, 0xFF)),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        );
      case ColorTheme.drug:
        return ColorScheme(
          primary: Color(_randomColor(0x80, 0x40, 0x80, 0xFF)),
          secondary: Color(_randomColor(0x40, 0x80, 0x40, 0xFF)),
          background: Color(_randomColor(0x20, 0x10, 0x30, 0x60)),
          surface: Color(_randomColor(0x30, 0x20, 0x40, 0x80)),
          error: Color(_randomColor(0xFF, 0x40, 0x80, 0xFF)),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        );
      case ColorTheme.violence:
        return ColorScheme(
          primary: Color(_randomColor(0x80, 0x00, 0x00, 0xFF)),
          secondary: Color(_randomColor(0xFF, 0x40, 0x40, 0xFF)),
          background: Color(_randomColor(0x10, 0x00, 0x00, 0x40)),
          surface: Color(_randomColor(0x20, 0x10, 0x10, 0x80)),
          error: Color(_randomColor(0xFF, 0x00, 0x00, 0xFF)),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        );
      case ColorTheme.city:
        return ColorScheme(
          primary: Color(_randomColor(0x40, 0x40, 0x40, 0xFF)),
          secondary: Color(_randomColor(0x80, 0x80, 0x80, 0xFF)),
          background: Color(_randomColor(0x10, 0x10, 0x10, 0x60)),
          surface: Color(_randomColor(0x20, 0x20, 0x20, 0x80)),
          error: Color(_randomColor(0xFF, 0xFF, 0x00, 0xFF)),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        );
      case ColorTheme.neon:
        return ColorScheme(
          primary: Color(_randomColor(0xFF, 0x00, 0xFF, 0xFF)),
          secondary: Color(_randomColor(0x00, 0xFF, 0xFF, 0xFF)),
          background: Color(_randomColor(0x00, 0x00, 0x20, 0x60)),
          surface: Color(_randomColor(0x10, 0x10, 0x30, 0x80)),
          error: Color(_randomColor(0xFF, 0x80, 0x00, 0xFF)),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onBackground: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        );
    }
  }

  /// Generate character pixel data
  List<List<Color>> _generateCharacterPixels(
    CharacterType type,
    ColorScheme scheme,
    int variant,
  ) {
    final pixels = List.generate(
      16,
      (_) => List.filled(16, Colors.transparent),
    );

    // Base body shape
    final bodyColor = scheme.primary;
    final headColor = scheme.secondary;
    final clothingColor = scheme.surface;

    // Generate body based on type and variant
    switch (type) {
      case CharacterType.gangster:
        _drawGangster(pixels, bodyColor, headColor, clothingColor, variant);
        break;
      case CharacterType.dealer:
        _drawDealer(pixels, bodyColor, headColor, clothingColor, variant);
        break;
      case CharacterType.prostitute:
        _drawProstitute(pixels, bodyColor, headColor, clothingColor, variant);
        break;
      case CharacterType.victim:
        _drawVictim(pixels, bodyColor, headColor, clothingColor, variant);
        break;
      case CharacterType.police:
        _drawPolice(pixels, bodyColor, headColor, clothingColor, variant);
        break;
    }

    return pixels;
  }

  /// Generate building pixel data
  List<List<Color>> _generateBuildingPixels(
    BuildingType type,
    ColorScheme scheme,
    int variant,
  ) {
    final pixels = List.generate(
      32,
      (_) => List.filled(32, Colors.transparent),
    );

    final wallColor = scheme.primary;
    final roofColor = scheme.secondary;
    final windowColor = scheme.surface;
    final doorColor = scheme.error;

    switch (type) {
      case BuildingType.crackhouse:
        _drawCrackhouse(
          pixels,
          wallColor,
          roofColor,
          windowColor,
          doorColor,
          variant,
        );
        break;
      case BuildingType.gunshack:
        _drawGunShack(
          pixels,
          wallColor,
          roofColor,
          windowColor,
          doorColor,
          variant,
        );
        break;
      case BuildingType.bank:
        _drawBank(
          pixels,
          wallColor,
          roofColor,
          windowColor,
          doorColor,
          variant,
        );
        break;
      case BuildingType.bar:
        _drawBar(pixels, wallColor, roofColor, windowColor, doorColor, variant);
        break;
      case BuildingType.alleyway:
        _drawAlleyway(
          pixels,
          wallColor,
          roofColor,
          windowColor,
          doorColor,
          variant,
        );
        break;
    }

    return pixels;
  }

  /// Generate weapon pixel data
  List<List<Color>> _generateWeaponPixels(
    WeaponType type,
    ColorScheme scheme,
    int variant,
  ) {
    final pixels = List.generate(
      16,
      (_) => List.filled(16, Colors.transparent),
    );

    final metalColor = scheme.primary;
    final woodColor = scheme.secondary;
    final detailColor = scheme.surface;

    switch (type) {
      case WeaponType.pistol:
        _drawPistol(pixels, metalColor, woodColor, detailColor, variant);
        break;
      case WeaponType.uzi:
        _drawUzi(pixels, metalColor, woodColor, detailColor, variant);
        break;
      case WeaponType.knife:
        _drawKnife(pixels, metalColor, woodColor, detailColor, variant);
        break;
      case WeaponType.bat:
        _drawBat(pixels, woodColor, metalColor, detailColor, variant);
        break;
    }

    return pixels;
  }

  /// Generate environment pixel data
  List<List<Color>> _generateEnvironmentPixels(
    EnvironmentType type,
    ColorScheme scheme,
    int variant,
  ) {
    final pixels = List.generate(
      64,
      (_) => List.filled(64, Colors.transparent),
    );

    final groundColor = scheme.primary;
    final buildingColor = scheme.secondary;
    final skyColor = scheme.background;
    final detailColor = scheme.surface;

    switch (type) {
      case EnvironmentType.city:
        _drawCityscape(
          pixels,
          groundColor,
          buildingColor,
          skyColor,
          detailColor,
          variant,
        );
        break;
      case EnvironmentType.alley:
        _drawAlley(
          pixels,
          groundColor,
          buildingColor,
          skyColor,
          detailColor,
          variant,
        );
        break;
      case EnvironmentType.street:
        _drawStreet(
          pixels,
          groundColor,
          buildingColor,
          skyColor,
          detailColor,
          variant,
        );
        break;
    }

    return pixels;
  }

  // Character drawing methods
  void _drawGangster(
    List<List<Color>> pixels,
    Color body,
    Color head,
    Color clothes,
    int variant,
  ) {
    // Head
    _fillRect(pixels, 6, 2, 4, 4, head);

    // Body
    _fillRect(pixels, 5, 7, 6, 6, clothes);

    // Arms
    _drawLine(pixels, 4, 8, 2, 10, body);
    _drawLine(pixels, 11, 8, 13, 10, body);

    // Legs
    _drawLine(pixels, 6, 13, 5, 15, body);
    _drawLine(pixels, 9, 13, 10, 15, body);

    // Accessories based on variant
    if (variant % 2 == 0) {
      _drawLine(pixels, 6, 3, 9, 3, Colors.black); // Hat
    }
    if (variant % 3 == 0) {
      _fillRect(pixels, 7, 8, 2, 2, Colors.black); // Gun
    }
  }

  void _drawDealer(
    List<List<Color>> pixels,
    Color body,
    Color head,
    Color clothes,
    int variant,
  ) {
    // Head
    _fillRect(pixels, 6, 2, 4, 4, head);

    // Body
    _fillRect(pixels, 5, 7, 6, 6, clothes);

    // Arms
    _drawLine(pixels, 4, 8, 1, 9, body);
    _drawLine(pixels, 11, 8, 14, 9, body);

    // Legs
    _drawLine(pixels, 6, 13, 5, 15, body);
    _drawLine(pixels, 9, 13, 10, 15, body);

    // Drug bag
    if (variant % 2 == 0) {
      _fillRect(pixels, 2, 9, 2, 2, Colors.green);
    }
  }

  void _drawProstitute(
    List<List<Color>> pixels,
    Color body,
    Color head,
    Color clothes,
    int variant,
  ) {
    // Head
    _fillRect(pixels, 6, 2, 4, 4, head);

    // Body
    _fillRect(pixels, 5, 7, 6, 4, clothes);

    // Arms
    _drawLine(pixels, 4, 8, 1, 8, body);
    _drawLine(pixels, 11, 8, 14, 8, body);

    // Legs
    _drawLine(pixels, 6, 11, 4, 15, body);
    _drawLine(pixels, 9, 11, 11, 15, body);

    // High heels
    if (variant % 2 == 0) {
      _fillRect(pixels, 3, 15, 1, 1, Colors.red);
      _fillRect(pixels, 10, 15, 1, 1, Colors.red);
    }
  }

  void _drawVictim(
    List<List<Color>> pixels,
    Color body,
    Color head,
    Color clothes,
    int variant,
  ) {
    // Head
    _fillRect(pixels, 6, 2, 4, 4, head);

    // Body (fallen)
    _fillRect(pixels, 4, 7, 8, 3, clothes);

    // Arms (spread)
    _drawLine(pixels, 3, 8, 0, 10, body);
    _drawLine(pixels, 12, 8, 15, 10, body);

    // Legs (twisted)
    _drawLine(pixels, 5, 10, 3, 13, body);
    _drawLine(pixels, 10, 10, 12, 13, body);

    // Blood splatter
    if (variant % 2 == 0) {
      _fillRect(pixels, 2, 12, 2, 2, Colors.red);
      _fillRect(pixels, 12, 12, 2, 2, Colors.red);
    }
  }

  void _drawPolice(
    List<List<Color>> pixels,
    Color body,
    Color head,
    Color clothes,
    int variant,
  ) {
    // Head
    _fillRect(pixels, 6, 2, 4, 4, head);

    // Body
    _fillRect(pixels, 5, 7, 6, 6, clothes);

    // Arms
    _drawLine(pixels, 4, 8, 1, 10, body);
    _drawLine(pixels, 11, 8, 14, 10, body);

    // Legs
    _drawLine(pixels, 6, 13, 5, 15, body);
    _drawLine(pixels, 9, 13, 10, 15, body);

    // Badge
    if (variant % 2 == 0) {
      _fillRect(pixels, 7, 8, 2, 2, Colors.yellow);
    }
  }

  // Building drawing methods
  void _drawCrackhouse(
    List<List<Color>> pixels,
    Color wall,
    Color roof,
    Color window,
    Color door,
    int variant,
  ) {
    // Building structure
    _fillRect(pixels, 8, 12, 16, 20, wall);

    // Roof
    _drawTriangle(pixels, 6, 12, 24, 12, 15, 6, roof);

    // Windows
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 2; j++) {
        _fillRect(pixels, 10 + i * 4, 16 + j * 4, 2, 2, window);
      }
    }

    // Door
    _fillRect(pixels, 14, 28, 4, 4, door);

    // Sign
    if (variant % 2 == 0) {
      _fillRect(pixels, 8, 10, 16, 2, Colors.purple);
      _drawText(pixels, "CRACK", 10, 10, Colors.white);
    }
  }

  void _drawGunShack(
    List<List<Color>> pixels,
    Color wall,
    Color roof,
    Color window,
    Color door,
    int variant,
  ) {
    // Building structure
    _fillRect(pixels, 8, 12, 16, 20, wall);

    // Roof
    _drawTriangle(pixels, 6, 12, 24, 12, 15, 6, roof);

    // Windows
    for (int i = 0; i < 2; i++) {
      _fillRect(pixels, 12 + i * 6, 16, 3, 3, window);
    }

    // Door
    _fillRect(pixels, 14, 28, 4, 4, door);

    // Gun display
    if (variant % 2 == 0) {
      _drawPistol(pixels, Colors.black, Colors.brown, Colors.grey, 0);
    }
  }

  void _drawBank(
    List<List<Color>> pixels,
    Color wall,
    Color roof,
    Color window,
    Color door,
    int variant,
  ) {
    // Building structure
    _fillRect(pixels, 8, 12, 16, 20, wall);

    // Roof
    _drawTriangle(pixels, 6, 12, 24, 12, 15, 6, roof);

    // Windows
    for (int i = 0; i < 4; i++) {
      _fillRect(pixels, 9 + i * 3, 16, 2, 3, window);
    }

    // Door
    _fillRect(pixels, 14, 28, 4, 4, door);

    // Bank sign
    if (variant % 2 == 0) {
      _fillRect(pixels, 8, 10, 16, 2, Colors.yellow);
      _drawText(pixels, "BANK", 10, 10, Colors.white);
    }
  }

  void _drawBar(
    List<List<Color>> pixels,
    Color wall,
    Color roof,
    Color window,
    Color door,
    int variant,
  ) {
    // Building structure
    _fillRect(pixels, 8, 12, 16, 20, wall);

    // Roof
    _drawTriangle(pixels, 6, 12, 24, 12, 15, 6, roof);

    // Windows
    for (int i = 0; i < 3; i++) {
      _fillRect(pixels, 10 + i * 4, 16, 2, 3, window);
    }

    // Door
    _fillRect(pixels, 14, 28, 4, 4, door);

    // Bar sign
    if (variant % 2 == 0) {
      _fillRect(pixels, 8, 10, 16, 2, Colors.red);
      _drawText(pixels, "BAR", 12, 10, Colors.white);
    }
  }

  void _drawAlleyway(
    List<List<Color>> pixels,
    Color wall,
    Color roof,
    Color window,
    Color door,
    int variant,
  ) {
    // Walls
    _fillRect(pixels, 0, 0, 8, 32, wall);
    _fillRect(pixels, 24, 0, 8, 32, wall);

    // Ground
    _fillRect(pixels, 8, 24, 16, 8, Colors.grey[800]!);

    // Trash
    if (variant % 2 == 0) {
      _fillRect(pixels, 10, 26, 2, 2, Colors.brown);
      _fillRect(pixels, 20, 26, 2, 2, Colors.brown);
    }
  }

  // Utility drawing methods
  void _fillRect(
    List<List<Color>> pixels,
    int x,
    int y,
    int width,
    int height,
    Color color,
  ) {
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        if (x + i >= 0 &&
            x + i < pixels.length &&
            y + j >= 0 &&
            y + j < pixels[0].length) {
          pixels[x + i][y + j] = color;
        }
      }
    }
  }

  void _drawLine(
    List<List<Color>> pixels,
    int x1,
    int y1,
    int x2,
    int y2,
    Color color,
  ) {
    final dx = (x2 - x1).abs();
    final dy = (y2 - y1).abs();
    final sx = x1 < x2 ? 1 : -1;
    final sy = y1 < y2 ? 1 : -1;
    var err = dx - dy;

    var x = x1;
    var y = y1;

    while (true) {
      if (x >= 0 && x < pixels.length && y >= 0 && y < pixels[0].length) {
        pixels[x][y] = color;
      }

      if (x == x2 && y == y2) break;

      final e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x += sx;
      }
      if (e2 < dx) {
        err += dx;
        y += sy;
      }
    }
  }

  void _drawTriangle(
    List<List<Color>> pixels,
    int x1,
    int y1,
    int x2,
    int y2,
    int x3,
    int y3,
    Color color,
  ) {
    // Simple triangle fill using scanline algorithm
    final minY = y1 < y2 ? (y1 < y3 ? y1 : y3) : (y2 < y3 ? y2 : y3);
    final maxY = y1 > y2 ? (y1 > y3 ? y1 : y3) : (y2 > y3 ? y2 : y3);

    for (int y = minY; y <= maxY; y++) {
      List<int> intersections = [];

      _addIntersection(y1, y2, x1, x2, y, intersections);
      _addIntersection(y2, y3, x2, x3, y, intersections);
      _addIntersection(y3, y1, x3, x1, y, intersections);

      intersections.sort();

      for (int i = 0; i < intersections.length - 1; i += 2) {
        for (int x = intersections[i]; x <= intersections[i + 1]; x++) {
          if (x >= 0 && x < pixels.length && y >= 0 && y < pixels[0].length) {
            pixels[x][y] = color;
          }
        }
      }
    }
  }

  void _addIntersection(
    int y1,
    int y2,
    int x1,
    int x2,
    int y,
    List<int> intersections,
  ) {
    if ((y1 <= y && y2 > y) || (y2 <= y && y1 > y)) {
      final x = x1 + (y - y1) * (x2 - x1) ~/ (y2 - y1);
      intersections.add(x);
    }
  }

  void _drawText(
    List<List<Color>> pixels,
    String text,
    int x,
    int y,
    Color color,
  ) {
    // Simple ASCII art text rendering
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      // Basic character mapping (simplified)
      if (char == 'C') {
        _fillRect(pixels, x + i * 4, y, 1, 3, color);
        _fillRect(pixels, x + i * 4, y, 3, 1, color);
        _fillRect(pixels, x + i * 4, y + 2, 3, 1, color);
      } else if (char == 'R') {
        _fillRect(pixels, x + i * 4, y, 1, 3, color);
        _fillRect(pixels, x + i * 4, y, 3, 1, color);
        _fillRect(pixels, x + i * 4 + 2, y + 1, 1, 2, color);
        _drawLine(pixels, x + i * 4, y + 1, x + i * 4 + 2, y + 1, color);
      }
      // Add more characters as needed
    }
  }

  // Weapon drawing methods
  void _drawPistol(
    List<List<Color>> pixels,
    Color metal,
    Color wood,
    Color detail,
    int variant,
  ) {
    // Grip
    _fillRect(pixels, 4, 8, 3, 6, wood);

    // Barrel
    _fillRect(pixels, 7, 6, 6, 2, metal);

    // Trigger guard
    _drawLine(pixels, 6, 9, 8, 9, metal);

    // Details
    if (variant % 2 == 0) {
      _fillRect(pixels, 9, 6, 1, 1, detail); // Sight
    }
  }

  List<List<Color>> _drawVehiclePixels(
    VehicleType type,
    ColorScheme scheme,
    int variant,
  ) {
    final pixels = List.generate(
      24,
      (_) => List.filled(16, Colors.transparent),
    );

    final bodyColor = scheme.primary;
    final wheelColor = scheme.secondary;
    final detailColor = scheme.surface;

    // Car body
    _fillRect(pixels, 4, 6, 16, 6, bodyColor);

    // Wheels
    _fillRect(pixels, 6, 12, 2, 2, wheelColor);
    _fillRect(pixels, 16, 12, 2, 2, wheelColor);

    // Windows
    _fillRect(pixels, 8, 7, 8, 2, detailColor);

    // Details
    if (variant % 2 == 0) {
      _fillRect(pixels, 6, 8, 1, 1, Colors.yellow); // Headlight
      _fillRect(pixels, 19, 8, 1, 1, Colors.red); // Taillight
    }

    return pixels;
  }

  void _drawUzi(
    List<List<Color>> pixels,
    Color metal,
    Color wood,
    Color detail,
    int variant,
  ) {
    // Body
    _fillRect(pixels, 2, 6, 10, 4, metal);

    // Stock
    _fillRect(pixels, 12, 4, 2, 6, wood);

    // Magazine
    _fillRect(pixels, 4, 10, 2, 4, metal);

    // Details
    if (variant % 2 == 0) {
      _fillRect(pixels, 8, 6, 1, 1, detail); // Sight
    }
  }

  void _drawKnife(
    List<List<Color>> pixels,
    Color metal,
    Color wood,
    Color detail,
    int variant,
  ) {
    // Handle
    _fillRect(pixels, 2, 8, 4, 2, wood);

    // Blade
    _fillRect(pixels, 6, 6, 6, 4, metal);

    // Tip
    _fillRect(pixels, 12, 7, 2, 2, metal);
  }

  void _drawBat(
    List<List<Color>> pixels,
    Color wood,
    Color metal,
    Color detail,
    int variant,
  ) {
    // Handle
    _fillRect(pixels, 2, 6, 2, 8, wood);

    // Head
    _fillRect(pixels, 4, 4, 6, 4, wood);

    // Metal reinforcement
    if (variant % 2 == 0) {
      _fillRect(pixels, 4, 4, 6, 1, metal);
    }
  }

  // Environment drawing methods
  void _drawCityscape(
    List<List<Color>> pixels,
    Color ground,
    Color building,
    Color sky,
    Color detail,
    int variant,
  ) {
    // Sky
    _fillRect(pixels, 0, 0, 64, 32, sky);

    // Buildings
    for (int i = 0; i < 8; i++) {
      final height = 20 + (variant + i) % 15;
      final width = 6 + (variant + i * 2) % 6;
      final x = i * 8 + (variant + i) % 3;

      _fillRect(pixels, x, 32 - height, width, height, building);

      // Windows
      for (int j = 0; j < height ~/ 4; j++) {
        for (int k = 0; k < width ~/ 2; k++) {
          if ((variant + i + j + k) % 3 == 0) {
            _fillRect(
              pixels,
              x + 1 + k * 2,
              32 - height + 2 + j * 4,
              1,
              2,
              detail,
            );
          }
        }
      }
    }

    // Ground
    _fillRect(pixels, 0, 32, 64, 32, ground);
  }

  void _drawAlley(
    List<List<Color>> pixels,
    Color ground,
    Color building,
    Color sky,
    Color detail,
    int variant,
  ) {
    // Walls
    _fillRect(pixels, 0, 0, 8, 64, building);
    _fillRect(pixels, 56, 0, 8, 64, building);

    // Ground
    _fillRect(pixels, 8, 48, 48, 16, ground);

    // Trash and details
    for (int i = 0; i < 5; i++) {
      if ((variant + i) % 3 == 0) {
        _fillRect(pixels, 10 + i * 8, 50, 2, 2, detail);
      }
    }
  }

  void _drawStreet(
    List<List<Color>> pixels,
    Color ground,
    Color building,
    Color sky,
    Color detail,
    int variant,
  ) {
    // Sky
    _fillRect(pixels, 0, 0, 64, 24, sky);

    // Road
    _fillRect(pixels, 0, 24, 64, 16, ground);

    // Buildings
    _fillRect(pixels, 0, 16, 64, 8, building);

    // Road markings
    for (int i = 0; i < 16; i++) {
      if (i % 2 == 0) {
        _fillRect(pixels, i * 4, 31, 2, 2, detail);
      }
    }
  }

  // Animation generation methods
  List<ProceduralAnimation> _generateCharacterAnimations(
    CharacterType type,
    ColorScheme scheme,
    int variant,
  ) {
    final animations = <ProceduralAnimation>[];

    // Walking animation
    animations.add(
      ProceduralAnimation(
        type: AnimationType.walk,
        frames: _generateWalkingFrames(type, scheme, variant),
        frameDuration: 100,
      ),
    );

    // Idle animation
    animations.add(
      ProceduralAnimation(
        type: AnimationType.idle,
        frames: _generateIdleFrames(type, scheme, variant),
        frameDuration: 500,
      ),
    );

    // Action animation (fight, shoot, etc.)
    animations.add(
      ProceduralAnimation(
        type: AnimationType.action,
        frames: _generateActionFrames(type, scheme, variant),
        frameDuration: 200,
      ),
    );

    return animations;
  }

  List<List<List<Color>>> _generateWalkingFrames(
    CharacterType type,
    ColorScheme scheme,
    int variant,
  ) {
    final frames = <List<List<Color>>>[];

    for (int i = 0; i < 4; i++) {
      final pixels = List.generate(
        16,
        (_) => List.filled(16, Colors.transparent),
      );

      // Generate walking pose based on frame
      final offset = (i % 2 == 0) ? 1 : -1;

      // Head
      _fillRect(pixels, 6, 2, 4, 4, scheme.secondary);

      // Body
      _fillRect(pixels, 5, 7, 6, 6, scheme.surface);

      // Arms (swinging)
      _drawLine(pixels, 4, 8, 2 + offset, 10, scheme.primary);
      _drawLine(pixels, 11, 8, 13 - offset, 10, scheme.primary);

      // Legs (walking)
      _drawLine(pixels, 6, 13, 4 + offset * 2, 15, scheme.primary);
      _drawLine(pixels, 9, 13, 11 - offset * 2, 15, scheme.primary);

      frames.add(pixels);
    }

    return frames;
  }

  List<List<List<Color>>> _generateIdleFrames(
    CharacterType type,
    ColorScheme scheme,
    int variant,
  ) {
    final frames = <List<List<Color>>>[];

    for (int i = 0; i < 2; i++) {
      final pixels = List.generate(
        16,
        (_) => List.filled(16, Colors.transparent),
      );

      // Head bob
      final bob = (i == 0) ? 0 : 1;

      _fillRect(pixels, 6, 2 + bob, 4, 4, scheme.secondary);
      _fillRect(pixels, 5, 7, 6, 6, scheme.surface);
      _drawLine(pixels, 4, 8, 2, 10, scheme.primary);
      _drawLine(pixels, 11, 8, 13, 10, scheme.primary);
      _drawLine(pixels, 6, 13, 5, 15, scheme.primary);
      _drawLine(pixels, 9, 13, 10, 15, scheme.primary);

      frames.add(pixels);
    }

    return frames;
  }

  List<List<List<Color>>> _generateActionFrames(
    CharacterType type,
    ColorScheme scheme,
    int variant,
  ) {
    final frames = <List<List<Color>>>[];

    for (int i = 0; i < 3; i++) {
      final pixels = List.generate(
        16,
        (_) => List.filled(16, Colors.transparent),
      );

      _fillRect(pixels, 6, 2, 4, 4, scheme.secondary);
      _fillRect(pixels, 5, 7, 6, 6, scheme.surface);

      // Action pose
      if (i == 0) {
        _drawLine(pixels, 4, 8, 0, 8, scheme.primary); // Punching
        _drawLine(pixels, 11, 8, 15, 8, scheme.primary);
      } else if (i == 1) {
        _drawLine(pixels, 4, 8, 1, 6, scheme.primary); // Shooting
        _drawLine(pixels, 11, 8, 14, 10, scheme.primary);
      } else {
        _drawLine(pixels, 4, 8, 2, 10, scheme.primary); // Stabbing
        _drawLine(pixels, 11, 8, 13, 6, scheme.primary);
      }

      _drawLine(pixels, 6, 13, 5, 15, scheme.primary);
      _drawLine(pixels, 9, 13, 10, 15, scheme.primary);

      frames.add(pixels);
    }

    return frames;
  }

  List<ProceduralAnimation> _generateWeaponAnimations(
    WeaponType type,
    ColorScheme scheme,
    int variant,
  ) {
    final animations = <ProceduralAnimation>[];

    animations.add(
      ProceduralAnimation(
        type: AnimationType.idle,
        frames: _generateWeaponIdleFrames(type, scheme, variant),
        frameDuration: 300,
      ),
    );

    animations.add(
      ProceduralAnimation(
        type: AnimationType.action,
        frames: _generateWeaponActionFrames(type, scheme, variant),
        frameDuration: 150,
      ),
    );

    return animations;
  }

  List<List<List<Color>>> _generateWeaponIdleFrames(
    WeaponType type,
    ColorScheme scheme,
    int variant,
  ) {
    final frames = <List<List<Color>>>[];

    for (int i = 0; i < 2; i++) {
      final pixels = List.generate(
        16,
        (_) => List.filled(16, Colors.transparent),
      );

      // Slight bobbing motion
      final bob = (i == 0) ? 0 : 1;

      if (type == WeaponType.pistol) {
        _fillRect(pixels, 4 + bob, 8, 3, 6, scheme.secondary);
        _fillRect(pixels, 7 + bob, 6, 6, 2, scheme.primary);
      } else if (type == WeaponType.uzi) {
        _fillRect(pixels, 2 + bob, 6, 10, 4, scheme.primary);
        _fillRect(pixels, 12 + bob, 4, 2, 6, scheme.secondary);
      }

      frames.add(pixels);
    }

    return frames;
  }

  List<List<List<Color>>> _generateWeaponActionFrames(
    WeaponType type,
    ColorScheme scheme,
    int variant,
  ) {
    final frames = <List<List<Color>>>[];

    for (int i = 0; i < 3; i++) {
      final pixels = List.generate(
        16,
        (_) => List.filled(16, Colors.transparent),
      );

      if (type == WeaponType.pistol) {
        if (i == 0) {
          _fillRect(pixels, 4, 8, 3, 6, scheme.secondary);
          _fillRect(pixels, 7, 6, 6, 2, scheme.primary);
        } else if (i == 1) {
          // Recoil
          _fillRect(pixels, 4, 9, 3, 6, scheme.secondary);
          _fillRect(pixels, 7, 7, 6, 2, scheme.primary);
          // Muzzle flash
          _fillRect(pixels, 13, 6, 2, 2, Colors.yellow);
        } else {
          _fillRect(pixels, 4, 8, 3, 6, scheme.secondary);
          _fillRect(pixels, 7, 6, 6, 2, scheme.primary);
        }
      }

      frames.add(pixels);
    }

    return frames;
  }

  List<ProceduralAnimation> _generateVehicleAnimations(
    VehicleType type,
    ColorScheme scheme,
    int variant,
  ) {
    final animations = <ProceduralAnimation>[];

    animations.add(
      ProceduralAnimation(
        type: AnimationType.move,
        frames: _generateVehicleMoveFrames(type, scheme, variant),
        frameDuration: 200,
      ),
    );

    return animations;
  }

  List<List<List<Color>>> _generateVehicleMoveFrames(
    VehicleType type,
    ColorScheme scheme,
    int variant,
  ) {
    final frames = <List<List<Color>>>[];

    for (int i = 0; i < 4; i++) {
      final pixels = List.generate(
        24,
        (_) => List.filled(16, Colors.transparent),
      );

      // Moving wheels
      final wheelOffset = (i % 2 == 0) ? 0 : 1;

      // Body
      _fillRect(pixels, 4, 6, 16, 6, scheme.primary);

      // Wheels
      _fillRect(pixels, 6 + wheelOffset, 12, 2, 2, scheme.secondary);
      _fillRect(pixels, 16 + wheelOffset, 12, 2, 2, scheme.secondary);

      frames.add(pixels);
    }

    return frames;
  }

  List<ProceduralAnimation> _generateBuildingAnimations(
    BuildingType type,
    ColorScheme scheme,
    int variant,
  ) {
    final animations = <ProceduralAnimation>[];

    animations.add(
      ProceduralAnimation(
        type: AnimationType.idle,
        frames: _generateBuildingIdleFrames(type, scheme, variant),
        frameDuration: 1000,
      ),
    );

    return animations;
  }

  List<List<List<Color>>> _generateBuildingIdleFrames(
    BuildingType type,
    ColorScheme scheme,
    int variant,
  ) {
    final frames = <List<List<Color>>>[];

    for (int i = 0; i < 2; i++) {
      final pixels = List.generate(
        32,
        (_) => List.filled(32, Colors.transparent),
      );

      // Flickering lights
      final lightOn = (i == 0) || (variant % 3 == 0);

      _fillRect(pixels, 8, 12, 16, 20, scheme.primary);
      _drawTriangle(pixels, 6, 12, 24, 12, 15, 6, scheme.secondary);

      if (lightOn) {
        for (int j = 0; j < 3; j++) {
          for (int k = 0; k < 2; k++) {
            _fillRect(pixels, 10 + j * 4, 16 + k * 4, 2, 2, scheme.surface);
          }
        }
      }

      _fillRect(pixels, 14, 28, 4, 4, scheme.error);

      frames.add(pixels);
    }

    return frames;
  }

  // Parallax layer generation
  List<ParallaxLayer> _generateParallaxLayers(
    EnvironmentType type,
    ColorScheme scheme,
    int variant,
  ) {
    final layers = <ParallaxLayer>[];

    // Background layer (slowest)
    layers.add(
      ParallaxLayer(
        pixels: _generateParallaxBackground(type, scheme, variant),
        speed: 0.1,
        zIndex: 1,
      ),
    );

    // Midground layer (medium speed)
    layers.add(
      ParallaxLayer(
        pixels: _generateParallaxMidground(type, scheme, variant),
        speed: 0.5,
        zIndex: 2,
      ),
    );

    // Foreground layer (fastest)
    layers.add(
      ParallaxLayer(
        pixels: _generateParallaxForeground(type, scheme, variant),
        speed: 1.0,
        zIndex: 3,
      ),
    );

    return layers;
  }

  List<List<Color>> _generateParallaxBackground(
    EnvironmentType type,
    ColorScheme scheme,
    int variant,
  ) {
    final pixels = List.generate(
      128,
      (_) => List.filled(64, Colors.transparent),
    );

    // Distant buildings/skyline
    for (int i = 0; i < 20; i++) {
      final height = 10 + (variant + i) % 20;
      final width = 4 + (variant + i * 2) % 4;
      final x = i * 6 + (variant + i) % 3;

      _fillRect(
        pixels,
        x,
        32 - height,
        width,
        height,
        scheme.primary.withOpacity(0.5),
      );
    }

    return pixels;
  }

  List<List<Color>> _generateParallaxMidground(
    EnvironmentType type,
    ColorScheme scheme,
    int variant,
  ) {
    final pixels = List.generate(
      128,
      (_) => List.filled(64, Colors.transparent),
    );

    // Mid-range buildings
    for (int i = 0; i < 15; i++) {
      final height = 20 + (variant + i) % 25;
      final width = 6 + (variant + i * 2) % 6;
      final x = i * 8 + (variant + i) % 4;

      _fillRect(
        pixels,
        x,
        32 - height,
        width,
        height,
        scheme.primary.withOpacity(0.8),
      );

      // Windows
      for (int j = 0; j < height ~/ 4; j++) {
        for (int k = 0; k < width ~/ 2; k++) {
          if ((variant + i + j + k) % 3 == 0) {
            _fillRect(
              pixels,
              x + 1 + k * 2,
              32 - height + 2 + j * 4,
              1,
              2,
              scheme.surface.withOpacity(0.6),
            );
          }
        }
      }
    }

    return pixels;
  }

  List<List<Color>> _generateParallaxForeground(
    EnvironmentType type,
    ColorScheme scheme,
    int variant,
  ) {
    final pixels = List.generate(
      128,
      (_) => List.filled(64, Colors.transparent),
    );

    // Street level details
    _fillRect(pixels, 0, 48, 128, 16, scheme.secondary);

    // Street lamps
    for (int i = 0; i < 10; i++) {
      final x = i * 12 + (variant + i) % 4;
      _drawLine(pixels, x + 6, 40, x + 6, 48, scheme.primary);
      _fillRect(pixels, x + 4, 38, 4, 2, scheme.surface);
    }

    // Trash/debris
    for (int i = 0; i < 8; i++) {
      if ((variant + i) % 3 == 0) {
        _fillRect(pixels, 10 + i * 14, 50, 2, 2, scheme.error);
      }
    }

    return pixels;
  }

  int _randomColor(int minR, int minG, int minB, int alpha) {
    final r = minR + _random.nextInt(255 - minR);
    final g = minG + _random.nextInt(255 - minG);
    final b = minB + _random.nextInt(255 - minB);
    return (alpha << 24) | (r << 16) | (g << 8) | b;
  }
}

// Data classes for procedural generation

enum CharacterType { gangster, dealer, prostitute, victim, police }

enum BuildingType { crackhouse, gunshack, bank, bar, alleyway }

enum WeaponType { pistol, uzi, knife, bat }

enum VehicleType { car, motorcycle, truck }

enum EnvironmentType { city, alley, street }

enum ColorTheme { gangster, drug, violence, city, neon }

enum AnimationType { idle, walk, action, move }

enum DetailType { sign, trash, light, decoration }

// Extension to add colorTheme property to enums
extension CharacterTypeColorTheme on CharacterType {
  ColorTheme get colorTheme {
    switch (this) {
      case CharacterType.gangster:
      case CharacterType.police:
        return ColorTheme.gangster;
      case CharacterType.dealer:
        return ColorTheme.drug;
      case CharacterType.prostitute:
        return ColorTheme.violence;
      case CharacterType.victim:
        return ColorTheme.violence;
    }
  }
}

extension BuildingTypeColorTheme on BuildingType {
  ColorTheme get colorTheme {
    switch (this) {
      case BuildingType.crackhouse:
        return ColorTheme.drug;
      case BuildingType.gunshack:
        return ColorTheme.violence;
      case BuildingType.bank:
        return ColorTheme.city;
      case BuildingType.bar:
        return ColorTheme.gangster;
      case BuildingType.alleyway:
        return ColorTheme.violence;
    }
  }
}

extension WeaponTypeColorTheme on WeaponType {
  ColorTheme get colorTheme {
    switch (this) {
      case WeaponType.pistol:
      case WeaponType.uzi:
        return ColorTheme.violence;
      case WeaponType.knife:
      case WeaponType.bat:
        return ColorTheme.violence;
    }
  }
}

extension VehicleTypeColorTheme on VehicleType {
  ColorTheme get colorTheme {
    switch (this) {
      case VehicleType.car:
      case VehicleType.motorcycle:
      case VehicleType.truck:
        return ColorTheme.city;
    }
  }
}

extension EnvironmentTypeColorTheme on EnvironmentType {
  ColorTheme get colorTheme {
    switch (this) {
      case EnvironmentType.city:
        return ColorTheme.city;
      case EnvironmentType.alley:
        return ColorTheme.violence;
      case EnvironmentType.street:
        return ColorTheme.city;
    }
  }
}

class BuildingDetail {
  final DetailType type;
  final Offset position;
  final Color color;
  final String? text;

  BuildingDetail({
    required this.type,
    required this.position,
    required this.color,
    this.text,
  });
}

class ColorScheme {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color onError;

  ColorScheme({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.onError,
  });
}

class ProceduralCharacter {
  final CharacterType type;
  final ColorScheme colorScheme;
  final int variant;
  final List<List<Color>> pixels;
  final List<ProceduralAnimation> animations;

  ProceduralCharacter({
    required this.type,
    required this.colorScheme,
    required this.variant,
    required this.pixels,
    required this.animations,
  });
}

class ProceduralBuilding {
  final BuildingType type;
  final ColorScheme colorScheme;
  final int variant;
  final List<List<Color>> pixels;
  final List<ProceduralAnimation> animations;

  ProceduralBuilding({
    required this.type,
    required this.colorScheme,
    required this.variant,
    required this.pixels,
    required this.animations,
  });
}

class ProceduralWeapon {
  final WeaponType type;
  final ColorScheme colorScheme;
  final int variant;
  final List<List<Color>> pixels;
  final List<ProceduralAnimation> animations;

  ProceduralWeapon({
    required this.type,
    required this.colorScheme,
    required this.variant,
    required this.pixels,
    required this.animations,
  });
}

class ProceduralVehicle {
  final VehicleType type;
  final ColorScheme colorScheme;
  final int variant;
  final List<List<Color>> pixels;
  final List<ProceduralAnimation> animations;

  ProceduralVehicle({
    required this.type,
    required this.colorScheme,
    required this.variant,
    required this.pixels,
    required this.animations,
  });
}

class ProceduralEnvironment {
  final EnvironmentType type;
  final ColorScheme colorScheme;
  final int variant;
  final List<List<Color>> pixels;
  final List<ParallaxLayer> parallaxLayers;

  ProceduralEnvironment({
    required this.type,
    required this.colorScheme,
    required this.variant,
    required this.pixels,
    required this.parallaxLayers,
  });
}

class ProceduralAnimation {
  final AnimationType type;
  final List<List<List<Color>>> frames;
  final int frameDuration;

  ProceduralAnimation({
    required this.type,
    required this.frames,
    required this.frameDuration,
  });
}

class ParallaxLayer {
  final List<List<Color>> pixels;
  final double speed;
  final int zIndex;

  ParallaxLayer({
    required this.pixels,
    required this.speed,
    required this.zIndex,
  });
}
