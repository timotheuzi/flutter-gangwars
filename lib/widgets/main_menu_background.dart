import 'package:flutter/material.dart';
import 'dart:math';
import 'pixel_art_member.dart';

class MainMenuBackground extends StatefulWidget {
  const MainMenuBackground({super.key});

  @override
  State<MainMenuBackground> createState() => _MainMenuBackgroundState();
}

class _MainMenuBackgroundState extends State<MainMenuBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Car> _cars = [];
  final List<Prostitute> _prostitutes = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize background elements
    for (int i = 0; i < 3; i++) {
      _prostitutes.add(Prostitute(
        x: 50.0 + (i * 100),
        y: 450.0 + _random.nextDouble() * 50,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spawnCar() {
    if (_random.nextDouble() < 0.02 && _cars.length < 3) {
      _cars.add(Car(
        x: -150,
        y: 500.0 + _random.nextDouble() * 100,
        speed: 2.0 + _random.nextDouble() * 3.0,
        isDriveBy: _random.nextDouble() < 0.3,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _spawnCar();
        for (var car in _cars) {
          car.x += car.speed;
        }
        _cars.removeWhere((car) => car.x > MediaQuery.of(context).size.width + 100);

        return Stack(
          children: [
            // Background Sky/Buildings
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.deepPurple.shade900,
                    Colors.blue.shade900,
                  ],
                ),
              ),
            ),
            
            // Graffiti Wall
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.4,
                child: CustomPaint(
                  size: const Size(double.infinity, 300),
                  painter: GraffitiPainter(),
                ),
              ),
            ),

            // Street
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                color: Colors.grey.shade900,
              ),
            ),

            // Prostitutes waving
            ..._prostitutes.map((p) => Positioned(
              left: p.x,
              top: p.y,
              child: PixelArtMember(
                isPlayer: false, 
                isAlive: true, 
                isCheering: (sin(_controller.value * 20 + p.x) > 0), // Waving logic
                size: 40,
              ),
            )),

            // Cars / Drive-by
            ..._cars.map((car) => Positioned(
              left: car.x,
              top: car.y,
              child: _buildCar(car),
            )),
          ],
        );
      },
    );
  }

  Widget _buildCar(Car car) {
    return Column(
      children: [
        if (car.isDriveBy)
          const Padding(
            padding: EdgeInsets.only(left: 40, bottom: 0),
            child: Text('🔫🔥', style: TextStyle(fontSize: 20)),
          ),
        Container(
          width: 120,
          height: 50,
          decoration: BoxDecoration(
            color: car.isDriveBy ? Colors.black : Colors.red.shade900,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(10),
            ),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 30, height: 20, color: Colors.blue.withValues(alpha: 0.3)), // Window
              Container(width: 30, height: 20, color: Colors.blue.withValues(alpha: 0.3)), // Window
            ],
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 20),
            Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
            const SizedBox(width: 40),
            Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
          ],
        )
      ],
    );
  }
}

class GraffitiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void drawTag(String text, Offset pos, Color color) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
            color: color,
            shadows: const [Shadow(blurRadius: 10, color: Colors.black)],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, pos);
    }

    drawTag('GANGS', const Offset(20, 50), Colors.redAccent);
    drawTag('STREETS', const Offset(150, 120), Colors.greenAccent);
    drawTag('WAR', const Offset(50, 200), Colors.purpleAccent);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Car {
  double x;
  double y;
  double speed;
  bool isDriveBy;
  Car({required this.x, required this.y, required this.speed, required this.isDriveBy});
}

class Prostitute {
  double x;
  double y;
  Prostitute({required this.x, required this.y});
}
