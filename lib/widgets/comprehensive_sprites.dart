import 'package:flutter/material.dart';
import 'dart:math';
import 'pixel_art_member.dart';
import 'pixel_art_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Comprehensive Sprite System for Gang Wars
/// Provides pixelated sprites for all game situations, now using SVG assets where available.

class ComprehensiveSprites {
  /// Create a police officer sprite
  static Widget createPoliceSprite({
    required double size,
    required PoliceState state,
    bool isAnimated = true,
  }) {
    return PixelArtMember(
      isPlayer: false,
      isAlive: state != PoliceState.dead,
      size: size,
      enemyType: 'Police Officers',
      isCheering: state == PoliceState.shooting, // Using as action state
    );
  }

  /// Create a civilian sprite
  static Widget createCivilianSprite({
    required double size,
    required CivilianState state,
    required CivilianType type,
    bool isAnimated = true,
  }) {
    // Map civilian types to available NPC assets
    String npcType = 'Street Thug';
    switch (type) {
      case CivilianType.homeless:
        npcType = 'Homeless Person';
        break;
      case CivilianType.man:
        npcType = 'Street Punk';
        break;
      default:
        npcType = 'Street Thug';
    }

    return PixelArtMember(
      isPlayer: false,
      isAlive: state != CivilianState.dead,
      size: size,
      enemyType: npcType,
    );
  }

  /// Create a drug sprite with different types
  static Widget createDrugSprite({
    required double size,
    required DrugType type,
    required DrugState state,
    bool isAnimated = true,
  }) {
    return PixelArtIcon(
      name: type.name,
      size: size,
    );
  }

  /// Create a money sprite with different denominations
  static Widget createMoneySprite({
    required double size,
    required MoneyDenomination denomination,
    required MoneyState state,
    bool isAnimated = true,
  }) {
    return _MoneySprite(
      size: size,
      denomination: denomination,
      state: state,
      isAnimated: isAnimated,
    );
  }

  /// Create a vehicle sprite with different types
  static Widget createVehicleSprite({
    required double size,
    required VehicleType type,
    required VehicleState state,
    bool isAnimated = true,
  }) {
    return _VehicleSprite(
      size: size,
      type: type,
      state: state,
      isAnimated: isAnimated,
    );
  }

  /// Create a building sprite with different types
  static Widget createBuildingSprite({
    required double size,
    required BuildingType type,
    required BuildingState state,
    bool isAnimated = true,
  }) {
    return _BuildingSprite(
      size: size,
      type: type,
      state: state,
      isAnimated: isAnimated,
    );
  }

  /// Create a weapon sprite with different types
  static Widget createWeaponSprite({
    required double size,
    required WeaponType type,
    required WeaponState state,
    bool isAnimated = true,
  }) {
    return PixelArtIcon(
      name: type.name,
      size: size,
    );
  }

  /// Create a special effect sprite
  static Widget createEffectSprite({
    required double size,
    required EffectType type,
    required EffectState state,
    bool isAnimated = true,
  }) {
    return _EffectSprite(
      size: size,
      type: type,
      state: state,
      isAnimated: isAnimated,
    );
  }

  /// Create a UI element sprite
  static Widget createUISprite({
    required double size,
    required UIType type,
    required UIState state,
    bool isAnimated = true,
  }) {
    return _UISprite(
      size: size,
      type: type,
      state: state,
      isAnimated: isAnimated,
    );
  }

  /// Create a health/armor sprite
  static Widget createHealthSprite({
    required double size,
    required HealthType type,
    required HealthState state,
    bool isAnimated = true,
  }) {
    return _HealthSprite(
      size: size,
      type: type,
      state: state,
      isAnimated: isAnimated,
    );
  }
}

// Enums for sprite types
enum PoliceState { idle, alert, chasing, shooting, arresting, hurt, dead }

enum CivilianState { idle, walking, running, scared, dead }

enum CivilianType { man, woman, child, elderly, homeless }

enum DrugState { idle, floating, collected, consumed }

enum DrugType { weed, crack, coke, ice, percs, pixie }

enum MoneyState { idle, floating, collected, counting }

