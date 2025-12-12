import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade900,
              Colors.purple.shade800,
              Colors.blue.shade700,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'GANGWAR',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'FLUTTER EDITION',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white70,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 50),
                GameButton(
                  text: 'NEW GAME',
                  onPressed: () => _startNewGame(context),
                  icon: Icons.add,
                ),
                const SizedBox(height: 20),
                GameButton(
                  text: 'CONTINUE',
                  onPressed: () => _continueGame(context),
                  icon: Icons.play_arrow,
                ),
                const SizedBox(height: 20),
                GameButton(
                  text: 'CREDITS',
                  onPressed: () => _showCredits(context),
                  icon: Icons.info,
                ),
                const SizedBox(height: 20),
                GameButton(
                  text: 'QUIT',
                  onPressed: () => _quitGame(context),
                  icon: Icons.exit_to_app,
                ),
                const SizedBox(height: 30),
                const Text(
                  'A cross-platform adaptation of the classic Gang War game',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startNewGame(BuildContext context) {
    final playerNameController = TextEditingController();
    final gangNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Game'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: playerNameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: gangNameController,
              decoration: const InputDecoration(
                labelText: 'Gang Name',
                hintText: 'Enter your gang name',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (playerNameController.text.isNotEmpty &&
                  gangNameController.text.isNotEmpty) {
                final gameProvider =
                    Provider.of<GameProvider>(context, listen: false);
                gameProvider.startNewGame(
                  playerNameController.text,
                  gangNameController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _continueGame(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (gameProvider.gameState.playerName.isNotEmpty) {
      gameProvider.navigateToScreen('city');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No saved game found!')),
      );
    }
  }

  void _showCredits(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Credits'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Droid Gangwar - Flutter Edition'),
              SizedBox(height: 10),
              Text('Original Game: Gang War MUD by timotheuzi@hotmail.com'),
              Text(
                  'Flutter Adaptation: Built with Flutter for cross-platform support'),
              SizedBox(height: 15),
              Text('Features:'),
              Text(
                  '• Cross-platform: Android, iOS, Linux, Windows, macOS, Web'),
              Text('• Modern UI with Flutter widgets'),
              Text('• Full game logic migration from Kotlin to Dart'),
              Text('• State management with Provider'),
              Text('• Persistent game saves'),
              SizedBox(height: 15),
              Text('Special Thanks:'),
              Text('• Original Gang War community'),
              Text('• Flutter development team'),
              Text('• All beta testers'),
              SizedBox(height: 15),
              Text('Version 1.0'),
              Text('Built with ❤️ for gang warfare enthusiasts'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _quitGame(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quit Game'),
        content: const Text('Are you sure you want to quit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}
