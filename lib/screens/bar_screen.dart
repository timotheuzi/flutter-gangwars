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
        title: const Text('The Local Bar'),
        backgroundColor: Colors.amber.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_city),
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
              Colors.black,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                color: Colors.black45,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '🍺 THE RUSTY BUCKET',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'The air is thick with smoke and secrets. For a few bucks, you might learn something that keeps you alive or makes you rich.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Street Gossip & Market Intel:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: gameState.drugTrends.isEmpty
                    ? const Center(
                        child: Text(
                          'The regulars are tight-lipped today. Buy some drinks to loosen their tongues.',
                          style: TextStyle(color: Colors.white60),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: gameState.drugTrends.length,
                        itemBuilder: (context, index) {
                          final drug = gameState.drugTrends.keys.elementAt(
                            index,
                          );
                          final rumor = gameState.drugTrends[drug]!;
                          return Card(
                            color: Colors.grey.shade900,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.record_voice_over,
                                    color: Colors.amberAccent,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rumor about $drug:',
                                          style: const TextStyle(
                                            color: Colors.amberAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          rumor,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 10),
              GameButton(
                text: 'Buy a Round (\$100)',
                onPressed: () {
                  if (gameProvider.gameState.spendMoney(100)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'You buy a round for the house. The gossip gets louder...',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'You can\'t even afford a beer, kid. Get out.',
                        ),
                      ),
                    );
                  }
                },
                icon: Icons.local_drink,
                backgroundColor: Colors.orange.shade800,
              ),
              const SizedBox(height: 10),
              GameButton(
                text: 'Back to Streets',
                onPressed: () => gameProvider.navigateToScreen('city'),
                icon: Icons.arrow_back,
                backgroundColor: Colors.brown.shade800,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
