import 'package:flutter/material.dart';
import 'dart:math';

/// Comprehensive Sprite System for Gang Wars
/// Provides pixelated sprites for all game situations

class ComprehensiveSprites {
  /// Create a police officer sprite
  static Widget createPoliceSprite({
    required double size,
    required PoliceState state,
    bool isAnimated = true,
  }) {
    return _PoliceSprite(size: size, state: state, isAnimated: isAnimated);
  }

  /// Create a civilian sprite
  static Widget createCivilianSprite({
    required double size,
    required CivilianState state,
    required CivilianType type,
    bool isAnimated = true,
  }) {
    return _CivilianSprite(
      size: size,
      state: state,
      type: type,
      isAnimated: isAnimated,
    );
  }

  /// Create a drug sprite with different types
  static Widget createDrugSprite({
    required double size,
    required DrugType type,
    required DrugState state,
    bool isAnimated = true,
  }) {
    return _DrugSprite(
      size: size,
      type: type,
      state: state,
      isAnimated: isAnimated,
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
    return _WeaponSprite(
      size: size,
      type: type,
      state: state,
      isAnimated: isAnimated,
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

// Police Sprite Implementation
class _PoliceSprite extends StatefulWidget {
  final double size;
  final PoliceState state;
  final bool isAnimated;

  const _PoliceSprite({
    required this.size,
    required this.state,
    required this.isAnimated,
  });

  @override
  _PoliceSpriteState createState() => _PoliceSpriteState();
}

class _PoliceSpriteState extends State<_PoliceSprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bobAnimation;
  late Animation<double> _alertAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _bobAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _alertAnimation = Tween<double>(
      begin: 0.0,
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, sin(_bobAnimation.value) * 2),
          child: CustomPaint(
            painter: _PolicePainter(
              state: widget.state,
              alertValue: _alertAnimation.value,
            ),
            size: Size(widget.size, widget.size),
          ),
        );
      },
    );
  }
}

class _PolicePainter extends CustomPainter {
  final PoliceState state;
  final double alertValue;

  _PolicePainter({required this.state, required this.alertValue});

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

    // Head
    final skinColor = Colors.brown.shade300;
    for (int x = 6; x < 11; x++) {
      for (int y = 2; y < 7; y++) {
        drawPixel(x, y, skinColor);
      }
    }

    // Police hat
    final hatColor = Colors.blue.shade900;
    for (int x = 5; x < 12; x++) {
      drawPixel(x, 2, hatColor);
    }
    for (int x = 6; x < 11; x++) {
      drawPixel(x, 1, hatColor);
    }

    // Badge
    drawPixel(8, 3, Colors.yellow);

    // Eyes
    drawPixel(7, 4, Colors.black);
    drawPixel(9, 4, Colors.black);

    // Body (police uniform)
    final uniformColor = Colors.blue.shade800;
    for (int x = 5; x < 12; x++) {
      for (int y = 7; y < 13; y++) {
        drawPixel(x, y, uniformColor);
      }
    }

    // Badge on chest
    drawPixel(8, 8, Colors.yellow);

    // Arms
    final armColor = skinColor;
    if (state == PoliceState.shooting) {
      // Shooting pose
      for (int x = 2; x < 6; x++) {
        drawPixel(x, 8, armColor);
      }
      // Gun
      for (int x = 1; x < 4; x++) {
        drawPixel(x, 7, Colors.grey.shade800);
      }
    } else if (state == PoliceState.arresting) {
      // Arresting pose
      for (int x = 2; x < 6; x++) {
        drawPixel(x, 7, armColor);
      }
      for (int x = 11; x < 15; x++) {
        drawPixel(x, 7, armColor);
      }
    } else {
      // Normal pose
      for (int y = 8; y < 11; y++) {
        drawPixel(4, y, armColor);
        drawPixel(12, y, armColor);
      }
    }

