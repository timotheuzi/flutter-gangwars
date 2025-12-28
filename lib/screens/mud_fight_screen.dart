import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';
import '../widgets/fight_animation.dart';

class MudFightScreen extends StatefulWidget {
  const MudFightScreen({super.key});

  @override
  State<MudFightScreen> createState() => _MudFightScreenState();
}

class _MudFightScreenState extends State<MudFightScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final combatData = gameProvider.currentCombatData;
    final combatResult = gameProvider.combatResult;

    if (combatData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Combat Error')),
        body: const Center(
          child: Text('No combat data available'),
        ),
      );
    }

    final isDefeated = gameProvider.gameState.health <= 0 || combatResult?.defeat == true;
    final isVictorious = combatResult?.victory == true;

    return Scaffold(
      appBar: AppBar(
        title: Text('${combatData.enemyType} Mud Fight'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.brown.shade900,
              Colors.red.shade900,
              Colors.black,
            ],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fight Animation - Mud style gang warfare with individual member sprites
                FightAnimation(
                  playerName: gameProvider.gameState.playerName,
                  gangName: gameProvider.gameState.gangName,
                  enemyType: combatData.enemyType,
                  playerHealth: gameProvider.gameState.health,
                  enemyHealth: combatResult?.remainingEnemyHealth ?? (combatData.enemyHealth * combatData.enemyCount).toInt(),
                  playerMaxHealth: gameProvider.gameState.maxHealth.toDouble(),
                  enemyMaxHealth: combatData.enemyHealth * combatData.enemyCount,
                  playerMembers: gameProvider.gameState.members,
                  enemyCount: combatData.enemyCount,
                  currentWeapon: gameProvider.combatResult?.fightLog.isNotEmpty == true 
                      ? _extractLastWeapon(gameProvider.combatResult!.fightLog.last) 
                      : 'fists',
                  showBloodEffects: (gameProvider.gameState.health < gameProvider.gameState.maxHealth * 0.7) ||
                                   (combatResult?.totalEnemyDamage != null && combatResult!.totalEnemyDamage > 0) ||
                                   isVictorious,
                ),

                const SizedBox(height: 20),

                // Combat Info Card
                Card(
                  elevation: 5,
                  color: Colors.brown.shade800.withValues(alpha: 0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          combatData.enemyType,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${combatData.enemyCount} enemies - Total Health: ${combatResult?.remainingEnemyHealth ?? (combatData.enemyHealth * combatData.enemyCount).toInt()}',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: gameProvider.gameState.health / gameProvider.gameState.maxHealth,
                          backgroundColor: Colors.grey,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Your Health: ${gameProvider.gameState.health}/${gameProvider.gameState.maxHealth}',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Fight Log
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: Card(
                    elevation: 3,
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            'Combat Log:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: combatResult?.fightLog.length ?? 0,
                              itemBuilder: (context, index) {
                                final logEntry =
                                    combatResult?.fightLog[index] ?? '';
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    logEntry,
                                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Combat Actions
                if (!isDefeated && !isVictorious)
                  Column(
                    children: [
                      // Ammo Selection
                      if (gameProvider.gameState.weapons.pistols > 0 ||
                          gameProvider.gameState.weapons.uzis > 0 ||
                          gameProvider.gameState.weapons.ar15 > 0)
                        Column(
                          children: [
                            const Text(
                              'Select Ammo Type:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                if (gameProvider.gameState.weapons.bullets > 0)
                                  _buildAmmoButton(context, 'Standard Bullets', 'bullets', gameProvider),
                                if (gameProvider.gameState.weapons.hollowPointBullets > 0)
                                  _buildAmmoButton(context, 'Hollow Point', 'hollow_point', gameProvider),
                                if (gameProvider.gameState.weapons.explodingBullets > 0)
                                  _buildAmmoButton(context, 'Exploding', 'exploding', gameProvider),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      const Text(
                        'Choose Your Weapon:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildWeaponButton(context, 'Fists', 'fists',
                              Icons.person),
                          if (gameProvider.gameState.weapons.pistols > 0)
                            _buildWeaponButton(context, 'Pistol', 'pistol',
                                Icons.security),
                          if (gameProvider.gameState.weapons.barbedWireBat > 0)
                            _buildWeaponButton(context, 'Barb Wired Bat', 'barbed_wire_bat',
                                Icons.sports_baseball),
                          if (gameProvider.gameState.weapons.uzis > 0)
                            _buildWeaponButton(context, 'Uzi', 'uzi',
                                Icons.toys),
                          if (gameProvider.gameState.weapons.ar15 > 0)
                            _buildWeaponButton(context, 'AR-15', 'ar15',
                                Icons.build),
                          if (gameProvider.gameState.weapons.grenades > 0)
                            _buildWeaponButton(context, 'Grenade', 'grenade',
                                Icons.explore),
                          if (gameProvider.gameState.weapons.knife > 0)
                            _buildWeaponButton(context, 'Knife', 'knife',
                                Icons.content_cut),
                          if (gameProvider.gameState.weapons.sword > 0)
                            _buildWeaponButton(context, 'Sword', 'sword',
                                Icons.sports_kabaddi),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Drug Selection
                      if (_hasAnyDrugs(gameProvider.gameState))
                        Column(
                          children: [
                            const Text(
                              'Use Drugs:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                if (gameProvider.gameState.drugs.crack > 0)
                                  _buildDrugButton(context, 'Crack', 'crack', gameProvider),
                                if (gameProvider.gameState.drugs.coke > 0)
                                  _buildDrugButton(context, 'Coke', 'coke', gameProvider),
                                if (gameProvider.gameState.drugs.weed > 0)
                                  _buildDrugButton(context, 'Weed', 'weed', gameProvider),
                                if (gameProvider.gameState.drugs.ice > 0)
                                  _buildDrugButton(context, 'Ice', 'ice', gameProvider),
                                if (gameProvider.gameState.drugs.percs > 0)
                                  _buildDrugButton(context, 'Percs', 'percs', gameProvider),
                                if (gameProvider.gameState.drugs.pixieDust > 0)
                                  _buildDrugButton(context, 'Pixie Dust', 'pixie_dust', gameProvider),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              gameProvider.fleeCombat();
                              gameProvider.navigateToScreen('city');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: const Text('FLEE'),
                          ),
                          if (gameProvider.gameState.pistolUpgraded)
                            const Text(
                              '🔫 AUTO',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ],
                  )
                else if (isVictorious)
                  _buildCombatResultCard(context, 'VICTORY', Colors.green,
                      Icons.emoji_events, combatResult!.finalMessage)
                else if (isDefeated)
                  _buildCombatResultCard(context, 'DEFEAT', Colors.red,
                      Icons.dangerous, combatResult?.defeat == true ? combatResult!.finalMessage : "You sustained fatal injuries before the fight could conclude."),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _extractLastWeapon(String log) {
    if (log.contains('pistol')) return 'pistol';
    if (log.contains('uzi')) return 'uzi';
    if (log.contains('ar15')) return 'ar15';
    if (log.contains('grenade')) return 'grenade';
    if (log.contains('knife')) return 'knife';
    if (log.contains('sword')) return 'sword';
    if (log.contains('bat')) return 'barbed_wire_bat';
    return 'fists';
  }

  Widget _buildWeaponButton(BuildContext context, String weaponName,
      String weaponType, IconData icon) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    return ElevatedButton.icon(
      onPressed: () {
        gameProvider.performCombat(
          weaponType,
          gameProvider.currentCombatData!.enemyType,
          gameProvider.currentCombatData!.enemyCount,
        );
        _scrollToTop();
      },
      icon: Icon(icon),
      label: Text(weaponName),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildAmmoButton(BuildContext context, String ammoName,
      String ammoType, GameProvider gameProvider) {
    final gameState = gameProvider.gameState;
    final isSelected = switch (ammoType) {
      'bullets' => !gameState.weapons.useExplodingBullets &&
                   !gameState.weapons.useHollowPointBullets,
      'hollow_point' => gameState.weapons.useHollowPointBullets,
      'exploding' => gameState.weapons.useExplodingBullets,
      _ => false,
    };

    return ElevatedButton(
      onPressed: () {
        // Toggle ammo selection
        switch (ammoType) {
          case 'bullets':
            gameProvider.gameState.weapons.useExplodingBullets = false;
            gameProvider.gameState.weapons.useHollowPointBullets = false;
          case 'hollow_point':
            gameProvider.gameState.weapons.useExplodingBullets = false;
            gameProvider.gameState.weapons.useHollowPointBullets = true;
          case 'exploding':
            gameProvider.gameState.weapons.useExplodingBullets = true;
            gameProvider.gameState.weapons.useHollowPointBullets = false;
        }
        gameProvider.saveGameState();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected $ammoName for next attack!'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(ammoName),
    );
  }

  Widget _buildDrugButton(BuildContext context, String drugName,
      String drugType, GameProvider gameProvider) {
    return ElevatedButton(
      onPressed: () {
        gameProvider.useDrug(drugType);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text('$drugName (${_getDrugCount(gameProvider.gameState, drugType)})'),
    );
  }

  bool _hasAnyDrugs(dynamic gameState) {
    return gameState.drugs.crack > 0 ||
           gameState.drugs.coke > 0 ||
           gameState.drugs.weed > 0 ||
           gameState.drugs.ice > 0 ||
           gameState.drugs.percs > 0 ||
           gameState.drugs.pixieDust > 0;
  }

  int _getDrugCount(dynamic gameState, String drugType) {
    return switch (drugType) {
      'crack' => gameState.drugs.crack,
      'coke' => gameState.drugs.coke,
      'weed' => gameState.drugs.weed,
      'ice' => gameState.drugs.ice,
      'percs' => gameState.drugs.percs,
      'pixie_dust' => gameState.drugs.pixieDust,
      _ => 0,
    };
  }

  Widget _buildCombatResultCard(BuildContext context, String title, Color color,
      IconData icon, String message) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    return Card(
      elevation: 5,
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              message,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GameButton(
              text: title == 'VICTORY' ? 'Continue' : 'Game Over',
              onPressed: title == 'VICTORY'
                  ? () => gameProvider.navigateToScreen('city')
                  : () {
                      gameProvider.navigateToScreen('main_menu');
                      gameProvider.restartGame(keepPersistentData: false);
                    },
              icon: title == 'VICTORY' ? Icons.check : Icons.restart_alt,
              backgroundColor:
                  title == 'VICTORY' ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
