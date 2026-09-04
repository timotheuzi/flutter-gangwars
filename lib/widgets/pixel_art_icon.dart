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
      case 'pixie_dust':
      case 'pixie dust':
        _drawPixie(drawPixel);

      // Weapons - Firearms
      case 'pistol':
        _drawPistol(drawPixel);
      case 'uzi':
        _drawUzi(drawPixel);
      case 'ar15':
        _drawAR15(drawPixel);
      case 'machine_gun':
      case 'machine gun':
        _drawMachineGun(drawPixel);
      case 'submachine_gun':
      case 'submachine gun':
        _drawSubmachineGun(drawPixel);
      case 'flamethrower':
        _drawFlamethrower(drawPixel);
      case 'missile_launcher':
      case 'missile launcher':
        _drawMissileLauncher(drawPixel);
      case 'rocket_launcher':
      case 'rocket launcher':
        _drawRocketLauncher(drawPixel);
      case 'golden_gun':
      case 'golden gun':
        _drawGoldenGun(drawPixel);
      case 'ghost_gun':
      case 'ghost gun':
        _drawGhostGun(drawPixel);

      // Weapons - Melee
      case 'knife':
        _drawKnife(drawPixel);
      case 'sword':
        _drawSword(drawPixel);
      case 'axe':
        _drawAxe(drawPixel);
      case 'bat':
      case 'barbed_wire_bat':
      case 'vampire_bat':
        _drawBat(drawPixel);
      case 'brass_knuckles':
      case 'brass knuckles':
        _drawBrassKnuckles(drawPixel);
      case 'poison_blowgun':
      case 'poison blowgun':
        _drawPoisonBlowgun(drawPixel);

      // Weapons - Throwables & Ammo
      case 'grenade':
        _drawGrenade(drawPixel);
      case 'bullets':
        _drawBullets(drawPixel);
      case 'missile':
        _drawMissile(drawPixel);

      // Armor
      case 'vest':
      case 'vest_light':
      case 'vest_medium':
      case 'vest_heavy':
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

  void _drawMachineGun(Function(int, int, Color) d) {
    final metal = Colors.grey.shade700;
    // Barrel
    for (int x = 2; x < 15; x++) {
      d(x, 8, metal);
      d(x, 9, metal);
    }
    // Ammo belt
    for (int x = 6; x < 10; x++) {
      d(x, 10, Colors.yellow.shade700);
    }
    // Tripod
    d(4, 10, metal);
    d(3, 11, metal);
    d(12, 10, metal);
    d(13, 11, metal);
  }

  void _drawSubmachineGun(Function(int, int, Color) d) {
    final metal = Colors.grey.shade800;
    for (int x = 4; x < 14; x++) {
      for (int y = 7; y < 10; y++) {
        d(x, y, metal);
      }
    }
    // Mag
    for (int x = 8; x < 10; x++) {
      for (int y = 10; y < 14; y++) {
        d(x, y, metal);
      }
    }
  }

  void _drawFlamethrower(Function(int, int, Color) d) {
    final tank = Colors.red.shade900;
    final nozzle = Colors.grey.shade700;
    // Tank
    for (int x = 4; x < 9; x++) {
      for (int y = 5; y < 11; y++) {
        d(x, y, tank);
      }
    }
    // Nozzle
    for (int x = 9; x < 15; x++) {
      d(x, 8, nozzle);
    }
    // Flame hint
    d(14, 7, Colors.orange);
    d(15, 8, Colors.orange);
    d(14, 9, Colors.orange);
  }

  void _drawMissileLauncher(Function(int, int, Color) d) {
    final body = Colors.green.shade800;
    for (int x = 2; x < 15; x++) {
      for (int y = 6; y < 10; y++) {
        d(x, y, body);
      }
    }
    // Scope
    d(8, 5, Colors.black);
    d(9, 5, Colors.black);
  }

  void _drawRocketLauncher(Function(int, int, Color) d) {
    final body = Colors.grey.shade600;
    for (int x = 1; x < 16; x++) {
      for (int y = 7; y < 11; y++) {
        d(x, y, body);
      }
    }
    // Handles
    d(4, 11, Colors.black);
    d(10, 11, Colors.black);
  }

  void _drawGoldenGun(Function(int, int, Color) d) {
    final gold = Colors.yellow.shade700;
    for (int x = 5; x < 13; x++) {
      for (int y = 6; y < 9; y++) {
        d(x, y, gold);
      }
    }
    for (int x = 5; x < 8; x++) {
      for (int y = 9; y < 13; y++) {
        d(x, y, gold);
      }
    }
    d(12, 9, Colors.amber);
  }

  void _drawGhostGun(Function(int, int, Color) d) {
    final ghost = Colors.white.withValues(alpha: 0.4);
    for (int x = 5; x < 13; x++) {
      for (int y = 6; y < 9; y++) {
        d(x, y, ghost);
      }
    }
    for (int x = 5; x < 8; x++) {
      for (int y = 9; y < 13; y++) {
        d(x, y, ghost);
      }
    }
  }

  void _drawKnife(Function(int, int, Color) d) {
    final metal = Colors.grey.shade300;
    final handle = Colors.brown.shade800;
    // Handle
    for (int x = 3; x < 7; x++) {
      d(x, 10, handle);
    }
    // Blade
    for (int x = 7; x < 14; x++) {
      d(x, 9, metal);
      d(x, 10, metal);
    }
    d(14, 10, metal);
  }

  void _drawSword(Function(int, int, Color) d) {
    final metal = Colors.grey.shade200;
    final handle = Colors.brown.shade700;
    // Handle
    for (int x = 2; x < 5; x++) {
      d(x, 13, handle);
    }
    // Guard
    d(5, 12, Colors.amber);
    d(5, 13, Colors.amber);
    d(5, 14, Colors.amber);
    // Blade
    for (int i = 0; i < 10; i++) {
      d(6 + i, 12 - i, metal);
    }
  }

  void _drawAxe(Function(int, int, Color) d) {
    final wood = Colors.brown.shade600;
    final head = Colors.grey.shade400;
    // Handle
    for (int y = 4; y < 14; y++) {
      d(8, y, wood);
    }
    // Head
    for (int x = 4; x < 8; x++) {
      for (int y = 4; y < 8; y++) {
        d(x, y, head);
      }
    }
  }

  void _drawBrassKnuckles(Function(int, int, Color) d) {
    final metal = Colors.grey.shade400;
    for (int i = 0; i < 4; i++) {
      d(6 + i * 2, 7, metal);
      d(6 + i * 2, 8, metal);
    }
    for (int x = 6; x < 13; x++) {
      d(x, 10, metal);
    }
  }

  void _drawPoisonBlowgun(Function(int, int, Color) d) {
    final tube = Colors.brown.shade400;
    for (int x = 2; x < 15; x++) {
      d(x, 8, tube);
    }
    d(14, 8, Colors.green); // Poison tip
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

  void _drawMissile(Function(int, int, Color) d) {
    final body = Colors.grey.shade400;
    for (int x = 4; x < 12; x++) {
      d(x, 8, body);
    }
    d(12, 8, Colors.red); // Warhead
    d(3, 7, Colors.grey); // Fin
    d(3, 9, Colors.grey); // Fin
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