    // Legs
    final legColor = Colors.blue.shade900;
    for (int x = 5; x < 8; x++) {
      for (int y = 13; y < 16; y++) {
        drawPixel(x, y, legColor);
      }
    }
    for (int x = 9; x < 12; x++) {
      for (int y = 13; y < 16; y++) {
        drawPixel(x, y, legColor);
      }
    }

    // State-specific effects
    if (state == PoliceState.alert) {
      // Alert indicator
      final alertColor = Colors.red.withValues(alpha: alertValue);
      drawPixel(13, 1, alertColor);
      drawPixel(14, 1, alertColor);
      drawPixel(13, 2, alertColor);
      drawPixel(14, 2, alertColor);
    } else if (state == PoliceState.hurt) {
      // Hurt effect
      final hurtColor = Colors.red;
      drawPixel(6, 3, hurtColor);
      drawPixel(10, 3, hurtColor);
    } else if (state == PoliceState.dead) {
      // Dead pose
      for (int x = 3; x < 14; x++) {
        for (int y = 13; y < 16; y++) {
          drawPixel(x, y, Colors.grey.shade600);
        }
      }
      // Blood
      drawPixel(2, 15, Colors.red.shade900);
      drawPixel(14, 15, Colors.red.shade900);
    }
  }

  @override
  bool shouldRepaint(covariant _PolicePainter oldDelegate) => true;
}

// Civilian Sprite Implementation
class _CivilianSprite extends StatefulWidget {
  final double size;
  final CivilianState state;
  final CivilianType type;
  final bool isAnimated;

  const _CivilianSprite({
    required this.size,
    required this.state,
    required this.type,
    required this.isAnimated,
  });

  @override
  _CivilianSpriteState createState() => _CivilianSpriteState();
}

class _CivilianSpriteState extends State<_CivilianSprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bobAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _bobAnimation = Tween<double>(
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
          offset: Offset(0, sin(_bobAnimation.value) * 1),
          child: CustomPaint(
            painter: _CivilianPainter(state: widget.state, type: widget.type),
            size: Size(widget.size, widget.size),
          ),
        );
      },
    );
  }
}

class _CivilianPainter extends CustomPainter {
  final CivilianState state;
  final CivilianType type;

  _CivilianPainter({required this.state, required this.type});

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

    // Get colors based on type
    Color skinColor;
    Color clothesColor;
    Color hairColor;

    switch (type) {
      case CivilianType.man:
        skinColor = Colors.brown.shade300;
        clothesColor = Colors.grey.shade700;
        hairColor = Colors.brown.shade800;
        break;
      case CivilianType.woman:
        skinColor = Colors.brown.shade200;
        clothesColor = Colors.pink.shade300;
        hairColor = Colors.yellow.shade600;
        break;
      case CivilianType.child:
        skinColor = Colors.brown.shade100;
        clothesColor = Colors.blue.shade300;
        hairColor = Colors.brown.shade400;
        break;
      case CivilianType.elderly:
        skinColor = Colors.brown.shade200;
        clothesColor = Colors.grey.shade500;
        hairColor = Colors.grey.shade300;
        break;
      case CivilianType.homeless:
        skinColor = Colors.brown.shade400;
        clothesColor = Colors.brown.shade600;
        hairColor = Colors.grey.shade400;
        break;
    }

    // Head
    for (int x = 6; x < 11; x++) {
      for (int y = 2; y < 7; y++) {
        drawPixel(x, y, skinColor);
      }
    }

    // Hair
    for (int x = 6; x < 11; x++) {
      drawPixel(x, 2, hairColor);
    }
    if (type == CivilianType.woman) {
      drawPixel(6, 3, hairColor);
      drawPixel(10, 3, hairColor);
    }

    // Eyes
    drawPixel(7, 4, Colors.black);
    drawPixel(9, 4, Colors.black);

