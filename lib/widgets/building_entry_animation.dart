import 'package:flutter/material.dart';
import 'dart:math';
import 'pixel_art_member.dart';

class BuildingEntryAnimation extends StatefulWidget {
  final String buildingType;
  final VoidCallback onAnimationComplete;

  const BuildingEntryAnimation({
    super.key,
    required this.buildingType,
    required this.onAnimationComplete,
  });

  @override
  BuildingEntryAnimationState createState() => BuildingEntryAnimationState();
}

class BuildingEntryAnimationState extends State<BuildingEntryAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _playerPosition;
  late Animation<double> _playerBob;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _playerPosition = Tween<double>(
      begin: -50.0,
      end: MediaQuery.of(context).size.width + 50,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _playerBob = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.forward().then((_) {
      widget.onAnimationComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade900, Colors.blue.shade700],
              ),
            ),
          ),

          // Ground
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(color: Colors.brown.shade800),
          ),

          // Building on the right
          Positioned(
            right: 50,
            bottom: 100,
            child: _buildBuilding(widget.buildingType),
          ),

          // Player
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final bobOffset = sin(_playerBob.value) * 5;
              return Positioned(
                left: _playerPosition.value,
                bottom: 120 + bobOffset,
                child: Transform.scale(
                  scaleX: 2.0, // Facing right
                  child: const PixelArtMember(
                    isPlayer: true,
                    isAlive: true,
                    isCheering: false,
                    size: 32,
                  ),
                ),
              );
            },
          ),

          // Title text
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Entering ${widget.buildingType.toUpperCase()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuilding(String buildingType) {
    return SizedBox(
      width: 120,
      height: 150,
      child: CustomPaint(painter: BuildingPainter(buildingType)),
    );
  }
}

class BuildingPainter extends CustomPainter {
  final String buildingType;

  BuildingPainter(this.buildingType);

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

