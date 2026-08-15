import 'package:flutter/material.dart';
import 'dart:async';
import 'main_menu_background.dart';
import 'fight_animation.dart';
import 'drug_deal_animation.dart';
import 'prostitution_animation.dart';
import 'wandering_animation.dart';
import 'kill_animation.dart';
import 'animation_manager.dart';

class AnimationTestScreen extends StatefulWidget {
  const AnimationTestScreen({super.key});

  @override
  AnimationTestScreenState createState() => AnimationTestScreenState();
}

class AnimationTestScreenState extends State<AnimationTestScreen>
    with SingleTickerProviderStateMixin {
  late AnimationManager animationManager;
  String currentTest = 'main_menu';
  bool isAnimating = true;

  @override
  void initState() {
    super.initState();
    animationManager = AnimationManager();
    animationManager.initializeControllers(this);
  }

  @override
  void dispose() {
    animationManager.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Animation Test Suite'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(isAnimating ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                isAnimating = !isAnimating;
                if (isAnimating) {
                  animationManager.resumeAllAnimations();
                } else {
                  animationManager.pauseAllAnimations();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Test controls
          Container(
            color: Colors.grey.shade900,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTestButton('Main Menu', 'main_menu'),
                _buildTestButton('Fight', 'fight'),
                _buildTestButton('Drug Deal', 'drug_deal'),
                _buildTestButton('Prostitution', 'prostitution'),
                _buildTestButton('Wandering', 'wandering'),
                _buildTestButton('Kill', 'kill'),
              ],
            ),
          ),

          // Current test indicator
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade800,
            child: Text(
              'Current Test: $currentTest',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),

          // Animation area
          Expanded(child: _buildCurrentAnimation()),
        ],
      ),
    );
  }

  Widget _buildTestButton(String label, String testType) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentTest = testType;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: currentTest == testType
            ? Colors.blue
            : Colors.grey.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label),
    );
  }

  Widget _buildCurrentAnimation() {
    switch (currentTest) {
      case 'main_menu':
        return MainMenuBackground();

      case 'fight':
        return FightAnimation(
          playerName: 'Player',
          gangName: 'Gangsters',
          enemyType: 'Rivals',
          playerHealth: 80,
          enemyHealth: 60,
          playerMaxHealth: 100,
          enemyMaxHealth: 100,
          playerMembers: 3,
          enemyCount: 2,
          currentWeapon: 'pistol',
          showBloodEffects: true,
        );

      case 'drug_deal':
        return DrugDealAnimation(
          dealerName: 'Slim',
          drugType: 'crack',
          quantity: 5,
          price: 250,
          isSuccessful: true,
        );

      case 'prostitution':
        return ProstitutionAnimation(
          prostituteName: 'Candy',
          price: 50,
          isSuccessful: true,
        );

      case 'wandering':
        return WanderingAnimation(onAnimationComplete: () {});

      case 'kill':
        return KillAnimation(
          victimName: 'Enemy',
          weaponUsed: 'knife',
          isPlayerKiller: true,
        );

      default:
        return const Center(
          child: Text(
            'Select an animation test',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        );
    }
  }
}

// Demo widget showing all animations in sequence
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  AnimationDemoState createState() => AnimationDemoState();
}

class AnimationDemoState extends State<AnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationManager animationManager;
  int currentDemoStep = 0;
  late Timer _demoTimer;

  final List<String> demoSteps = [
    'main_menu',
    'wandering',
    'fight',
    'drug_deal',
    'prostitution',
    'kill',
  ];

  @override
  void initState() {
    super.initState();
    animationManager = AnimationManager();
    animationManager.initializeControllers(this);

    // Auto-advance through demos
    _demoTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      setState(() {
        currentDemoStep = (currentDemoStep + 1) % demoSteps.length;
      });
    });
  }

  @override
  void dispose() {
    _demoTimer.cancel();
    animationManager.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Animation Demo - Auto Cycle'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Demo step indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade900,
            child: Text(
              'Demo Step ${currentDemoStep + 1}/6: ${demoSteps[currentDemoStep]}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),

          // Current animation
          Expanded(child: _buildDemoAnimation(demoSteps[currentDemoStep])),

          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade800,
            child: const Text(
              'Animations cycle automatically every 8 seconds. All animations use pixel art style with optimized performance.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoAnimation(String demoType) {
    switch (demoType) {
      case 'main_menu':
        return Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'MAIN MENU - Enhanced Background',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            MainMenuBackground(),
            const SizedBox(height: 10),
            const Text(
              'Features: Animated characters, floating icons, dynamic background elements',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        );

      case 'wandering':
        return Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'WANDERING - Enhanced Street Scene',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            WanderingAnimation(onAnimationComplete: () {}),
            const SizedBox(height: 10),
            const Text(
              'Features: Floating danger/opportunity indicators, enhanced particle effects',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        );

      case 'fight':
        return Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'COMBAT - Dynamic Fight Animation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FightAnimation(
              playerName: 'Player',
              gangName: 'Gangsters',
              enemyType: 'Rivals',
              playerHealth: 75,
              enemyHealth: 45,
              playerMaxHealth: 100,
              enemyMaxHealth: 100,
              playerMembers: 3,
              enemyCount: 2,
              currentWeapon: 'uzi',
              showBloodEffects: true,
            ),
            const SizedBox(height: 10),
            const Text(
              'Features: Blood splatter, fight action effects, dynamic character animations',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        );

      case 'drug_deal':
        return Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'DRUG DEAL - Transaction Animation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DrugDealAnimation(
              dealerName: 'Slim',
              drugType: 'weed',
              quantity: 10,
              price: 500,
              isSuccessful: true,
            ),
            const SizedBox(height: 10),
            const Text(
              'Features: Money and drug particle effects, character interactions',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        );

      case 'prostitution':
        return Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'PROSTITUTION - Service Animation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ProstitutionAnimation(
              prostituteName: 'Candy',
              price: 75,
              isSuccessful: true,
            ),
            const SizedBox(height: 10),
            const Text(
              'Features: Heart particles, neon effects, character animations',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        );

      case 'kill':
        return Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'KILL - Violent Death Animation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            KillAnimation(
              victimName: 'Enemy',
              weaponUsed: 'pistol',
              isPlayerKiller: true,
            ),
            const SizedBox(height: 10),
            const Text(
              'Features: Blood explosion, gore effects, weapon animations',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        );

      default:
        return const Center(child: Text('Demo not available'));
    }
  }
}