    // Body
    for (int x = 5; x < 12; x++) {
      for (int y = 7; y < 13; y++) {
        drawPixel(x, y, clothesColor);
      }
    }

    // Arms
    for (int y = 8; y < 11; y++) {
      drawPixel(4, y, skinColor);
      drawPixel(12, y, skinColor);
    }

    // Legs
    final legColor = Colors.blue.shade800;
    for (int x = 5; x < 8; x++) {
      for (int y = 13; y < 16; y++) {
        drawPixel(x, y, legColor);
      }
    }
    for (int x = 9; x < 12; x++) {
      for (int y = 13; y < 16; y++) {
        drawPixel(x, y, legColor);
      }
    }

    // State-specific effects
    if (state == CivilianState.scared) {
      // Scared expression
      drawPixel(6, 3, Colors.white);
      drawPixel(10, 3, Colors.white);
    } else if (state == CivilianState.dead) {
      // Dead pose
      for (int x = 3; x < 14; x++) {
        for (int y = 13; y < 16; y++) {
          drawPixel(x, y, Colors.grey.shade600);
        }
      }
      // Blood
      drawPixel(2, 15, Colors.red.shade900);
      drawPixel(14, 15, Colors.red.shade900);
    }
  }

  @override
  bool shouldRepaint(covariant _CivilianPainter oldDelegate) => true;
}

// Drug Sprite Implementation
class _DrugSprite extends StatefulWidget {
  final double size;
  final DrugType type;
  final DrugState state;
  final bool isAnimated;

  const _DrugSprite({
    required this.size,
    required this.type,
    required this.state,
    required this.isAnimated,
  });

  @override
  _DrugSpriteState createState() => _DrugSpriteState();
}

class _DrugSpriteState extends State<_DrugSprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _glowAnimation = Tween<double>(
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, sin(_floatAnimation.value) * 3),
          child: CustomPaint(
            painter: _DrugPainter(
              type: widget.type,
              state: widget.state,
              glowValue: _glowAnimation.value,
            ),
            size: Size(widget.size, widget.size),
          ),
        );
      },
    );
  }
}

class _DrugPainter extends CustomPainter {
  final DrugType type;
  final DrugState state;
  final double glowValue;

  _DrugPainter({
    required this.type,
    required this.state,
    required this.glowValue,
  });

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

    // Get drug-specific colors and shapes
    Color drugColor;
    Color accentColor;

    switch (type) {
      case DrugType.weed:
        drugColor = Colors.green.shade700;
        accentColor = Colors.green.shade900;
        // Draw weed leaf shape
        for (int x = 7; x < 10; x++) {
          for (int y = 4; y < 12; y++) {
            drawPixel(x, y, drugColor);
          }
        }
        for (int x = 4; x < 13; x++) {
          for (int y = 7; y < 9; y++) {
            drawPixel(x, y, drugColor);
          }
        }
        drawPixel(8, 3, accentColor);
        drawPixel(8, 12, accentColor);
        break;

      case DrugType.crack:
        drugColor = Colors.yellow.shade100;
        // Draw crack rock shape
        for (int x = 5; x < 11; x++) {
          for (int y = 5; y < 11; y++) {
            drawPixel(x, y, drugColor);
          }
        }
        drawPixel(4, 7, drugColor);
        drawPixel(4, 8, drugColor);
        drawPixel(11, 7, drugColor);
        drawPixel(11, 8, drugColor);
        drawPixel(7, 4, drugColor);
        drawPixel(8, 4, drugColor);
        drawPixel(7, 11, drugColor);
        drawPixel(8, 11, drugColor);
        break;

      case DrugType.coke:
        drugColor = Colors.white;
        // Draw cocaine lines
        for (int x = 4; x < 12; x++) {
          drawPixel(x, 8, drugColor);
        }
        for (int x = 5; x < 11; x++) {
          drawPixel(x, 9, drugColor);
        }
        for (int x = 4; x < 12; x++) {
          drawPixel(x, 6, drugColor);
        }
        break;

      case DrugType.ice:
        drugColor = Colors.lightBlue.shade100;
        // Draw ice crystal shape
        for (int x = 6; x < 10; x++) {
          for (int y = 4; y < 8; y++) {
            drawPixel(x, y, drugColor);
          }
        }
        for (int x = 4; x < 12; x++) {
          for (int y = 8; y < 12; y++) {
            drawPixel(x, y, drugColor);
          }
        }
        break;

      case DrugType.percs:
        drugColor = Colors.pink.shade200;
        // Draw pill shape
        for (int x = 5; x < 11; x++) {
          for (int y = 7; y < 10; y++) {
            drawPixel(x, y, drugColor);
          }
        }
        drawPixel(4, 8, drugColor);
        drawPixel(11, 8, drugColor);
        // Pill divider
        for (int x = 7; x < 9; x++) {
          drawPixel(x, 8, Colors.white);
        }
        break;

      case DrugType.pixie:
        drugColor = Colors.purple.shade300;
        // Draw pixie dust pattern
        for (int x = 4; x < 12; x++) {
          for (int y = 4; y < 12; y++) {
            if ((x + y) % 2 == 0) {
              drawPixel(x, y, drugColor);
            } else {
              drawPixel(x, y, Colors.white70);
            }
          }
        }
        break;
    }

