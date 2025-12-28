import 'package:flutter/material.dart';

class PixelArtMember extends StatelessWidget {
  final bool isPlayer;
  final bool isAlive;
  final bool isCheering;
  final double size;

  const PixelArtMember({
    super.key,
    required this.isPlayer,
    required this.isAlive,
    this.isCheering = false,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: MemberPainter(isPlayer, isAlive, isCheering),
      ),
    );
  }
}

class MemberPainter extends CustomPainter {
  final bool isPlayer;
  final bool isAlive;
  final bool isCheering;

  MemberPainter(this.isPlayer, this.isAlive, this.isCheering);

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

    if (isPlayer) {
      _drawPlayer(drawPixel);
    } else {
      _drawEnemy(drawPixel);
    }
  }

  void _drawPlayer(Function(int, int, Color) d) {
    final skin = Colors.brown.shade400;
    final clothes = Colors.blueGrey.shade800;
    final bandana = Colors.red.shade900;
    
    // Head
    for(int x=6; x<11; x++) {
      for(int y=2; y<7; y++) {
        d(x,y, skin);
      }
    }
    // Bandana
    for(int x=6; x<11; x++) {
      d(x, 3, bandana);
    }
    d(11, 3, bandana);
    // Eyes
    d(7,4, Colors.black);
    d(9,4, Colors.black);
    // Body
    for(int x=5; x<12; x++) {
      for(int y=7; y<13; y++) {
        d(x,y, clothes);
      }
    }
    
    if (isCheering) {
      // Arms up
      for(int y=4; y<7; y++) {
        d(4,y, skin);
        d(12,y, skin);
      }
    } else {
      // Arms down
      for(int y=8; y<11; y++) {
        d(4,y, skin);
        d(12,y, skin);
      }
    }
    
    // Legs
    for(int x=5; x<8; x++) {
      for(int y=13; y<16; y++) {
        d(x,y, Colors.black);
      }
    }
    for(int x=9; x<12; x++) {
      for(int y=13; y<16; y++) {
        d(x,y, Colors.black);
      }
    }
  }

  void _drawEnemy(Function(int, int, Color) d) {
    final skin = Colors.green.shade800;
    final clothes = Colors.deepPurple.shade900;
    
    // Head
    for(int x=6; x<11; x++) {
      for(int y=2; y<7; y++) {
        d(x,y, skin);
      }
    }
    // Eyes (Glowy)
    d(7,4, Colors.red);
    d(9,4, Colors.red);
    // Body
    for(int x=5; x<12; x++) {
      for(int y=7; y<13; y++) {
        d(x,y, clothes);
      }
    }
    
    if (isCheering) {
       // Arms out/up
       for(int x=2; x<6; x++) {
         d(x, 4, skin);
       }
       for(int x=11; x<15; x++) {
         d(x, 4, skin);
       }
    } else {
      // Arms out (Zombified)
      for(int x=2; x<6; x++) {
        d(x, 8, skin);
      }
      for(int x=11; x<15; x++) {
        d(x, 8, skin);
      }
    }
    
    // Legs
    for(int x=5; x<8; x++) {
      for(int y=13; y<16; y++) {
        d(x,y, Colors.black);
      }
    }
    for(int x=9; x<12; x++) {
      for(int y=13; y<16; y++) {
        d(x,y, Colors.black);
      }
    }
  }

  void _drawDead(Function(int, int, Color) d) {
    final blood = Colors.red.shade900;
    final darkBlood = Colors.red.shade900.withBlue(20);
    final grey = Colors.grey.shade600;

    // Body heap - more collapsed
    for(int x=3; x<14; x++) {
      for(int y=13; y<16; y++) {
        d(x,y, grey);
      }
    }
    for(int x=5; x<12; x++) {
      for(int y=11; y<13; y++) {
        d(x,y, grey);
      }
    }
    
    // Blood splatter around/on body - more intense
    d(2,15, blood);
    d(14,15, blood);
    d(4,14, blood);
    d(11,14, blood);
    d(2,14, darkBlood);
    d(14,14, darkBlood);
    d(7,12, blood);
    d(8,12, blood);
    d(5,15, darkBlood);
    d(10,15, darkBlood);
    
    // Skull hint
    d(7,14, Colors.white70);
    d(9,14, Colors.white70);
  }

  @override
  bool shouldRepaint(covariant MemberPainter oldDelegate) => 
    oldDelegate.isPlayer != isPlayer || 
    oldDelegate.isAlive != isAlive || 
    oldDelegate.isCheering != isCheering;
}
