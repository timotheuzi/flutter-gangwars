import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credits - Droid Gangwar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => gameProvider.navigateToScreen('city'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade900,
              Colors.teal.shade700,
              Colors.deepPurple.shade600,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '🎬 CREDITS',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Game information and credits',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Droid Gangwar - Flutter Edition',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Original Game: Gang War MUD by timotheuzi@hotmail.com\n\n'
                        'Crypto Donations:\n'
                        'LTC ltc1qcx3xsrpxqm7q7gpkxhxhtaeqgdqpmq0jdrw7vh\n'
                        'SOL 4sAaizpXmFS4yedakv7mLN1Z2myGh2CWnes3YJBhF1Hb\n'
                        'XLM GCVYEJ7GC7LZZ2EBZL5DXWCLTZPTXX7YEUXLS36YGE6BA37R5BHRI2XG\n'
                        'BTC bc1qfv69rux98r7u3sr786j2qpsenmkskvkf58ynkk\n'
                        'ETH 0xD1A6b95958dE597c2D9478A3b4212adF0789BF81',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Flutter Adaptation: Cross-platform Flutter implementation',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Features:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                          '• Cross-platform: Android, iOS, Linux, Windows, macOS, Web',
                          style: TextStyle(color: Colors.white70)),
                      const Text('• Modern UI with Flutter widgets',
                          style: TextStyle(color: Colors.white70)),
                      const Text('• State management with Provider',
                          style: TextStyle(color: Colors.white70)),
                      const Text('• Persistent game saves',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 20),
                      const Text(
                        'Special Thanks:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('• Original Gang War community',
                          style: TextStyle(color: Colors.white70)),
                      const Text('• Flutter development team',
                          style: TextStyle(color: Colors.white70)),
                      const Text('• All beta testers and contributors',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 20),
                      const Text(
                        'Version: 1.0',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const Text(
                        'Built with ❤️ for gang warfare enthusiasts',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Technologies Used:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('• Flutter 3.38.4',
                          style: TextStyle(color: Colors.white70)),
                      const Text('• Dart 3.10.3',
                          style: TextStyle(color: Colors.white70)),
                      const Text('• Provider for state management',
                          style: TextStyle(color: Colors.white70)),
                      const Text('• Shared Preferences for persistence',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GameButton(
                text: 'Return to City',
                onPressed: () => gameProvider.navigateToScreen('city'),
                icon: Icons.arrow_back,
                backgroundColor: Colors.brown,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