enum MoneyDenomination {
  penny,
  nickel,
  dime,
  quarter,
  dollar,
  five,
  ten,
  twenty,
  fifty,
  hundred,
}

enum VehicleState { idle, moving, crashed, exploding }

enum VehicleType { car, truck, motorcycle, police, ambulance, taxi }

enum BuildingState { idle, damaged, burning, destroyed }

enum BuildingType {
  house,
  store,
  bank,
  bar,
  crackhouse,
  gunshack,
  hospital,
  police,
}

enum WeaponState { idle, firing, reloading, dropped }

enum WeaponType { pistol, uzi, ar15, shotgun, knife, bat, grenade, vest }

enum EffectState { idle, active, fading }

enum EffectType { muzzleFlash, explosion, blood, smoke, fire, spark, trail }

enum UIState { idle, active, selected, disabled }

enum UIType { button, icon, bar, frame, cursor, menu }

enum HealthState { idle, active, damaged, healed }

enum HealthType { heart, shield, pill, bandage, firstAid }

// Money Sprite Implementation
class _MoneySprite extends StatefulWidget {
  final double size;
  final MoneyDenomination denomination;
  final MoneyState state;
  final bool isAnimated;

  const _MoneySprite({
    required this.size,
    required this.denomination,
    required this.state,
    required this.isAnimated,
  });

  @override
  _MoneySpriteState createState() => _MoneySpriteState();
}

class _MoneySpriteState extends State<_MoneySprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _spinAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    if (widget.isAnimated) {
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
          offset: Offset(0, sin(_floatAnimation.value) * 2),
          child: Transform.rotate(
            angle: widget.state == MoneyState.counting
                ? _spinAnimation.value
                : 0,
            child: CustomPaint(
              painter: _MoneyPainter(
                denomination: widget.denomination,
                state: widget.state,
              ),
              size: Size(widget.size, widget.size),
            ),
          ),
        );
      },
    );
  }
}

class _MoneyPainter extends CustomPainter {
  final MoneyDenomination denomination;
  final MoneyState state;

  _MoneyPainter({required this.denomination, required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final pixelSize = size.width / 16;

    void drawPixel(int x, int y, Color color) {
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint..color = color,
      );
    }

    // Get money-specific colors
    Color moneyColor;
    Color textColor;

    switch (denomination) {
      case MoneyDenomination.penny:
        moneyColor = Colors.brown.shade600;
        textColor = Colors.brown.shade900;
        break;
      case MoneyDenomination.nickel:
        moneyColor = Colors.grey.shade400;
        textColor = Colors.grey.shade700;
        break;
      case MoneyDenomination.dime:
        moneyColor = Colors.grey.shade300;
        textColor = Colors.grey.shade600;
        break;
      case MoneyDenomination.quarter:
        moneyColor = Colors.grey.shade400;
        textColor = Colors.grey.shade700;
        break;
      case MoneyDenomination.dollar:
        moneyColor = Colors.green.shade600;
        textColor = Colors.green.shade900;
        break;
      case MoneyDenomination.five:
        moneyColor = Colors.purple.shade400;
        textColor = Colors.purple.shade800;
        break;
      case MoneyDenomination.ten:
        moneyColor = Colors.yellow.shade600;
        textColor = Colors.yellow.shade900;
        break;
      case MoneyDenomination.twenty:
        moneyColor = Colors.green.shade500;
        textColor = Colors.green.shade800;
        break;
      case MoneyDenomination.fifty:
        moneyColor = Colors.red.shade400;
        textColor = Colors.red.shade800;
        break;
      case MoneyDenomination.hundred:
        moneyColor = Colors.blue.shade400;
        textColor = Colors.blue.shade800;
        break;
    }

    // Draw money shape based on denomination
    if (denomination == MoneyDenomination.penny ||
        denomination == MoneyDenomination.nickel ||
        denomination == MoneyDenomination.dime ||
        denomination == MoneyDenomination.quarter) {
      // Coin shape
      for (int x = 6; x < 11; x++) {
        for (int y = 6; y < 11; y++) {
          drawPixel(x, y, moneyColor);
        }
      }
      // Coin edge
      drawPixel(5, 7, moneyColor);
      drawPixel(5, 8, moneyColor);
      drawPixel(5, 9, moneyColor);
      drawPixel(11, 7, moneyColor);
      drawPixel(11, 8, moneyColor);
      drawPixel(11, 9, moneyColor);
      drawPixel(7, 5, moneyColor);
      drawPixel(8, 5, moneyColor);
      drawPixel(9, 5, moneyColor);
      drawPixel(7, 11, moneyColor);
      drawPixel(8, 11, moneyColor);
      drawPixel(9, 11, moneyColor);
    } else {
      // Bill shape
      for (int x = 4; x < 13; x++) {
        for (int y = 6; y < 11; y++) {
          drawPixel(x, y, moneyColor);
        }
      }
      // Bill border
      for (int x = 4; x < 13; x++) {
        drawPixel(x, 5, textColor);
        drawPixel(x, 11, textColor);
      }
      for (int y = 6; y < 11; y++) {
        drawPixel(4, y, textColor);
        drawPixel(12, y, textColor);
      }
    }

    // Add denomination indicator
    drawPixel(8, 8, textColor);

    // Add collected effect
    if (state == MoneyState.collected) {
      final glowPaint = Paint()
        ..color = Colors.yellow.withValues(alpha: 0.5)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MoneyPainter oldDelegate) => true;
}

// Vehicle Sprite Implementation
class _VehicleSprite extends StatefulWidget {
  final double size;
  final VehicleType type;
  final VehicleState state;
  final bool isAnimated;

