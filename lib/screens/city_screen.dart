import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../providers/game_provider.dart';
import '../widgets/game_world.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  late GangwarWorld _game;

  @override
  void initState() {
    super.initState();
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    _game = GangwarWorld(
      onEnterBuilding: (buildingType) {
        gameProvider.navigateToScreen(buildingType);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Scaffold(
      body: Stack(
        children: [
          // The Flame Game World
          GameWidget(game: _game),

          // Overlay UI: Stats
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatChip(
                  icon: Icons.favorite,
                  label: '${gameState.health}',
                  color: Colors.red,
                ),
                _buildStatChip(
                  icon: Icons.attach_money,
                  label: '${gameState.money}',
                  color: Colors.green,
                ),
                _buildStatChip(
                  icon: Icons.group,
                  label: '${gameState.members}',
                  color: Colors.blue,
                ),
                _buildStatChip(
                  icon: Icons.calendar_today,
                  label: 'Day ${gameState.day}',
                  color: Colors.orange,
                ),
              ],
            ),
          ),

          // Menu Button
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => _showMenu(context),
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.menu),
            ),
          ),

          // Game Message Overlay
          if (gameProvider.gameMessage.isNotEmpty)
            Positioned(
              top: 100,
              left: 50,
              right: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  gameProvider.gameMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'PAUSE MENU',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text(
                'Statistics',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _showStats(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.indigo),
              title: const Text(
                'Legacy Navigation',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Provider.of<GameProvider>(
                  context,
                  listen: false,
                ).navigateToScreen('city_navigation');
              },
            ),
            ListTile(
              leading: const Icon(Icons.terrain, color: Colors.green),
              title: const Text(
                '3D Open World',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Provider.of<GameProvider>(
                  context,
                  listen: false,
                ).navigateToScreen('procedural_open_world');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.red),
              title: const Text(
                'Restart Game',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _showRestartConfirm(context);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('RESUME'),
            ),
          ],
        ),
      ),
    );
  }

  void _showStats(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final gameState = gameProvider.gameState;
    final weapons = gameState.weapons;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Player Statistics',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${gameState.playerName}'),
                Text('Gang: ${gameState.gangName}'),
                Text('Day: ${gameState.day}'),
                Text('Health: ${gameState.health}/${gameState.maxHealth}'),
                Text('Money: \$${gameState.money}'),
                const SizedBox(height: 15),
                const Text(
                  'Weapons:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (weapons.pistols > 0) Text('Pistols: ${weapons.pistols}'),
                if (weapons.uzis > 0) Text('Uzis: ${weapons.uzis}'),
                const SizedBox(height: 15),
                const Text(
                  'Drugs:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text('Crack: ${gameState.drugs.crack}kg'),
                Text('Weed: ${gameState.drugs.weed}kg'),
              ],
            ),
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

  void _showRestartConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Restart Game?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will wipe all stats and progress.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<GameProvider>(
                context,
                listen: false,
              ).restartGame(keepPersistentData: false);
            },
            child: const Text('RESTART', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
