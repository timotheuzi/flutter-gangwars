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
        body: const Center(child: Text('No combat data available')),
      );
    }

    final isDefeated =
        gameProvider.gameState.health <= 0 || combatResult?.defeat == true;
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
            colors: [Colors.brown.shade900, Colors.red.shade900, Colors.black],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fight Animation - height reduced to 160
                SizedBox(
                  height: 160,
                  child: FightAnimation(
                    playerName: gameProvider.gameState.playerName,
                    gangName: gameProvider.gameState.gangName,
                    enemyType: combatData.enemyType,
                    playerHealth: gameProvider.gameState.health,
                    enemyHealth:
                        combatResult?.remainingEnemyHealth ??
                        (combatData.initialEnemyHealth / combatData.enemyCount)
                            .toInt(),
                    playerMaxHealth: gameProvider.gameState.maxHealth
                        .toDouble(),
                    enemyMaxHealth: combatData.initialEnemyHealth.toDouble(),
                    playerMembers: gameProvider.gameState.members,
                    enemyCount: combatData.enemyCount,
                    currentWeapon:
                        gameProvider.combatResult?.fightLog.isNotEmpty == true
                        ? _extractLastWeapon(
                            gameProvider.combatResult!.fightLog.last,
                          )
                        : 'fists',
                    showBloodEffects:
                        (gameProvider.gameState.health <
                            gameProvider.gameState.maxHealth * 0.7) ||
                        (combatResult?.totalEnemyDamage != null &&
                            combatResult!.totalEnemyDamage > 0) ||
                        isVictorious,
                  ),
                ),

                const SizedBox(height: 10),

                // Combat Info Card - Smaller
                Card(
                  elevation: 3,
                  color: Colors.brown.shade800.withValues(alpha: 0.8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          combatData.enemyType,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        Text(
                          '${combatData.enemyCount} enemies | Enemy HP: ${combatResult?.remainingEnemyHealth ?? (combatData.initialEnemyHealth / combatData.enemyCount).toInt()}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        LinearProgressIndicator(
                          value:
                              gameProvider.gameState.health /
                              gameProvider.gameState.maxHealth,
                          backgroundColor: Colors.grey.shade800,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.red,
                          ),
                        ),
                        Text(
                          'Your Health: ${gameProvider.gameState.health}/${gameProvider.gameState.maxHealth}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Combat Actions - Weapons and Ammo
                if (!isDefeated && !isVictorious)
                  Column(
                    children: [
                      // Ammo Selection - Smaller icons/text
                      if (gameProvider.gameState.weapons.pistols > 0 ||
                          gameProvider.gameState.weapons.uzis > 0 ||
                          gameProvider.gameState.weapons.ar15 > 0)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: [
                            if (gameProvider.gameState.weapons.bullets > 0)
                              _buildAmmoButton(
                                context,
                                'STD',
                                'bullets',
                                gameProvider,
                              ),
                            if (gameProvider
                                    .gameState
                                    .weapons
                                    .hollowPointBullets >
                                0)
                              _buildAmmoButton(
                                context,
                                'HP',
                                'hollow_point',
                                gameProvider,
                              ),
                            if (gameProvider
                                    .gameState
                                    .weapons
                                    .explodingBullets >
                                0)
                              _buildAmmoButton(
                                context,
                                'EXPL',
                                'exploding',
                                gameProvider,
                              ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      // Weapons - Smaller wrap
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildWeaponButton(
                            context,
                            'Fists',
                            'fists',
                            Icons.person,
                          ),
                          if (gameProvider.gameState.weapons.pistols > 0)
                            _buildWeaponButton(
                              context,
                              'Pistol',
                              'pistol',
                              Icons.security,
                            ),
                          if (gameProvider.gameState.weapons.barbedWireBat > 0)
                            _buildWeaponButton(
                              context,
                              'Bat',
                              'barbed_wire_bat',
                              Icons.sports_baseball,
                            ),
                          if (gameProvider.gameState.weapons.uzis > 0)
                            _buildWeaponButton(
                              context,
                              'Uzi',
                              'uzi',
                              Icons.toys,
                            ),
                          if (gameProvider.gameState.weapons.ar15 > 0)
                            _buildWeaponButton(
                              context,
                              'AR-15',
                              'ar15',
                              Icons.build,
                            ),
                          if (gameProvider.gameState.weapons.grenades > 0)
                            _buildWeaponButton(
                              context,
                              'Grenade',
                              'grenade',
                              Icons.explore,
                            ),
                          if (gameProvider.gameState.weapons.knife > 0)
                            _buildWeaponButton(
                              context,
                              'Knife',
                              'knife',
                              Icons.content_cut,
                            ),
                          if (gameProvider.gameState.weapons.sword > 0)
                            _buildWeaponButton(
                              context,
                              'Sword',
                              'sword',
                              Icons.sports_kabaddi,
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Drug Selection - Tiny icons
                      if (_hasAnyDrugs(gameProvider.gameState))
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: [
                            if (gameProvider.gameState.drugs.crack > 0)
                              _buildDrugButton(
                                context,
                                'Crack',
                                'crack',
                                gameProvider,
                              ),
                            if (gameProvider.gameState.drugs.coke > 0)
                              _buildDrugButton(
                                context,
                                'Coke',
                                'coke',
                                gameProvider,
                              ),
                            if (gameProvider.gameState.drugs.weed > 0)
                              _buildDrugButton(
                                context,
                                'Weed',
                                'weed',
                                gameProvider,
                              ),
                            if (gameProvider.gameState.drugs.ice > 0)
                              _buildDrugButton(
                                context,
                                'Ice',
                                'ice',
                                gameProvider,
                              ),
                            if (gameProvider.gameState.drugs.percs > 0)
                              _buildDrugButton(
                                context,
                                'Percs',
                                'percs',
                                gameProvider,
                              ),
                            if (gameProvider.gameState.drugs.pixieDust > 0)
                              _buildDrugButton(
                                context,
                                'Pixie',
                                'pixie_dust',
                                gameProvider,
                              ),
                          ],
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              gameProvider.fleeCombat();
                              gameProvider.navigateToScreen('city');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade700,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('FLEE'),
                          ),
                          if (gameProvider.gameState.pistolUpgraded) ...[
                            const SizedBox(width: 15),
                            const Text(
                              '🔫 AUTO',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  )
                else if (isVictorious)
                  _buildCombatResultCard(
                    context,
                    'VICTORY',
                    Colors.green,
                    Icons.emoji_events,
                    combatResult!.finalMessage,
                  )
                else if (isDefeated)
                  _buildCombatResultCard(
                    context,
                    'DEFEAT',
                    Colors.red,
                    Icons.dangerous,
                    combatResult?.defeat == true
                        ? combatResult!.finalMessage
                        : "You sustained fatal injuries.",
                  ),

                const SizedBox(height: 20),

                // Fight Log - Moved to the bottom
                Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: Card(
                    elevation: 3,
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            'Log:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: combatResult?.fightLog.length ?? 0,
                              itemBuilder: (context, index) {
                                final logEntry =
                                    combatResult?.fightLog[index] ?? '';
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  child: Text(
                                    logEntry,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _extractLastWeapon(String log) {
    if (log.contains('pistol')) return 'pistol';
    if (log.contains('uzi')) return 'uzi';
    if (log.contains('ar15')) return 'ar15';
    if (log.contains('grenade')) return 'grenade';
    if (log.contains('knife')) return 'knife';
    if (log.contains('sword')) return 'sword';
    if (log.contains('bat')) return 'barbed_wire_bat';
    return 'fists';
  }

  Widget _buildWeaponButton(
    BuildContext context,
    String weaponName,
    String weaponType,
    IconData icon,
  ) {
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
      icon: Icon(icon, size: 14),
      label: Text(weaponName, style: const TextStyle(fontSize: 11)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(60, 30),
      ),
    );
  }

  Widget _buildAmmoButton(
    BuildContext context,
    String ammoName,
    String ammoType,
    GameProvider gameProvider,
  ) {
    final gameState = gameProvider.gameState;
    final isSelected = switch (ammoType) {
      'bullets' =>
        !gameState.weapons.useExplodingBullets &&
            !gameState.weapons.useHollowPointBullets,
      'hollow_point' => gameState.weapons.useHollowPointBullets,
      'exploding' => gameState.weapons.useExplodingBullets,
      _ => false,
    };

    return ElevatedButton(
      onPressed: () {
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
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(40, 24),
      ),
      child: Text(ammoName, style: const TextStyle(fontSize: 10)),
    );
  }

  Widget _buildDrugButton(
    BuildContext context,
    String drugName,
    String drugType,
    GameProvider gameProvider,
  ) {
    return ElevatedButton(
      onPressed: () {
        gameProvider.useDrug(drugType);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(40, 24),
      ),
      child: Text(
        '$drugName (${_getDrugCount(gameProvider.gameState, drugType)})',
        style: const TextStyle(fontSize: 10),
      ),
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

  Widget _buildCombatResultCard(
    BuildContext context,
    String title,
    Color color,
    IconData icon,
    String message,
  ) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    return Card(
      elevation: 5,
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            GameButton(
              text: title == 'VICTORY' ? 'Continue' : 'Game Over',
              onPressed: title == 'VICTORY'
                  ? () => gameProvider.navigateToScreen('city')
                  : () {
                      gameProvider.navigateToScreen('main_menu');
                      gameProvider.restartGame(keepPersistentData: false);
                    },
              icon: title == 'VICTORY' ? Icons.check : Icons.restart_alt,
              backgroundColor: title == 'VICTORY' ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