  const _VehicleSprite({
    required this.size,
    required this.type,
    required this.state,
    required this.isAnimated,
  });

  @override
  _VehicleSpriteState createState() => _VehicleSpriteState();
}

class _VehicleSpriteState extends State<_VehicleSprite>
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

    if (widget.isAnimated && widget.state == VehicleState.moving) {
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
              type: widget.type,
              state: widget.state,
              wheelRotation: _wheelAnimation.value,
            ),
            size: Size(widget.size * 2, widget.size),
          ),
        );
      },
    );
  }
}

class _VehiclePainter extends CustomPainter {
  final VehicleType type;
  final VehicleState state;
  final double wheelRotation;

  _VehiclePainter({
    required this.type,
    required this.state,
    required this.wheelRotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final pixelSize = size.width / 32;

    void drawPixel(int x, int y, Color color) {
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint..color = color,
      );
    }

    // Get vehicle-specific colors
    Color bodyColor;
    Color windowColor;
    Color wheelColor;

    switch (type) {
      case VehicleType.car:
        bodyColor = Colors.blue.shade800;
        windowColor = Colors.lightBlue.shade200;
        wheelColor = Colors.black;
        break;
      case VehicleType.truck:
        bodyColor = Colors.brown.shade700;
        windowColor = Colors.lightBlue.shade200;
        wheelColor = Colors.black;
        break;
      case VehicleType.motorcycle:
        bodyColor = Colors.red.shade700;
        windowColor = Colors.transparent;
        wheelColor = Colors.black;
        break;
      case VehicleType.police:
        bodyColor = Colors.blue.shade900;
        windowColor = Colors.lightBlue.shade200;
        wheelColor = Colors.black;
        break;
      case VehicleType.ambulance:
        bodyColor = Colors.white;
        windowColor = Colors.lightBlue.shade200;
        wheelColor = Colors.black;
        break;
      case VehicleType.taxi:
        bodyColor = Colors.yellow.shade600;
        windowColor = Colors.lightBlue.shade200;
        wheelColor = Colors.black;
        break;
    }

    // Draw vehicle body
    if (type == VehicleType.motorcycle) {
      // Motorcycle body
      for (int x = 8; x < 24; x++) {
        for (int y = 8; y < 14; y++) {
          drawPixel(x, y, bodyColor);
        }
      }
      // Seat
      for (int x = 12; x < 20; x++) {
        for (int y = 6; y < 8; y++) {
          drawPixel(x, y, Colors.black);
        }
      }
    } else {
      // Car/truck body
      for (int x = 4; x < 28; x++) {
        for (int y = 8; y < 16; y++) {
          drawPixel(x, y, bodyColor);
        }
      }
      // Roof
      for (int x = 8; x < 24; x++) {
        for (int y = 4; y < 8; y++) {
          drawPixel(x, y, bodyColor);
        }
      }
    }

    // Draw windows
    if (type != VehicleType.motorcycle) {
      for (int x = 10; x < 22; x++) {
        for (int y = 5; y < 8; y++) {
          drawPixel(x, y, windowColor);
        }
      }
    }

    // Draw wheels with rotation
    final wheelOffset = (wheelRotation / (2 * pi)).toInt() % 2;

    if (type == VehicleType.motorcycle) {
      // Motorcycle wheels
      for (int x = 6; x < 10; x++) {
        for (int y = 14; y < 18; y++) {
          if ((x + y + wheelOffset) % 2 == 0) {
            drawPixel(x, y, wheelColor);
          }
        }
      }
      for (int x = 22; x < 26; x++) {
        for (int y = 14; y < 18; y++) {
          if ((x + y + wheelOffset) % 2 == 0) {
            drawPixel(x, y, wheelColor);
          }
        }
      }
    } else {
      // Car/truck wheels
      for (int x = 6; x < 12; x++) {
        for (int y = 16; y < 20; y++) {
          if ((x + y + wheelOffset) % 2 == 0) {
            drawPixel(x, y, wheelColor);
          }
        }
      }
      for (int x = 20; x < 26; x++) {
        for (int y = 16; y < 20; y++) {
          if ((x + y + wheelOffset) % 2 == 0) {
            drawPixel(x, y, wheelColor);
          }
        }
      }
    }

    // Draw lights
    if (type == VehicleType.police) {
      // Police lights
      drawPixel(4, 6, Colors.red);
      drawPixel(4, 7, Colors.blue);
    } else if (type == VehicleType.ambulance) {
      // Ambulance cross
      drawPixel(14, 6, Colors.red);
      drawPixel(15, 6, Colors.red);
      drawPixel(14, 7, Colors.red);
      drawPixel(15, 7, Colors.red);
    } else {
      // Regular headlights
      drawPixel(4, 9, Colors.yellow);
      drawPixel(4, 10, Colors.yellow);
    }

    // Draw taillights
    drawPixel(27, 9, Colors.red);
    drawPixel(27, 10, Colors.red);

    // State-specific effects
    if (state == VehicleState.crashed) {
      // Crash damage
      for (int x = 10; x < 22; x++) {
        for (int y = 8; y < 16; y++) {
          if ((x + y) % 3 == 0) {
            drawPixel(x, y, Colors.grey.shade600);
          }
        }
      }
    } else if (state == VehicleState.exploding) {
      // Explosion effect
      final explosionPaint = Paint()
        ..color = Colors.orange.withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 3,
        explosionPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VehiclePainter oldDelegate) => true;
}

// Building Sprite Implementation
class _BuildingSprite extends StatefulWidget {
  final double size;
  final BuildingType type;
  final BuildingState state;
  final bool isAnimated;