    switch (buildingType.toLowerCase()) {
      case 'bank':
        _drawBank(drawPixel);
        break;
      case 'bar':
        _drawBar(drawPixel);
        break;
      case 'crackhouse':
        _drawCrackhouse(drawPixel);
        break;
      case 'gunshack':
        _drawGunshack(drawPixel);
        break;
      case 'infobooth':
        _drawInfobooth(drawPixel);
        break;
      case 'picknsave':
        _drawPicknsave(drawPixel);
        break;
      case 'alleyway':
        _drawAlleyway(drawPixel);
        break;
      default:
        _drawGeneric(drawPixel);
    }
  }

  void _drawBank(Function(int, int, Color) d) {
    final wall = Colors.grey.shade600;
    final roof = Colors.red.shade900;
    final door = Colors.brown.shade800;
    final window = Colors.blue.shade300;

    // Building base
    for (int x = 4; x < 28; x++) {
      for (int y = 20; y < 32; y++) {
        d(x, y, wall);
      }
    }

    // Roof
    for (int x = 2; x < 30; x++) {
      for (int y = 16; y < 20; y++) {
        d(x, y, roof);
      }
    }

    // Door
    for (int x = 12; x < 20; x++) {
      for (int y = 24; y < 32; y++) {
        d(x, y, door);
      }
    }

    // Windows
    for (int wx = 6; wx < 11; wx++) {
      for (int wy = 22; wy < 26; wy++) {
        d(wx, wy, window);
      }
    }
    for (int wx = 21; wx < 26; wx++) {
      for (int wy = 22; wy < 26; wy++) {
        d(wx, wy, window);
      }
    }

    // Bank sign
    d(14, 18, Colors.yellow);
    d(15, 18, Colors.yellow);
    d(16, 18, Colors.yellow);
    d(17, 18, Colors.yellow);
  }

  void _drawBar(Function(int, int, Color) d) {
    final wall = Colors.brown.shade700;
    final roof = Colors.grey.shade800;
    final door = Colors.black;
    final window = Colors.amber.shade300;

    // Building base
    for (int x = 4; x < 28; x++) {
      for (int y = 20; y < 32; y++) {
        d(x, y, wall);
      }
    }

    // Roof
    for (int x = 2; x < 30; x++) {
      for (int y = 16; y < 20; y++) {
        d(x, y, roof);
      }
    }

    // Door
    for (int x = 12; x < 20; x++) {
      for (int y = 24; y < 32; y++) {
        d(x, y, door);
      }
    }

    // Windows
    for (int wx = 6; wx < 11; wx++) {
      for (int wy = 22; wy < 26; wy++) {
        d(wx, wy, window);
      }
    }
    for (int wx = 21; wx < 26; wx++) {
      for (int wy = 22; wy < 26; wy++) {
        d(wx, wy, window);
      }
    }

    // Bar sign
    d(13, 18, Colors.red);
    d(14, 18, Colors.red);
    d(15, 18, Colors.red);
    d(16, 18, Colors.red);
    d(17, 18, Colors.red);
  }

  void _drawCrackhouse(Function(int, int, Color) d) {
    final wall = Colors.grey.shade700;
    final roof = Colors.grey.shade900;
    final door = Colors.brown.shade900;
    final window = Colors.yellow.shade200;

    // Run down building
    for (int x = 4; x < 28; x++) {
      for (int y = 20; y < 32; y++) {
        d(x, y, wall);
      }
    }

    // Roof
    for (int x = 2; x < 30; x++) {
      for (int y = 16; y < 20; y++) {
        d(x, y, roof);
      }
    }

    // Door
    for (int x = 12; x < 20; x++) {
      for (int y = 24; y < 32; y++) {
        d(x, y, door);
      }
    }

    // Broken windows
    for (int wx = 6; wx < 11; wx++) {
      d(wx, 22, window);
      d(wx, 25, window);
    }
    for (int wx = 21; wx < 26; wx++) {
      d(wx, 22, window);
      d(wx, 25, window);
    }
  }

  void _drawGunshack(Function(int, int, Color) d) {
    final wall = Colors.green.shade800;
    final roof = Colors.brown.shade800;
    final door = Colors.black;
    final window = Colors.blue.shade400;

    // Building base
    for (int x = 4; x < 28; x++) {
      for (int y = 20; y < 32; y++) {
        d(x, y, wall);
      }
    }

    // Roof
    for (int x = 2; x < 30; x++) {
      for (int y = 16; y < 20; y++) {
        d(x, y, roof);
      }
    }

    // Door
    for (int x = 12; x < 20; x++) {
      for (int y = 24; y < 32; y++) {
        d(x, y, door);
      }
    }

    // Small windows
    d(8, 22, window);
    d(8, 23, window);
    d(23, 22, window);
    d(23, 23, window);
  }

  void _drawInfobooth(Function(int, int, Color) d) {
    final metal = Colors.grey.shade500;
    final screen = Colors.blue.shade300;
    final base = Colors.grey.shade700;

    // Booth base
    for (int x = 8; x < 24; x++) {
      for (int y = 24; y < 32; y++) {
        d(x, y, base);
      }
    }

    // Booth walls
    for (int x = 10; x < 22; x++) {
      for (int y = 16; y < 24; y++) {
        d(x, y, metal);
      }
    }

    // Screen area
    for (int x = 12; x < 20; x++) {
      for (int y = 18; y < 22; y++) {
        d(x, y, screen);
      }
    }
  }

  void _drawPicknsave(Function(int, int, Color) d) {
    final wall = Colors.blue.shade700;
    final roof = Colors.red.shade900;
    final door = Colors.white;
    final window = Colors.lightBlue.shade200;

    // Building base
    for (int x = 4; x < 28; x++) {
      for (int y = 20; y < 32; y++) {
        d(x, y, wall);
      }
    }

    // Roof
    for (int x = 2; x < 30; x++) {
      for (int y = 16; y < 20; y++) {
        d(x, y, roof);
      }
    }

    // Large entrance
    for (int x = 10; x < 22; x++) {
      for (int y = 24; y < 32; y++) {
        d(x, y, door);
      }
    }

    // Store windows
    for (int wx = 6; wx < 9; wx++) {
      for (int wy = 22; wy < 26; wy++) {
        d(wx, wy, window);
      }
    }
    for (int wx = 23; wx < 26; wx++) {
      for (int wy = 22; wy < 26; wy++) {
        d(wx, wy, window);
      }
    }
  }

  void _drawAlleyway(Function(int, int, Color) d) {
    final brick = Colors.red.shade900;
    final shadow = Colors.grey.shade800;

    // Wall left
    for (int x = 0; x < 8; x++) {
      for (int y = 16; y < 32; y++) {
        d(x, y, brick);
      }
    }

    // Wall right
    for (int x = 24; x < 32; x++) {
      for (int y = 16; y < 32; y++) {
        d(x, y, brick);
      }
    }

    // Alley entrance ahead
    for (int x = 8; x < 24; x++) {
      for (int y = 20; y < 32; y++) {
        d(x, y, shadow);
      }
    }
  }

  void _drawGeneric(Function(int, int, Color) d) {
    final wall = Colors.grey.shade600;
    final roof = Colors.grey.shade800;
    final door = Colors.brown.shade800;

    // Building base
    for (int x = 4; x < 28; x++) {
      for (int y = 20; y < 32; y++) {
        d(x, y, wall);
      }
    }

    // Roof
    for (int x = 2; x < 30; x++) {
      for (int y = 16; y < 20; y++) {
        d(x, y, roof);
      }
    }

    // Door
    for (int x = 12; x < 20; x++) {
      for (int y = 24; y < 32; y++) {
        d(x, y, door);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BuildingPainter oldDelegate) =>
      oldDelegate.buildingType != buildingType;
}
