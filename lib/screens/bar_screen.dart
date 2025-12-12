import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';

class BarScreen extends StatelessWidget {
  const BarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar - Droid Gangwar'),
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
              Colors.amber.shade900,
              Colors.amber.shade700,
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
                        '🍺 BAR',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Money: \$${gameState.money}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Gather information, recruit members, and hear the latest street gossip.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'The bar is bustling with activity...',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('You hear rumors about rival gangs in the area...'),
                            ),
                          );
                        },
                        child: const Text('Listen to Rumors'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('You gather some useful intel about police patrols'),
                            ),
                          );
                        },
                        child: const Text('Gather Intel'),
                      ),
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
