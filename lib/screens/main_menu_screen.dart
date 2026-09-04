import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';
import '../widgets/main_menu_background.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          const MainMenuBackground(),

          // Menu Content
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'GANGWAR',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontFamily: 'Courier',
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            blurRadius: 15.0,
                            color: Colors.black,
                            offset: Offset(4.0, 4.0),
                          ),
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.white,
                            offset: Offset(-1.0, -1.0),
                          ),
                        ],
                      ),
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
                    const Text(
                      'FLUTTER EDITION',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4.0,
                      ),
                    ),
                    const SizedBox(height: 50),
                    _buildMenuButton(
                      context,
                      'ENTER 3D WORLD',
                      () => _handleEnter3DWorld(context),
                      Icons.terrain,
                    ),
                    const SizedBox(height: 15),
                    _buildMenuButton(
                      context,
                      'CREDITS',
                      () => _showCredits(context),
                      Icons.info,
                    ),
                    const SizedBox(height: 15),
                    _buildMenuButton(
                      context,
                      'QUIT',
                      () => _quitGame(context),
                      Icons.exit_to_app,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'STREETS NEVER SLEEP',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    IconData icon,
  ) {
    return SizedBox(
      width: 250,
      child: GameButton(
        text: text,
        onPressed: onPressed,
        icon: icon,
        backgroundColor: Colors.black.withValues(alpha: 0.7),
      ),
    );
  }

  void _handleEnter3DWorld(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (gameProvider.gameState.playerName.isEmpty) {
      _showNewGameDialog(context);
    } else {
      gameProvider.navigateToScreen('procedural_open_world');
    }
  }

  void _showNewGameDialog(BuildContext context) {
    final playerNameController = TextEditingController();
    final gangNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'NEW OPERATION',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: playerNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'STREET NAME',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: gangNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'GANG NAME',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ABORT', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              if (playerNameController.text.isNotEmpty &&
                  gangNameController.text.isNotEmpty) {
                final gameProvider = Provider.of<GameProvider>(
                  context,
                  listen: false,
                );
                gameProvider.startNewGame(
                  playerNameController.text,
                  gangNameController.text,
                  initialScreen: 'procedural_open_world',
                );
                Navigator.pop(context);
              }
            },
            child: const Text(
              'IGNITE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCredits(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.navigateToScreen('credits');
  }

  void _quitGame(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'LEAVING?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'The streets will remember your face.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('STAY', style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (Platform.isAndroid || Platform.isIOS) {
                SystemNavigator.pop();
              } else {
                exit(0);
              }
            },
            child: const Text(
              'EXIT',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
