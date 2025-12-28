import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';
import '../widgets/pixel_art_icon.dart';

class CrackhouseScreen extends StatelessWidget {
  const CrackhouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crackhouse - Droid Gangwar'),
        backgroundColor: Colors.purple.shade900,
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
              Colors.purple.shade900,
              Colors.purple.shade700,
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
                        '🏚️ THE CRACKHOUSE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Cash: \$${gameState.money}',
                        style: const TextStyle(fontSize: 18, color: Colors.greenAccent),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Recruit Section
              Card(
                color: Colors.pink.shade900.withValues(alpha: 0.4),
                child: ListTile(
                  leading: const PixelArtIcon(name: 'prostitute', size: 48),
                  title: const Text('Recruit Prostitutes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('Earn \$100/day. Cost: \$${gameState.prostitutes.price}', style: const TextStyle(color: Colors.white70)),
                  trailing: ElevatedButton(
                    onPressed: () => gameProvider.recruitProstitute(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                    child: const Text('RECRUIT'),
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              const Text(
                'Market Prices:',
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
                backgroundColor: Colors.brown.shade800,
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
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            PixelArtIcon(name: drugName, size: 50),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        drugName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'Stash: $quantity kg',
                        style: const TextStyle(fontSize: 14, color: Colors.amberAccent),
                      ),
                    ],
                  ),
                  Text('\$$price/kg', style: const TextStyle(color: Colors.greenAccent)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showBuyDialog(context, drugName, price),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800, padding: const EdgeInsets.symmetric(horizontal: 20)),
                        child: const Text('BUY'),
                      ),
                      ElevatedButton(
                        onPressed: quantity > 0 ? () => _showSellDialog(context, drugName, price) : null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800, padding: const EdgeInsets.symmetric(horizontal: 20)),
                        child: const Text('SELL'),
                      ),
                    ],
                  ),
                ],
              ),
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
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            PixelArtIcon(name: drugName, size: 30),
            const SizedBox(width: 10),
            Text('Buy $drugName', style: const TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: \$${price.toString()}/kg', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Quantity (kg)',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              final quantity = int.tryParse(quantityController.text) ?? 1;
              gameProvider.tradeDrug(drugName.toLowerCase(), 'buy', quantity);
              Navigator.pop(context);
            },
            child: const Text('BUY'),
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

    final quantityController = TextEditingController(text: quantity.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            PixelArtIcon(name: drugName, size: 30),
            const SizedBox(width: 10),
            Text('Sell $drugName', style: const TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: \$${price.toString()}/kg', style: const TextStyle(color: Colors.white70)),
            Text('Available: $quantity kg', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Quantity (kg)',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              final sellQuantity = int.tryParse(quantityController.text) ?? 1;
              if (sellQuantity > 0 && sellQuantity <= quantity) {
                gameProvider.tradeDrug(drugName.toLowerCase(), 'sell', sellQuantity);
                Navigator.pop(context);
              }
            },
            child: const Text('SELL'),
          ),
        ],
      ),
    );
  }
}
