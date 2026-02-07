import 'package:flutter/material.dart';

class PixelArtLocation extends StatelessWidget {
  final String location;
  final double size;

  const PixelArtLocation({super.key, required this.location, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: PixelPainter(location)),
    );
  }
}

class PixelPainter extends CustomPainter {
  final String location;

  PixelPainter(this.location);

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

    switch (location.toLowerCase()) {
      case 'crackhouse':
        _drawCrackhouse(drawPixel);
      case 'gun shack':
        _drawGunShack(drawPixel);
      case 'bank':
        _drawBank(drawPixel);
      case 'bar':
        _drawBar(drawPixel);
      case 'alleyway':
        _drawAlleyway(drawPixel);
      case 'info booth':
        _drawInfoBooth(drawPixel);
      case 'pick n save':
        _drawShop(drawPixel);
      default:
        _drawDefault(drawPixel);
    }
  }

  void _drawCrackhouse(Function(int, int, Color) d) {
    final brown = Colors.brown.shade800;
    final darkBrown = Colors.brown.shade900;

    // Building
    for (int x = 2; x < 14; x++) {
      for (int y = 4; y < 14; y++) {
        d(x, y, brown);
      }
    }
    // Roof
    for (int x = 1; x < 15; x++) {
      for (int y = 2; y < 4; y++) {
        d(x, y, darkBrown);
      }
    }
    // Boarded window
    for (int x = 4; x < 7; x++) {
      for (int y = 6; y < 9; y++) {
        d(x, y, Colors.orange.shade800);
      }
    }
    for (int i = 4; i < 7; i++) {
      d(i, 7, darkBrown);
      d(i, 8, darkBrown);
    }
    // Door
    for (int x = 9; x < 12; x++) {
      for (int y = 9; y < 14; y++) {
        d(x, y, darkBrown);
      }
    }
    // Cracks
    d(3, 5, Colors.black);
    d(13, 12, Colors.black);
  }

  void _drawGunShack(Function(int, int, Color) d) {
    final grey = Colors.grey.shade800;
    final steel = Colors.blueGrey.shade400;

    // Metal building
    for (int x = 2; x < 14; x++) {
      for (int y = 4; y < 14; y++) {
        d(x, y, grey);
      }
    }
    // Sign
    for (int x = 4; x < 12; x++) {
      d(x, 5, Colors.red);
    }
    // Gun silhouette
    d(7, 8, steel);
    d(8, 8, steel);
    d(9, 8, steel);
    d(7, 9, steel);
    d(7, 10, steel);
    // Door
    for (int x = 10; x < 13; x++) {
      for (int y = 9; y < 14; y++) {
        d(x, y, Colors.black);
      }
    }
  }

  void _drawBank(Function(int, int, Color) d) {
    final gold = Colors.amber.shade600;
    final white = Colors.white70;

    // Pillars
    for (int y = 4; y < 14; y++) {
      d(3, y, white);
      d(7, y, white);
      d(12, y, white);
    }
    // Roof/Pediment
    for (int x = 2; x < 14; x++) {
      d(x, 3, white);
    }
    for (int x = 4; x < 12; x++) {
      d(x, 2, white);
    }
    // Dollar sign
    d(8, 8, gold);
    d(8, 7, gold);
    d(8, 9, gold);
    d(7, 7, gold);
    d(9, 9, gold);
  }

  void _drawBar(Function(int, int, Color) d) {
    final neon = Colors.pinkAccent;
    final wood = Colors.brown.shade700;

    // Building
    for (int x = 2; x < 14; x++) {
      for (int y = 4; y < 14; y++) {
        d(x, y, wood);
      }
    }
    // Neon Mug
    for (int x = 6; x < 10; x++) {
      for (int y = 6; y < 10; y++) {
        d(x, y, Colors.amber);
      }
    }
    d(10, 7, Colors.amber);
    d(10, 8, Colors.amber);
    // Neon sign line
    for (int x = 4; x < 12; x++) {
      d(x, 5, neon);
    }
    // Door
    for (int x = 7; x < 10; x++) {
      for (int y = 10; y < 14; y++) {
        d(x, y, Colors.black);
      }
    }
  }

  void _drawAlleyway(Function(int, int, Color) d) {
    final wall = Colors.grey.shade800;

    // Walls
    for (int y = 2; y < 14; y++) {
      d(2, y, wall);
      d(3, y, wall);
      d(12, y, wall);
      d(13, y, wall);
    }
    // Trash can
    for (int x = 4; x < 7; x++) {
      for (int y = 10; y < 14; y++) {
        d(x, y, Colors.blueGrey);
      }
    }
    // Box
    for (int x = 9; x < 11; x++) {
      for (int y = 11; y < 14; y++) {
        d(x, y, Colors.brown);
      }
    }
    // Puddle
    d(6, 13, Colors.blue.shade900);
    d(7, 13, Colors.blue.shade900);
  }

  void _drawInfoBooth(Function(int, int, Color) d) {
    final blue = Colors.blue.shade700;

    // Small booth
    for (int x = 4; x < 12; x++) {
      for (int y = 6; y < 14; y++) {
        d(x, y, blue);
      }
    }
    // Window
    for (int x = 6; x < 10; x++) {
      for (int y = 8; y < 11; y++) {
        d(x, y, Colors.lightBlue.shade100);
      }
    }
    // "?" Sign
    d(8, 3, Colors.white);
    d(8, 4, Colors.white);
    d(7, 2, Colors.white);
    d(9, 2, Colors.white);
  }

  void _drawShop(Function(int, int, Color) d) {
    final orange = Colors.orange.shade700;

    // Shop
    for (int x = 2; x < 14; x++) {
      for (int y = 5; y < 14; y++) {
        d(x, y, orange);
      }
    }
    // Glass front
    for (int x = 4; x < 12; x++) {
      for (int y = 7; y < 10; y++) {
        d(x, y, Colors.white24);
      }
    }
    // Cart icon
    d(6, 11, Colors.black);
    d(7, 11, Colors.black);
    d(8, 11, Colors.black);
    d(6, 12, Colors.black);
    d(8, 12, Colors.black);
  }

  void _drawDefault(Function(int, int, Color) d) {
    for (int x = 4; x < 12; x++) {
      for (int y = 4; y < 12; y++) {
        d(x, y, Colors.grey);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
