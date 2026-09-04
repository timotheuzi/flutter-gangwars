import 'package:flutter/material.dart';

class PixelArtMember extends StatelessWidget {
  final bool isPlayer;
  final bool isAlive;
  final bool isCheering;
  final double size;
  final String? enemyType;
  final bool isPimp;

  const PixelArtMember({
    super.key,
    required this.isPlayer,
    required this.isAlive,
    this.isCheering = false,
    this.size = 32,
    this.enemyType,
    this.isPimp = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter:
            MemberPainter(isPlayer, isAlive, isCheering, enemyType, isPimp),
        size: Size(size, size),
      ),
    );
  }
}

class MemberPainter extends CustomPainter {
  final bool isPlayer;
  final bool isAlive;
  final bool isCheering;
  final String? enemyType;
  final bool isPimp;

  MemberPainter(this.isPlayer, this.isAlive, this.isCheering, this.enemyType,
      this.isPimp);

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

    if (!isAlive) {
      _drawDead(drawPixel);
      return;
    }

    if (isPimp) {
      _drawPimp(drawPixel);
    } else if (isPlayer) {
      _drawPlayer(drawPixel);
    } else {
      _drawEnemy(drawPixel, enemyType ?? 'default');
    }
  }

  void _drawPimp(Function(int, int, Color) d) {
    final purple = Colors.purple.shade700;
    final yellow = Colors.yellow.shade600;
    final skin = Colors.brown.shade700;
    final hair = Colors.black87;
    final white = Colors.white;

    // Head/Afro
    for (int x = 4; x < 12; x++) {
      for (int y = 1; y < 6; y++) {
        d(x, y, hair);
      }
    }
    // Face
    for (int x = 6; x < 10; x++) {
      for (int y = 3; y < 7; y++) {
        d(x, y, skin);
      }
    }
    // Eyes
    d(7, 4, white);
    d(9, 4, white);
    // Mustache
    d(7, 5, hair);
    d(8, 5, hair);
    d(9, 5, hair);

    // Hat
    for (int x = 5; x < 11; x++) {
      d(x, 1, purple);
    }
    for (int x = 3; x < 13; x++) {
      d(x, 2, purple);
    }

    // Suit
    for (int x = 5; x < 11; x++) {
      for (int y = 7; y < 13; y++) {
        d(x, y, purple);
      }
    }
    // Shirt
    for (int x = 7; x < 9; x++) {
      for (int y = 7; y < 11; y++) {
        d(x, y, yellow);
      }
    }

    // Arms
    if (isCheering) {
      for (int y = 5; y < 8; y++) {
        d(4, y, purple);
        d(11, y, purple);
      }
      d(4, 4, skin);
      d(11, 4, skin);
    } else {
      for (int y = 8; y < 11; y++) {
        d(4, y, purple);
        d(11, y, purple);
      }
      d(4, 11, skin);
      d(11, 11, skin);
    }

    // Cane (Right hand)
    d(12, 10, yellow);
    for (int y = 11; y < 16; y++) {
      d(12, y, Colors.brown);
    }

    // Legs
    for (int x = 5; x < 7; x++) {
      for (int y = 13; y < 16; y++) {
        d(x, y, purple);
      }
    }
    for (int x = 9; x < 11; x++) {
      for (int y = 13; y < 16; y++) {
        d(x, y, purple);
      }
    }
    d(5, 15, Colors.black);
    d(6, 15, Colors.black);
    d(9, 15, Colors.black);
    d(10, 15, Colors.black);
  }

  void _drawPlayer(Function(int, int, Color) d) {
    final skin = Colors.brown.shade400;
    final clothes = Colors.blueGrey.shade800;
    final bandana = Colors.red.shade900;

    // Head
    for (int x = 6; x < 11; x++) {
      for (int y = 2; y < 7; y++) {
        d(x, y, skin);
      }
    }
    // Bandana
    for (int x = 6; x < 11; x++) {
      d(x, 3, bandana);
    }
    d(11, 3, bandana);
    // Eyes
    d(7, 4, Colors.black);
    d(9, 4, Colors.black);
    // Body
    for (int x = 5; x < 12; x++) {
      for (int y = 7; y < 13; y++) {
        d(x, y, clothes);
      }
    }

    if (isCheering) {
      // Arms up
      for (int y = 4; y < 7; y++) {
        d(4, y, skin);
        d(12, y, skin);
      }
    } else {
      // Arms down
      for (int y = 8; y < 11; y++) {
        d(4, y, skin);
        d(12, y, skin);
      }
    }

    // Legs
    for (int x = 5; x < 8; x++) {
      for (int y = 13; y < 16; y++) {
        d(x, y, Colors.black);
      }
    }
    for (int x = 9; x < 12; x++) {
      for (int y = 13; y < 16; y++) {
        d(x, y, Colors.black);
      }
    }
  }

  void _drawEnemy(Function(int, int, Color) d, String enemyType) {
    Color skin;
    Color clothes;
    Color eyes;

    switch (enemyType) {
      case 'Police Officers':
        skin = Colors.blue.shade800;
        clothes = Colors.blue.shade900;
        eyes = Colors.white;
        break;
      case 'Squidie Hit Squad':
        skin = Colors.purple.shade800;
        clothes = Colors.purple.shade900;
        eyes = Colors.yellow;
        break;
      case 'Rival Gang Members':
        skin = Colors.red.shade800;
        clothes = Colors.red.shade900;
        eyes = Colors.black;
        break;
      default:
        skin = Colors.green.shade800;
        clothes = Colors.deepPurple.shade900;
        eyes = Colors.red;
    }

    // Head
    for (int x = 6; x < 11; x++) {
      for (int y = 2; y < 7; y++) {
        d(x, y, skin);
      }
    }
    // Eyes
    d(7, 4, eyes);
    d(9, 4, eyes);
    // Body
    for (int x = 5; x < 12; x++) {
      for (int y = 7; y < 13; y++) {
        d(x, y, clothes);
      }
    }

    if (isCheering) {
      for (int x = 2; x < 6; x++) {
        d(x, 4, skin);
      }
      for (int x = 11; x < 15; x++) {
        d(x, 4, skin);
      }
    } else {
      for (int x = 2; x < 6; x++) {
        d(x, 8, skin);
      }
      for (int x = 11; x < 15; x++) {
        d(x, 8, skin);
      }
    }

    // Legs
    for (int x = 5; x < 8; x++) {
      for (int y = 13; y < 16; y++) {
        d(x, y, Colors.black);
      }
    }
    for (int x = 9; x < 12; x++) {
      for (int y = 13; y < 16; y++) {
        d(x, y, Colors.black);
      }
    }
  }

  void _drawDead(Function(int, int, Color) d) {
    final blood = Colors.red.shade900;
    final grey = Colors.grey.shade600;

    for (int x = 3; x < 14; x++) {
      for (int y = 13; y < 16; y++) {
        d(x, y, grey);
      }
    }
    for (int x = 5; x < 12; x++) {
      for (int y = 11; y < 13; y++) {
        d(x, y, grey);
      }
    }

    d(2, 15, blood);
    d(14, 15, blood);
    d(4, 14, blood);
    d(11, 14, blood);
    d(7, 14, Colors.white70);
    d(9, 14, Colors.white70);
  }

  @override
  bool shouldRepaint(covariant MemberPainter oldDelegate) =>
      oldDelegate.isPlayer != isPlayer ||
      oldDelegate.isAlive != isAlive ||
      oldDelegate.isCheering != isCheering ||
      oldDelegate.enemyType != enemyType ||
      oldDelegate.isPimp != isPimp;
}