  const _BuildingSprite({
    required this.size,
    required this.type,
    required this.state,
    required this.isAnimated,
  });

  @override
  _BuildingSpriteState createState() => _BuildingSpriteState();
}

class _BuildingSpriteState extends State<_BuildingSprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flickerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _flickerAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isAnimated) {
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
    // Try to find an SVG for the building
    String assetName = widget.type.name;
    String assetPath = 'assets/images/buildings/$assetName.svg';

    return SizedBox(
      width: widget.size,
      height: widget.size * 1.5,
      child: SvgPicture.asset(
        assetPath,
        placeholderBuilder: (context) => AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _BuildingPainter(
                type: widget.type,
                state: widget.state,
                flickerValue: _flickerAnimation.value,
              ),
              size: Size(widget.size, widget.size * 1.5),
            );
          },
        ),
      ),
    );
  }
}

class _BuildingPainter extends CustomPainter {
  final BuildingType type;
  final BuildingState state;
  final double flickerValue;

  _BuildingPainter({
    required this.type,
    required this.state,
    required this.flickerValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final pixelSize = size.width / 32;

    void drawPixel(int x, int y, Color color) {
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint..color = color,
      );
    }

    // Get building-specific colors
    Color wallColor;
    Color roofColor;
    Color windowColor;
    Color doorColor;

    switch (type) {
      case BuildingType.house:
        wallColor = Colors.brown.shade600;
        roofColor = Colors.red.shade800;
        windowColor = Colors.lightBlue.shade200;
        doorColor = Colors.brown.shade800;
        break;
      case BuildingType.store:
        wallColor = Colors.grey.shade600;
        roofColor = Colors.grey.shade800;
        windowColor = Colors.lightBlue.shade200;
        doorColor = Colors.brown.shade700;
        break;
      case BuildingType.bank:
        wallColor = Colors.grey.shade500;
        roofColor = Colors.red.shade900;
        windowColor = Colors.blue.shade300;
        doorColor = Colors.brown.shade800;
        break;
      case BuildingType.bar:
        wallColor = Colors.brown.shade700;
        roofColor = Colors.grey.shade800;
        windowColor = Colors.amber.shade300;
        doorColor = Colors.black;
        break;
      case BuildingType.crackhouse:
        wallColor = Colors.grey.shade700;
        roofColor = Colors.grey.shade900;
        windowColor = Colors.yellow.shade200;
        doorColor = Colors.brown.shade900;
        break;
      case BuildingType.gunshack:
        wallColor = Colors.green.shade800;
        roofColor = Colors.brown.shade800;
        windowColor = Colors.blue.shade400;
        doorColor = Colors.black;
        break;
      case BuildingType.hospital:
        wallColor = Colors.white;
        roofColor = Colors.grey.shade300;
        windowColor = Colors.lightBlue.shade200;
        doorColor = Colors.grey.shade600;
        break;
      case BuildingType.police:
        wallColor = Colors.blue.shade800;
        roofColor = Colors.blue.shade900;
        windowColor = Colors.lightBlue.shade200;
        doorColor = Colors.brown.shade800;
        break;
    }

    // Draw building structure
    for (int x = 4; x < 28; x++) {
      for (int y = 12; y < 32; y++) {
        drawPixel(x, y, wallColor);
      }
    }

    // Draw roof
    for (int x = 2; x < 30; x++) {
      for (int y = 8; y < 12; y++) {
        drawPixel(x, y, roofColor);
      }
    }

    // Draw windows
    for (int wx = 6; wx < 11; wx++) {
      for (int wy = 16; wy < 20; wy++) {
        drawPixel(wx, wy, windowColor);
      }
    }
    for (int wx = 21; wx < 26; wx++) {
      for (int wy = 16; wy < 20; wy++) {
        drawPixel(wx, wy, windowColor);
      }
    }

    // Draw door
    for (int x = 14; x < 18; x++) {
      for (int y = 26; y < 32; y++) {
        drawPixel(x, y, doorColor);
      }
    }

    // Draw building-specific details
    if (type == BuildingType.bank) {
      // Bank sign
      for (int x = 12; x < 20; x++) {
        drawPixel(x, 10, Colors.yellow);
      }
    } else if (type == BuildingType.bar) {
      // Bar sign
      for (int x = 12; x < 20; x++) {
        drawPixel(x, 10, Colors.red);
      }
    } else if (type == BuildingType.police) {
      // Police badge
      drawPixel(16, 10, Colors.yellow);
    } else if (type == BuildingType.hospital) {
      // Hospital cross
      drawPixel(16, 10, Colors.red);
      drawPixel(15, 10, Colors.red);
      drawPixel(17, 10, Colors.red);
      drawPixel(16, 9, Colors.red);
      drawPixel(16, 11, Colors.red);
    }

    // State-specific effects
    if (state == BuildingState.damaged) {
      // Damage marks
      for (int x = 8; x < 24; x++) {
        for (int y = 14; y < 30; y++) {
          if ((x + y) % 4 == 0) {
            drawPixel(x, y, Colors.grey.shade600);
          }
        }
      }
    } else if (state == BuildingState.burning) {
      // Fire effect
      final firePaint = Paint()
        ..color = Colors.orange.withValues(alpha: flickerValue)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 3),
        size.width / 4,
        firePaint,
      );
    } else if (state == BuildingState.destroyed) {
      // Rubble
      for (int x = 4; x < 28; x++) {
        for (int y = 20; y < 32; y++) {
          if ((x + y) % 2 == 0) {
            drawPixel(x, y, Colors.grey.shade600);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BuildingPainter oldDelegate) => true;
}

// Effect Sprite Implementation
class _EffectSprite extends StatefulWidget {
  final double size;
  final EffectType type;
  final EffectState state;
  final bool isAnimated;

  const _EffectSprite({
    required this.size,
    required this.type,
    required this.state,
    required this.isAnimated,
  });

  @override
  _EffectSpriteState createState() => _EffectSpriteState();
}

class _EffectSpriteState extends State<_EffectSprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    if (widget.isAnimated) {
      _controller.forward();
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
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: CustomPaint(
              painter: _EffectPainter(type: widget.type, state: widget.state),
              size: Size(widget.size, widget.size),
            ),
          ),
        );
      },
    );
  }
}

