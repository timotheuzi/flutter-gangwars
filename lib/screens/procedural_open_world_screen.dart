import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/isometric_world.dart';
import '../widgets/advanced_animations.dart';
import '../widgets/comprehensive_sprites.dart';
import '../widgets/cut_scene_system.dart';
import '../models/random_event.dart';
import '../widgets/procedural_3d_terrain.dart';

/// 3D Procedural Open World Screen
/// Displays a fully generated isometric world with terrain, buildings, NPCs,
/// and interactive elements using Flame game engine.
class ProceduralOpenWorldScreen extends StatefulWidget {
  const ProceduralOpenWorldScreen({super.key});

  @override
  ProceduralOpenWorldScreenState createState() =>
      ProceduralOpenWorldScreenState();
}

class ProceduralOpenWorldScreenState extends State<ProceduralOpenWorldScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _showLoading = true;
  String _loadingText = 'Generating 3D World...';
  late IsometricOpenWorld _game;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _game = IsometricOpenWorld(
      onEnterBuilding: _onEnterBuilding,
      onInteractNPC: _onInteractNPC,
      onStep: _onStep,
    );

    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    // Show loading progress
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _loadingText = 'Generating Terrain...');
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() => _loadingText = 'Placing Buildings...');
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() => _loadingText = 'Spawning NPCs...');
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _loadingText = 'Entering 3D World';
      });
    }

    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() => _showLoading = false);
      _fadeController.forward();
    }
  }

  void _onStep() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final event = gameProvider.wanderWithEvent();

    if (event != null && event.type != EventType.nothing) {
      _showRandomEventDialog(event);
    }
  }

  void _onInteractNPC(IsometricNPC npc) {
    // Mapping NPC type to interaction
    final npcNames = [
      'Police Officer',
      'Gangster',
      'Civilian',
      'Shady Dealer',
      'Prostitute',
      'Loan Shark'
    ];
    final name = npcNames[npc.type.clamp(0, 5)];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Interact with $name',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              color: npc.color,
            ),
            const SizedBox(height: 16),
            Text(
              'What do you want to do with this $name?',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ignore', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _triggerNPCInteraction(npc);
            },
            child: const Text('Interact', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _triggerNPCInteraction(IsometricNPC npc) {
     final gameProvider = Provider.of<GameProvider>(context, listen: false);
     // Generate a specific event based on NPC type
     // For now, let's just trigger a wander event which might be an NPC encounter
     final event = gameProvider.wanderWithEvent();
     if (event != null) {
       _showRandomEventDialog(event);
     }
  }

  void _showRandomEventDialog(RandomEvent event) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          event.title,
          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        content: Text(
          event.description,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: event.options.isEmpty
            ? [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK', style: TextStyle(color: Colors.white)),
                )
              ]
            : event.options.map((option) {
                return TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    gameProvider.handleNpcInteraction(event, option);
                    
                    // If the interaction led to combat, the provider will navigate
                    // but we might need to show feedback if it didn't
                    if (gameProvider.currentScreen != 'mud_fight' && gameProvider.gameMessage.isNotEmpty) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text(gameProvider.gameMessage))
                       );
                    }
                  },
                  child: Text(option, style: const TextStyle(color: Colors.amberAccent)),
                );
              }).toList(),
      ),
    );
  }

  void _onEnterBuilding(String buildingType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Enter ${buildingType.toUpperCase()}',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show the appropriate sprite for the building
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ComprehensiveSprites.createBuildingSprite(
                size: 80,
                type: _mapToBuildingType(buildingType),
                state: BuildingState.idle,
                isAnimated: true,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Do you want to enter the $buildingType?',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToBuilding(buildingType);
            },
            child: const Text('Enter', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  BuildingType _mapToBuildingType(String type) {
    return switch (type) {
      'bank' => BuildingType.bank,
      'bar' => BuildingType.bar,
      'crackhouse' => BuildingType.crackhouse,
      'gunshack' => BuildingType.gunshack,
      'house' => BuildingType.house,
      'hospital' => BuildingType.hospital,
      'police' => BuildingType.police,
      'store' || 'picknsave' => BuildingType.store,
      _ => BuildingType.store,
    };
  }

  void _navigateToBuilding(String buildingType) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.navigateToScreen(buildingType);
  }

  void _showGangFightCutScene() async {
    await CutSceneManager.showGangFightCutScene(
      context: context,
      playerGangName: 'Crew',
      enemyGangName: 'Rival',
      playerMembers: 4,
      enemyMembers: 5,
      onComplete: () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gang fight completed!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  void _showWeatherEffect() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Weather animation
              AdvancedAnimations.createWeatherAnimation(
                type: WeatherType.rain,
                intensity: 0.6,
                containerSize: const Size(300, 300),
              ),
              Center(
                child: AdvancedAnimations.createLoadingAnimation(
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Loading screen
          if (_showLoading) _buildLoadingScreen(),

          // Main game world
          if (!_showLoading)
            FadeTransition(
              opacity: _fadeAnimation,
              child: IsometricOpenWorldWidget(
                onEnterBuilding: _onEnterBuilding,
                onInteractNPC: _onInteractNPC,
                onStep: _onStep,
                onExit: () => _exitToMenu(),
              ),
            ),

          // Overlay controls
          if (!_showLoading) _buildOverlayControls(),
          
          // HUD Stats
          if (!_showLoading) _buildHUD(),
        ],
      ),
    );
  }
  
  Widget _buildHUD() {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;
    
    return Positioned(
      top: 40,
      right: 70, // Offset from exit button
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
             Icon(Icons.favorite, color: Colors.red, size: 16),
             const SizedBox(width: 4),
             Text('${gameState.health}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
             const SizedBox(width: 12),
             Icon(Icons.attach_money, color: Colors.green, size: 16),
             const SizedBox(width: 4),
             Text('${gameState.money}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
             const SizedBox(width: 12),
             Icon(Icons.calendar_today, color: Colors.orange, size: 16),
             const SizedBox(width: 4),
             Text('Day ${gameState.day}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black, Colors.deepPurple.shade900, Colors.black],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading animation
            AdvancedAnimations.createLoadingAnimation(
              size: 60,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 32),
            // Loading text
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: Colors.deepPurple.shade200,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              child: Text(_loadingText),
            ),
            const SizedBox(height: 24),
            // Progress indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLoadingDot(_loadingText.contains('Terrain')),
                const SizedBox(width: 8),
                _buildLoadingDot(_loadingText.contains('Buildings')),
                const SizedBox(width: 8),
                _buildLoadingDot(_loadingText.contains('NPCs')),
                const SizedBox(width: 8),
                _buildLoadingDot(_loadingText.contains('World')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: active ? Colors.deepPurple : Colors.deepPurple.shade800,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildOverlayControls() {
    return Positioned(
      top: 40,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'GANGWAR 3D',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Control buttons
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildControlIconButton(
                  icon: Icons.refresh,
                  tooltip: 'Regenerate World',
                  onPressed: () {
                    setState(() {
                      _showLoading = true;
                      _loadingText = 'Regenerating World...';
                    });
                    _game.regenerateWorld();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() => _showLoading = false);
                      }
                    });
                  },
                ),
                const SizedBox(height: 4),
                _buildControlIconButton(
                  icon: Icons.flash_on,
                  tooltip: 'Gang Fight Cut Scene',
                  onPressed: _showGangFightCutScene,
                ),
                const SizedBox(height: 4),
                _buildControlIconButton(
                  icon: Icons.water_drop,
                  tooltip: 'Weather Effect',
                  onPressed: _showWeatherEffect,
                ),
                const SizedBox(height: 4),
                _buildControlIconButton(
                  icon: Icons.add,
                  tooltip: 'Zoom In',
                  onPressed: () => _game.isoCamera.zoomBy(1.2),
                ),
                const SizedBox(height: 4),
                _buildControlIconButton(
                  icon: Icons.remove,
                  tooltip: 'Zoom Out',
                  onPressed: () => _game.isoCamera.zoomBy(0.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(6),
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white, size: 20),
          onPressed: onPressed,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
      ),
    );
  }

  void _exitToMenu() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Exit 3D World',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Return to the main menu?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              final gameProvider = Provider.of<GameProvider>(context, listen: false);
              gameProvider.navigateToScreen('main_menu');
            },
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
