import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/game_provider.dart';
import '../widgets/event_animation.dart';
import 'pixel_art_member.dart';

class WanderingAnimation extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const WanderingAnimation({super.key, required this.onAnimationComplete});

  @override
  WanderingAnimationState createState() => WanderingAnimationState();
}

class WanderingAnimationState extends State<WanderingAnimation>
    with SingleAnimationProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _playerPosition;
  late Animation<double> _playerBob;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _playerPosition = Tween<double>(
      begin: -100.0,
      end: MediaQuery.of(context).size.width + 100,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _playerBob = Tween<double>(
      begin: 0.0,
      end: 4 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.repeat();

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.currentWanderingEvent.addListener(_onEventChanged);
  }

  @override
  void dispose() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.currentWanderingEvent.removeListener(_onEventChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Background sky
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade600,
                  Colors.purple.shade500,
                ],
              ),
            ),
          ),

          // Street background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(color: Colors.grey.shade800),
          ),

          // Sidewalk
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(color: Colors.grey.shade600),
          ),

          // Street lamps
          ..._buildStreetLamps(),

          // Buildings in background
          ..._buildBackgroundBuildings(),

          // Player
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: _playerPosition.value,
                bottom: 90 + sin(_playerBob.value) * 3,
                child: Transform.scale(
                  scaleX: 1.5,
                  child: const PixelArtMember(
                    isPlayer: true,
                    isAlive: true,
                    isCheering: false,
                    size: 24,
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
                'Wandering the Streets',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
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

          // Some floating particles (dust, leaves, etc.)
          ..._buildFloatingParticles(),
        ],
      ),
    );
  }

  List<Widget> _buildStreetLamps() {
    return [
      Positioned(
        left: 200,
        bottom: 80,
        child: Container(width: 4, height: 60, color: Colors.grey.shade700),
      ),
      Positioned(
        left: 198,
        bottom: 130,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.yellow,
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        left: 500,
        bottom: 80,
        child: Container(width: 4, height: 60, color: Colors.grey.shade700),
      ),
      Positioned(
        left: 498,
        bottom: 130,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.yellow,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildBackgroundBuildings() {
    return [
      // Building 1
      Positioned(
        right: 100,
        bottom: 80,
        child: Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            border: Border.all(color: Colors.grey.shade800, width: 2),
          ),
          child: Column(
            children: [
              Container(height: 20, color: Colors.red.shade900),
              Row(
                children: [
                  Container(width: 15, height: 60, color: Colors.blue.shade400),
                  Container(width: 15, height: 60, color: Colors.grey.shade800),
                  Container(width: 15, height: 60, color: Colors.blue.shade400),
                  Container(width: 15, height: 60, color: Colors.grey.shade800),
                  Container(width: 15, height: 60, color: Colors.blue.shade400),
                ],
              ),
            ],
          ),
        ),
      ),

      // Building 2
      Positioned(
        right: 250,
        bottom: 80,
        child: Container(
          width: 60,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.brown.shade700,
            border: Border.all(color: Colors.brown.shade800, width: 2),
          ),
          child: Column(
            children: [
              Container(height: 15, color: Colors.grey.shade800),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 75,
                    color: Colors.amber.shade300,
                  ),
                  Container(
                    width: 12,
                    height: 75,
                    color: Colors.brown.shade800,
                  ),
                  Container(
                    width: 12,
                    height: 75,
                    color: Colors.amber.shade300,
                  ),
                  Container(
                    width: 12,
                    height: 75,
                    color: Colors.brown.shade800,
                  ),
                  Container(
                    width: 12,
                    height: 75,
                    color: Colors.amber.shade300,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // Building 3
      Positioned(
        right: 400,
        bottom: 80,
        child: Container(
          width: 90,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            border: Border.all(color: Colors.blue.shade800, width: 2),
          ),
          child: Column(
            children: [
              Container(height: 10, color: Colors.red.shade900),
              Row(
                children: [
                  Container(width: 18, height: 50, color: Colors.white),
                  Container(width: 18, height: 50, color: Colors.blue.shade800),
                  Container(width: 18, height: 50, color: Colors.white),
                  Container(width: 18, height: 50, color: Colors.blue.shade800),
                  Container(width: 18, height: 50, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildFloatingParticles() {
    final random = Random(42); // Fixed seed for consistent animation
    final particles = <Widget>[];

    for (int i = 0; i < 8; i++) {
      final startX = 50 + random.nextDouble() * 300;
      final startY = 150 + random.nextDouble() * 100;
      final endX = startX + 200 + random.nextDouble() * 200;
      final endY = startY - 20 - random.nextDouble() * 40;

      final animation = Tween<Offset>(
        begin: Offset(startX, startY),
        end: Offset(endX, endY),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            random.nextDouble() * 0.5,
            min(1.0, random.nextDouble() * 0.5 + 0.5),
            curve: Curves.linear,
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
                width: 2 + random.nextDouble() * 2,
                height: 2 + random.nextDouble() * 2,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      );
    }

    return particles;
  }

  void _onEventChanged() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final event = gameProvider.currentWanderingEvent.value;
    if (event != null && mounted) {
      _controller.stop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            String? selectedOption;
            return AlertDialog(
              backgroundColor: Colors.grey.shade900,
              title: Text(
                event.title,
                style: const TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EventAnimation(event: event, selectedOption: selectedOption),
                  const SizedBox(height: 15),
                  Text(
                    event.description,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              actions: event.options.isNotEmpty
                  ? event.options.map((option) {
                      return TextButton(
                        onPressed: () {
                          setState(() => selectedOption = option);
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (mounted) {
                              final resultMessage = gameProvider
                                  .handleNpcInteraction(event, option);
                              if (gameProvider.currentScreen != 'mud_fight') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(resultMessage),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                              gameProvider.completeWanderingAnimation();
                              gameProvider.currentWanderingEvent.value = null;
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: Text(option),
                      );
                    }).toList()
                  : [
                      TextButton(
                        onPressed: () {
                          gameProvider.completeWanderingAnimation();
                          gameProvider.currentWanderingEvent.value = null;
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
            );
          },
        ),
      );
    }
  }
}