class _EffectPainter extends CustomPainter {
  final EffectType type;
  final EffectState state;

  _EffectPainter({required this.type, required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    switch (type) {
      case EffectType.muzzleFlash:
        paint.color = Colors.yellow;
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 3,
          paint,
        );
        paint.color = Colors.orange;
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 4,
          paint,
        );
        break;

      case EffectType.explosion:
        paint.color = Colors.orange;
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 2,
          paint,
        );
        paint.color = Colors.red;
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 3,
          paint,
        );
        paint.color = Colors.yellow;
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 4,
          paint,
        );
        break;

      case EffectType.blood:
        paint.color = Colors.red.shade900;
        for (int i = 0; i < 8; i++) {
          final angle = i * pi / 4;
          final x = size.width / 2 + cos(angle) * size.width / 4;
          final y = size.height / 2 + sin(angle) * size.height / 4;
          canvas.drawCircle(Offset(x, y), size.width / 8, paint);
        }
        break;

      case EffectType.smoke:
        paint.color = Colors.grey.withValues(alpha: 0.6);
        for (int i = 0; i < 5; i++) {
          final x = size.width / 2 + (i - 2) * size.width / 8;
          final y = size.height / 2;
          canvas.drawCircle(Offset(x, y), size.width / 6, paint);
        }
        break;

      case EffectType.fire:
        paint.color = Colors.orange;
        for (int i = 0; i < 6; i++) {
          final x = size.width / 2 + (i - 2.5) * size.width / 10;
          final y = size.height / 2;
          canvas.drawCircle(Offset(x, y), size.width / 8, paint);
        }
        paint.color = Colors.yellow;
        for (int i = 0; i < 4; i++) {
          final x = size.width / 2 + (i - 1.5) * size.width / 8;
          final y = size.height / 2;
          canvas.drawCircle(Offset(x, y), size.width / 10, paint);
        }
        break;

      case EffectType.spark:
        paint.color = Colors.yellow;
        for (int i = 0; i < 12; i++) {
          final angle = i * pi / 6;
          final x = size.width / 2 + cos(angle) * size.width / 3;
          final y = size.height / 2 + sin(angle) * size.height / 3;
          canvas.drawRect(Rect.fromLTWH(x - 1, y - 1, 2, 2), paint);
        }
        break;

      case EffectType.trail:
        paint.color = Colors.blue.withValues(alpha: 0.7);
        for (int i = 0; i < 8; i++) {
          final x = size.width / 8 + i * size.width / 8;
          final y = size.height / 2;
          canvas.drawCircle(Offset(x, y), size.width / 12, paint);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _EffectPainter oldDelegate) => true;
}