    // Add glow effect when collected
    if (state == DrugState.collected) {
      final glowPaint = Paint()
        ..color = Colors.yellow.withValues(alpha: glowValue * 0.5)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DrugPainter oldDelegate) => true;
}

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
    return AnimatedBuilder(
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

// Weapon Sprite Implementation
class _WeaponSprite extends StatefulWidget {
  final double size;
  final WeaponType type;
  final WeaponState state;
  final bool isAnimated;

  const _WeaponSprite({
    required this.size,
    required this.type,
    required this.state,
    required this.isAnimated,
  });

  @override
  _WeaponSpriteState createState() => _WeaponSpriteState();
}

class _WeaponSpriteState extends State<_WeaponSprite>
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

    if (widget.isAnimated && widget.state == WeaponState.firing) {
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
        return Transform.translate(
          offset: Offset(-_recoilAnimation.value * 3, 0),
          child: CustomPaint(
            painter: _WeaponPainter(
              type: widget.type,
              state: widget.state,
              flashValue: _flashAnimation.value,
            ),
            size: Size(widget.size, widget.size),
          ),
        );
      },
    );
  }
}

class _WeaponPainter extends CustomPainter {
  final WeaponType type;
  final WeaponState state;
  final double flashValue;

  _WeaponPainter({
    required this.type,
    required this.state,
    required this.flashValue,
  });

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

    // Get weapon-specific colors
    Color metalColor;
    Color woodColor;
    Color accentColor;

