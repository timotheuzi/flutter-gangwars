import 'package:flutter/material.dart';
import 'dart:math';
import 'pixel_art_member.dart';

class AlleywayEntryAnimation extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const AlleywayEntryAnimation({super.key, required this.onAnimationComplete});

  @override
  AlleywayEntryAnimationState createState() => AlleywayEntryAnimationState();
}

class AlleywayEntryAnimationState extends State<AlleywayEntryAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _playerPosition;
  late Animation<double> _playerBob;
  late Animation<double> _fogOpacity;
  late Animation<double> _shadowIntensity;

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

    _fogOpacity = Tween<double>(
      begin: 0.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _shadowIntensity = Tween<double>(
      begin: 0.0,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Dark alley background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey.shade900, Colors.black, Colors.black],
                  ),
                ),
              ),

              // Brick walls
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade900,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: _buildBrickWall(),
                ),
              ),

              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade900,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: _buildBrickWall(),
                ),
              ),

              // Ground
              Positioned(
                bottom: 0,
                left: 100,
                right: 100,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey.shade800, Colors.black],
                    ),
                  ),
                ),
              ),

              // Alley entrance glow (behind player)
              Positioned(
                left: -50,
                top: 0,
                bottom: 0,
                width: 150,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.yellow.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Mysterious fog/atmosphere
              Positioned.fill(
                child: Container(
                  color: Colors.grey.withValues(alpha: _fogOpacity.value),
                ),
              ),

              // Shadow overlay
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: _shadowIntensity.value),
                ),
              ),

              // Player
              Positioned(
                left: _playerPosition.value,
                bottom: 120 + sin(_playerBob.value) * 5,
                child: Transform.scale(
                  scaleX: 1.8,
                  child: const PixelArtMember(
                    isPlayer: true,
                    isAlive: true,
                    isCheering: false,
                    size: 28,
                  ),
                ),
              ),

              // Title text with eerie effect
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Entering the Dark Alley',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 15.0,
                          color: Colors.red.shade900,
                          offset: Offset(2.0, 2.0),
                        ),
                        Shadow(
                          blurRadius: 25.0,
                          color: Colors.black,
                          offset: Offset(4.0, 4.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Subtle red glow effects
              ..._buildRedGlows(),

              // Floating particles (dust, mystery)
              ..._buildMysteriousParticles(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBrickWall() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final brickWidth = constraints.maxWidth / 4;
        final brickHeight = 15.0;

        return Column(
          children: List.generate(
            (constraints.maxHeight / brickHeight).ceil(),
            (rowIndex) {
              return Row(
                children: List.generate(4, (colIndex) {
                  final isOffset = rowIndex % 2 == 1;
                  return Container(
                    width: brickWidth,
                    height: brickHeight,
                    margin: EdgeInsets.only(
                      left: isOffset && colIndex == 0 ? brickWidth / 2 : 0,
                      right: isOffset && colIndex == 3 ? brickWidth / 2 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: rowIndex % 3 == 0
                          ? Colors.red.shade800
                          : Colors.red.shade900,
                      border: Border.all(color: Colors.red.shade50, width: 1),
                    ),
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }

  List<Widget> _buildRedGlows() {
    return [
      Positioned(
        left: 150,
        top: 200,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.red.shade900.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade900.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
      ),
      Positioned(
        right: 200,
        top: 150,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.red.shade800.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade800.withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildMysteriousParticles() {
    final random = Random(123); // Fixed seed for consistent animation
    final particles = <Widget>[];

    for (int i = 0; i < 12; i++) {
      final startX =
          120 + random.nextDouble() * (MediaQuery.of(context).size.width - 240);
      final startY = 100 + random.nextDouble() * 200;
      final endX = startX + (random.nextDouble() - 0.5) * 100;
      final endY = startY - 30 - random.nextDouble() * 60;

      final animation = Tween<Offset>(
        begin: Offset(startX, startY),
        end: Offset(endX, endY),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            random.nextDouble() * 0.6,
            min(1.0, random.nextDouble() * 0.4 + 0.6),
            curve: Curves.easeOut,
          ),
        ),
      );

      particles.add(
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              left: animation.value.dx,
              top: animation.value.dy,
              child: Container(
                width: 1 + random.nextDouble() * 3,
                height: 1 + random.nextDouble() * 3,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade900.withValues(alpha: 0.2),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return particles;
  }
}
