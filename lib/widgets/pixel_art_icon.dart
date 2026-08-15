import 'package:flutter/material.dart';

class PixelArtIcon extends StatelessWidget {
  final String name;
  final double size;

  const PixelArtIcon({super.key, required this.name, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: IconPainter(name)),
    );
  }
}

class IconPainter extends CustomPainter {
  final String name;

  IconPainter(this.name);

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

    switch (name.toLowerCase()) {
      // Drugs
      case 'weed':
        _drawWeed(drawPixel);
      case 'crack':
        _drawCrack(drawPixel);
      case 'coke':
        _drawCoke(drawPixel);
      case 'ice':
        _drawIce(drawPixel);
      case 'percs':
        _drawPercs(drawPixel);
      case 'pixie dust':
        _drawPixie(drawPixel);

      // Weapons
      case 'pistol':
        _drawPistol(drawPixel);
      case 'uzi':
        _drawUzi(drawPixel);
      case 'ar15':
        _drawAR15(drawPixel);
      case 'grenade':
        _drawGrenade(drawPixel);
      case 'bat':
        _drawBat(drawPixel);
      case 'bullets':
        _drawBullets(drawPixel);
      case 'vest':
        _drawVest(drawPixel);

      // Other
      case 'prostitute':
        _drawProstitute(drawPixel);
      default:
        _drawDefault(drawPixel);
    }
  }

  void _drawWeed(Function(int, int, Color) d) {
    final green = Colors.green.shade700;
    final darkGreen = Colors.green.shade900;
    for (int x = 7; x < 10; x++) {
      for (int y = 4; y < 12; y++) {
        d(x, y, green);
      }
    }
    for (int x = 4; x < 13; x++) {
      for (int y = 7; y < 9; y++) {
        d(x, y, green);
      }
    }
    d(8, 3, darkGreen);
    d(8, 12, darkGreen);
  }

  void _drawCrack(Function(int, int, Color) d) {
    final offWhite = Colors.yellow.shade100;
    for (int x = 5; x < 11; x++) {
      for (int y = 5; y < 11; y++) {
        d(x, y, offWhite);
      }
    }
    d(4, 7, offWhite);
    d(4, 8, offWhite);
    d(11, 7, offWhite);
    d(11, 8, offWhite);
    d(7, 4, offWhite);
    d(8, 4, offWhite);
    d(7, 11, offWhite);
    d(8, 11, offWhite);
  }

  void _drawCoke(Function(int, int, Color) d) {
    final white = Colors.white;
    for (int x = 4; x < 12; x++) {
      d(x, 8, white);
    }
    for (int x = 5; x < 11; x++) {
      d(x, 9, white);
    }
    for (int x = 4; x < 12; x++) {
      d(x, 6, white);
    }
  }

  void _drawIce(Function(int, int, Color) d) {
    final ice = Colors.lightBlue.shade100;
    for (int x = 6; x < 10; x++) {
      for (int y = 4; y < 8; y++) {
        d(x, y, ice);
      }
    }
    for (int x = 4; x < 12; x++) {
      for (int y = 8; y < 12; y++) {
        d(x, y, ice);
      }
    }
  }

  void _drawPercs(Function(int, int, Color) d) {
    final pink = Colors.pink.shade200;
    for (int x = 5; x < 11; x++) {
      for (int y = 7; y < 10; y++) {
        d(x, y, pink);
      }
    }
    d(4, 8, pink);
    d(11, 8, pink);
    for (int x = 7; x < 9; x++) {
      d(x, 8, Colors.white);
    }
  }

  void _drawPixie(Function(int, int, Color) d) {
    final purple = Colors.purple.shade300;
    for (int x = 4; x < 12; x++) {
      for (int y = 4; y < 12; y++) {
        if ((x + y) % 2 == 0) {
          d(x, y, purple);
        } else {
          d(x, y, Colors.white70);
        }
      }
    }
  }

  void _drawPistol(Function(int, int, Color) d) {
    final grey = Colors.blueGrey.shade700;
    for (int x = 5; x < 13; x++) {
      for (int y = 6; y < 9; y++) {
        d(x, y, grey);
      }
    }
    for (int x = 5; x < 8; x++) {
      for (int y = 9; y < 13; y++) {
        d(x, y, grey);
      }
    }
    d(12, 9, Colors.black);
  }

  void _drawUzi(Function(int, int, Color) d) {
    final grey = Colors.grey.shade800;
    for (int x = 3; x < 13; x++) {
      for (int y = 7; y < 10; y++) {
        d(x, y, grey);
      }
    }
    for (int x = 7; x < 10; x++) {
      for (int y = 10; y < 14; y++) {
        d(x, y, grey);
      }
    }
    d(12, 10, grey);
  }

  void _drawAR15(Function(int, int, Color) d) {
    final black = Colors.black87;
    for (int x = 2; x < 15; x++) {
      for (int y = 7; y < 9; y++) {
        d(x, y, black);
      }
    }
    for (int x = 6; x < 9; x++) {
      for (int y = 9; y < 13; y++) {
        d(x, y, black);
      }
    }
    for (int x = 2; x < 4; x++) {
      for (int y = 9; y < 11; y++) {
        d(x, y, black);
      }
    }
  }

  void _drawGrenade(Function(int, int, Color) d) {
    final green = Colors.green.shade900;
    for (int x = 6; x < 10; x++) {
      for (int y = 6; y < 13; y++) {
        d(x, y, green);
      }
    }
    for (int x = 5; x < 11; x++) {
      for (int y = 8; y < 11; y++) {
        d(x, y, green);
      }
    }
    d(8, 5, Colors.grey);
  }

  void _drawBat(Function(int, int, Color) d) {
    final wood = Colors.brown.shade400;
    for (int x = 3; x < 14; x++) {
      d(x, 16 - x, wood);
    }
    d(13, 2, Colors.grey);
    d(12, 3, Colors.grey);
  }

  void _drawBullets(Function(int, int, Color) d) {
    final gold = Colors.amber.shade700;
    for (int i = 0; i < 3; i++) {
      int ox = i * 4 + 2;
      for (int y = 6; y < 12; y++) {
        d(ox, y, gold);
      }
      d(ox, 5, Colors.grey);
    }
  }

  void _drawVest(Function(int, int, Color) d) {
    final dark = Colors.blueGrey.shade900;
    for (int x = 5; x < 11; x++) {
      for (int y = 5; y < 13; y++) {
        d(x, y, dark);
      }
    }
    for (int x = 4; x < 12; x++) {
      for (int y = 7; y < 11; y++) {
        d(x, y, dark);
      }
    }
  }

  void _drawProstitute(Function(int, int, Color) d) {
    final skin = Colors.pink.shade100;
    final hair = Colors.yellow.shade600;
    final dress = Colors.pinkAccent;
    // Head
    for (int x = 7; x < 10; x++) {
      for (int y = 4; y < 7; y++) {
        d(x, y, skin);
      }
    }
    // Hair
    for (int x = 6; x < 11; x++) {
      d(x, 4, hair);
    }
    d(6, 5, hair);
    d(10, 5, hair);
    // Body
    for (int x = 6; x < 11; x++) {
      for (int y = 7; y < 12; y++) {
        d(x, y, dress);
      }
    }
    // Legs
    d(7, 12, skin);
    d(9, 12, skin);
    d(7, 13, skin);
    d(9, 13, skin);
  }

  void _drawDefault(Function(int, int, Color) d) {
    for (int x = 4; x < 12; x++) {
      for (int y = 4; y < 12; y++) {
        d(x, y, Colors.grey);
      }
    }
  }

  @override
  bool shouldRepaint(covariant IconPainter oldDelegate) => false;
}