// UI Sprite Implementation
class _UISprite extends StatefulWidget {
  final double size;
  final UIType type;
  final UIState state;
  final bool isAnimated;

  const _UISprite({
    required this.size,
    required this.type,
    required this.state,
    required this.isAnimated,
  });

  @override
  _UISpriteState createState() => _UISpriteState();
}

class _UISpriteState extends State<_UISprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isAnimated && widget.state == UIState.active) {
      _controller.repeat(reverse: true);
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
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: CustomPaint(
            painter: _UIPainter(type: widget.type, state: widget.state),
            size: Size(widget.size, widget.size),
          ),
        );
      },
    );
  }
}

class _UIPainter extends CustomPainter {
  final UIType type;
  final UIState state;

  _UIPainter({required this.type, required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final pixelSize = size.width / 16;

    void drawPixel(int x, int y, Color color) {
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint..color = color,
      );
    }

    // Get UI-specific colors
    Color primaryColor;
    Color secondaryColor;
    Color accentColor;

    switch (state) {
      case UIState.idle:
        primaryColor = Colors.grey.shade600;
        secondaryColor = Colors.grey.shade800;
        accentColor = Colors.grey.shade400;
        break;
      case UIState.active:
        primaryColor = Colors.blue.shade600;
        secondaryColor = Colors.blue.shade800;
        accentColor = Colors.blue.shade400;
        break;
      case UIState.selected:
        primaryColor = Colors.green.shade600;
        secondaryColor = Colors.green.shade800;
        accentColor = Colors.green.shade400;
        break;
      case UIState.disabled:
        primaryColor = Colors.grey.shade400;
        secondaryColor = Colors.grey.shade600;
        accentColor = Colors.grey.shade300;
        break;
    }

    switch (type) {
      case UIType.button:
        // Button background
        for (int x = 2; x < 14; x++) {
          for (int y = 4; y < 12; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        // Button border
        for (int x = 2; x < 14; x++) {
          drawPixel(x, 3, secondaryColor);
          drawPixel(x, 12, secondaryColor);
        }
        for (int y = 4; y < 12; y++) {
          drawPixel(2, y, secondaryColor);
          drawPixel(13, y, secondaryColor);
        }
        // Button highlight
        for (int x = 3; x < 13; x++) {
          drawPixel(x, 4, accentColor);
        }
        break;

      case UIType.icon:
        // Icon background
        for (int x = 4; x < 12; x++) {
          for (int y = 4; y < 12; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        // Icon symbol (star)
        drawPixel(8, 5, accentColor);
        drawPixel(7, 6, accentColor);
        drawPixel(9, 6, accentColor);
        drawPixel(6, 7, accentColor);
        drawPixel(8, 7, accentColor);
        drawPixel(10, 7, accentColor);
        drawPixel(7, 8, accentColor);
        drawPixel(9, 8, accentColor);
        drawPixel(8, 9, accentColor);
        break;

      case UIType.bar:
        // Bar background
        for (int x = 2; x < 14; x++) {
          for (int y = 6; y < 10; y++) {
            drawPixel(x, y, secondaryColor);
          }
        }
        // Bar fill
        for (int x = 3; x < 11; x++) {
          for (int y = 7; y < 9; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        break;

      case UIType.frame:
        // Frame border
        for (int x = 2; x < 14; x++) {
          drawPixel(x, 2, primaryColor);
          drawPixel(x, 13, primaryColor);
        }
        for (int y = 3; y < 13; y++) {
          drawPixel(2, y, primaryColor);
          drawPixel(13, y, primaryColor);
        }
        // Frame corners
        drawPixel(2, 2, accentColor);
        drawPixel(13, 2, accentColor);
        drawPixel(2, 13, accentColor);
        drawPixel(13, 13, accentColor);
        break;

      case UIType.cursor:
        // Cursor arrow
        for (int x = 4; x < 8; x++) {
          for (int y = 4; y < 8; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        for (int x = 8; x < 12; x++) {
          for (int y = 8; y < 12; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        drawPixel(12, 12, primaryColor);
        break;

      case UIType.menu:
        // Menu background
        for (int x = 2; x < 14; x++) {
          for (int y = 2; y < 14; y++) {
            drawPixel(x, y, secondaryColor);
          }
        }
        // Menu items
        for (int x = 4; x < 12; x++) {
          for (int y = 4; y < 6; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        for (int x = 4; x < 12; x++) {
          for (int y = 7; y < 9; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        for (int x = 4; x < 12; x++) {
          for (int y = 10; y < 12; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _UIPainter oldDelegate) => true;
}

// Health Sprite Implementation
class _HealthSprite extends StatefulWidget {
  final double size;
  final HealthType type;
  final HealthState state;
  final bool isAnimated;

  const _HealthSprite({
    required this.size,
    required this.type,
    required this.state,
    required this.isAnimated,
  });

  @override
  _HealthSpriteState createState() => _HealthSpriteState();
}

class _HealthSpriteState extends State<_HealthSprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isAnimated && widget.state == HealthState.active) {
      _controller.repeat(reverse: true);
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
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: CustomPaint(
            painter: _HealthPainter(type: widget.type, state: widget.state),
            size: Size(widget.size, widget.size),
          ),
        );
      },
    );
  }
}

class _HealthPainter extends CustomPainter {
  final HealthType type;
  final HealthState state;

  _HealthPainter({required this.type, required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final pixelSize = size.width / 16;

    void drawPixel(int x, int y, Color color) {
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint..color = color,
      );
    }

    // Get health-specific colors
    Color primaryColor;
    Color secondaryColor;

    switch (state) {
      case HealthState.idle:
        primaryColor = Colors.red.shade600;
        secondaryColor = Colors.red.shade800;
        break;
      case HealthState.active:
        primaryColor = Colors.red.shade400;
        secondaryColor = Colors.red.shade600;
        break;
      case HealthState.damaged:
        primaryColor = Colors.grey.shade600;
        secondaryColor = Colors.grey.shade800;
        break;
      case HealthState.healed:
        primaryColor = Colors.green.shade400;
        secondaryColor = Colors.green.shade600;
        break;
    }

    switch (type) {
      case HealthType.heart:
        // Heart shape
        drawPixel(6, 5, primaryColor);
        drawPixel(7, 4, primaryColor);
        drawPixel(8, 4, primaryColor);
        drawPixel(9, 5, primaryColor);
        drawPixel(10, 4, primaryColor);
        drawPixel(11, 4, primaryColor);
        drawPixel(12, 5, primaryColor);
        for (int x = 5; x < 13; x++) {
          for (int y = 6; y < 10; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        for (int x = 6; x < 12; x++) {
          for (int y = 10; y < 12; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        drawPixel(7, 12, primaryColor);
        drawPixel(8, 12, primaryColor);
        drawPixel(9, 12, primaryColor);
        drawPixel(8, 13, primaryColor);
        break;

      case HealthType.shield:
        // Shield shape
        for (int x = 4; x < 12; x++) {
          for (int y = 4; y < 12; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        for (int x = 5; x < 11; x++) {
          for (int y = 12; y < 14; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        drawPixel(6, 14, primaryColor);
        drawPixel(7, 14, primaryColor);
        drawPixel(8, 14, primaryColor);
        drawPixel(9, 14, primaryColor);
        // Shield emblem
        drawPixel(7, 7, secondaryColor);
        drawPixel(8, 7, secondaryColor);
        drawPixel(7, 8, secondaryColor);
        drawPixel(8, 8, secondaryColor);
        break;

      case HealthType.pill:
        // Pill shape
        for (int x = 5; x < 11; x++) {
          for (int y = 7; y < 10; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        drawPixel(4, 8, primaryColor);
        drawPixel(11, 8, primaryColor);
        // Pill divider
        for (int x = 7; x < 9; x++) {
          drawPixel(x, 8, Colors.white);
        }
        break;

      case HealthType.bandage:
        // Bandage shape
        for (int x = 4; x < 12; x++) {
          for (int y = 6; y < 10; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        // Bandage pattern
        for (int x = 5; x < 11; x++) {
          drawPixel(x, 7, secondaryColor);
          drawPixel(x, 9, secondaryColor);
        }
        break;

      case HealthType.firstAid:
        // First aid kit
        for (int x = 4; x < 12; x++) {
          for (int y = 4; y < 12; y++) {
            drawPixel(x, y, primaryColor);
          }
        }
        // Cross symbol
        for (int x = 7; x < 9; x++) {
          for (int y = 5; y < 11; y++) {
            drawPixel(x, y, Colors.white);
          }
        }
        for (int x = 5; x < 11; x++) {
          for (int y = 7; y < 9; y++) {
            drawPixel(x, y, Colors.white);
          }
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _HealthPainter oldDelegate) => true;
}
