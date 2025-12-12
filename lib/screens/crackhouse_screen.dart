import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';

class CrackhouseScreen extends StatelessWidget {
  const CrackhouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crackhouse - Droid Gangwar'),
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
              Colors.purple.shade900,
              Colors.purple.shade700,
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
                        '🏠 CRACKHOUSE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Money: \$${gameState.money}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Buy and sell drugs to make money and expand your gang\'s influence.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Available Drugs:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    _buildDrugCard(context, 'Weed', gameState.drugPrices['weed'] ?? 500),
                    _buildDrugCard(context, 'Crack', gameState.drugPrices['crack'] ?? 1000),
                    _buildDrugCard(context, 'Coke', gameState.drugPrices['coke'] ?? 2000),
                    _buildDrugCard(context, 'Ice', gameState.drugPrices['ice'] ?? 1500),
                    _buildDrugCard(context, 'Percs', gameState.drugPrices['percs'] ?? 800),
                    _buildDrugCard(context, 'Pixie Dust', gameState.drugPrices['pixie_dust'] ?? 3000),
                  ],
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

  Widget _buildDrugCard(BuildContext context, String drugName, int price) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    // Get current quantity
    final quantity = switch (drugName.toLowerCase()) {
      'weed' => gameState.drugs.weed,
      'crack' => gameState.drugs.crack,
      'coke' => gameState.drugs.coke,
      'ice' => gameState.drugs.ice,
      'percs' => gameState.drugs.percs,
      'pixie dust' => gameState.drugs.pixieDust,
      _ => 0,
    };

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$drugName: \$$price/kg',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Owned: $quantity kg',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _showBuyDialog(context, drugName, price),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Buy'),
                ),
                ElevatedButton(
                  onPressed: quantity > 0
                      ? () => _showSellDialog(context, drugName, price)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Sell'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBuyDialog(BuildContext context, String drugName, int price) {
    final quantityController = TextEditingController(text: '1');
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buy $drugName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: \$${price.toString()}/kg'),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity (kg)',
                hintText: 'Enter amount to buy',
              ),
              keyboardType: TextInputType.number,
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
              final quantity = int.tryParse(quantityController.text) ?? 1;
              gameProvider.tradeDrug(drugName.toLowerCase(), 'buy', quantity);
              Navigator.pop(context);
            },
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }

  void _showSellDialog(BuildContext context, String drugName, int price) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final quantity = switch (drugName.toLowerCase()) {
      'weed' => gameProvider.gameState.drugs.weed,
      'crack' => gameProvider.gameState.drugs.crack,
      'coke' => gameProvider.gameState.drugs.coke,
      'ice' => gameProvider.gameState.drugs.ice,
      'percs' => gameProvider.gameState.drugs.percs,
      'pixie dust' => gameProvider.gameState.drugs.pixieDust,
      _ => 0,
    };

    final quantityController = TextEditingController(text: quantity > 0 ? '1' : '0');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sell $drugName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: \$${price.toString()}/kg'),
            Text('You have: $quantity kg'),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity (kg)',
                hintText: 'Enter amount to sell',
              ),
              keyboardType: TextInputType.number,
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
              final sellQuantity = int.tryParse(quantityController.text) ?? 1;
              if (sellQuantity > 0 && sellQuantity <= quantity) {
                gameProvider.tradeDrug(drugName.toLowerCase(), 'sell', sellQuantity);
                Navigator.pop(context);
              }
            },
            child: const Text('Sell'),
          ),
        ],
      ),
    );
  }
}