    switch (type) {
      case WeaponType.pistol:
        metalColor = Colors.blueGrey.shade700;
        woodColor = Colors.brown.shade600;
        accentColor = Colors.black;
        // Pistol grip
        for (int x = 4; x < 8; x++) {
          for (int y = 8; y < 14; y++) {
            drawPixel(x, y, woodColor);
          }
        }
        // Pistol barrel
        for (int x = 7; x < 14; x++) {
          for (int y = 6; y < 9; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        // Trigger guard
        drawPixel(6, 9, metalColor);
        drawPixel(7, 9, metalColor);
        drawPixel(8, 9, metalColor);
        // Sight
        drawPixel(12, 6, accentColor);
        break;

      case WeaponType.uzi:
        metalColor = Colors.grey.shade800;
        woodColor = Colors.brown.shade600;
        // Uzi body
        for (int x = 2; x < 13; x++) {
          for (int y = 7; y < 11; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        // Uzi stock
        for (int x = 12; x < 15; x++) {
          for (int y = 5; y < 11; y++) {
            drawPixel(x, y, woodColor);
          }
        }
        // Uzi magazine
        for (int x = 4; x < 7; x++) {
          for (int y = 11; y < 15; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        break;

      case WeaponType.ar15:
        metalColor = Colors.black87;
        woodColor = Colors.brown.shade600;
        // AR15 body
        for (int x = 2; x < 15; x++) {
          for (int y = 7; y < 10; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        // AR15 stock
        for (int x = 12; x < 15; x++) {
          for (int y = 5; y < 11; y++) {
            drawPixel(x, y, woodColor);
          }
        }
        // AR15 magazine
        for (int x = 6; x < 9; x++) {
          for (int y = 10; y < 14; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        // AR15 grip
        for (int x = 2; x < 5; x++) {
          for (int y = 10; y < 13; y++) {
            drawPixel(x, y, woodColor);
          }
        }
        break;

      case WeaponType.shotgun:
        metalColor = Colors.grey.shade700;
        woodColor = Colors.brown.shade500;
        // Shotgun body
        for (int x = 2; x < 14; x++) {
          for (int y = 7; y < 10; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        // Shotgun stock
        for (int x = 11; x < 15; x++) {
          for (int y = 5; y < 12; y++) {
            drawPixel(x, y, woodColor);
          }
        }
        // Shotgun pump
        for (int x = 4; x < 8; x++) {
          for (int y = 10; y < 12; y++) {
            drawPixel(x, y, woodColor);
          }
        }
        break;

      case WeaponType.knife:
        metalColor = Colors.grey.shade400;
        woodColor = Colors.brown.shade600;
        // Knife handle
        for (int x = 2; x < 6; x++) {
          for (int y = 8; y < 12; y++) {
            drawPixel(x, y, woodColor);
          }
        }
        // Knife blade
        for (int x = 6; x < 13; x++) {
          for (int y = 7; y < 10; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        // Knife tip
        drawPixel(13, 8, metalColor);
        drawPixel(13, 9, metalColor);
        break;

      case WeaponType.bat:
        woodColor = Colors.brown.shade400;
        metalColor = Colors.grey.shade600;
        // Bat handle
        for (int x = 2; x < 5; x++) {
          for (int y = 6; y < 14; y++) {
            drawPixel(x, y, woodColor);
          }
        }
        // Bat head
        for (int x = 5; x < 11; x++) {
          for (int y = 4; y < 8; y++) {
            drawPixel(x, y, woodColor);
          }
        }
        // Bat grip
        drawPixel(4, 10, metalColor);
        drawPixel(4, 11, metalColor);
        break;

      case WeaponType.grenade:
        metalColor = Colors.green.shade900;
        accentColor = Colors.grey;
        // Grenade body
        for (int x = 6; x < 11; x++) {
          for (int y = 6; y < 13; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        for (int x = 5; x < 12; x++) {
          for (int y = 8; y < 11; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        // Grenade pin
        drawPixel(8, 5, accentColor);
        break;

      case WeaponType.vest:
        metalColor = Colors.blueGrey.shade900;
        accentColor = Colors.grey;
        // Vest body
        for (int x = 5; x < 12; x++) {
          for (int y = 5; y < 13; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        for (int x = 4; x < 13; x++) {
          for (int y = 7; y < 11; y++) {
            drawPixel(x, y, metalColor);
          }
        }
        // Vest straps
        drawPixel(6, 4, accentColor);
        drawPixel(10, 4, accentColor);
        drawPixel(6, 14, accentColor);
        drawPixel(10, 14, accentColor);
        break;
    }

    // Add muzzle flash when firing
    if (state == WeaponState.firing && flashValue > 0.5) {
      final flashPaint = Paint()
        ..color = Colors.yellow.withValues(alpha: 1 - flashValue)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width * 0.9, size.height * 0.4),
        size.width * 0.15,
        flashPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeaponPainter oldDelegate) => true;
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
