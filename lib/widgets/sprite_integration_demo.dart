import 'package:flutter/material.dart';
import 'advanced_animations.dart';
import 'comprehensive_sprites.dart';

/// Sprite Integration Demo
/// Shows how to use all the new pixelated sprites and animations in the game

class SpriteIntegrationDemo extends StatefulWidget {
  const SpriteIntegrationDemo({super.key});

  @override
  SpriteIntegrationDemoState createState() => SpriteIntegrationDemoState();
}

class SpriteIntegrationDemoState extends State<SpriteIntegrationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentDemo = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gang Wars - Sprite Demo'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            // Demo selector
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDemoButton('Characters', 0),
                  _buildDemoButton('Weapons', 1),
                  _buildDemoButton('Effects', 2),
                  _buildDemoButton('Vehicles', 3),
                  _buildDemoButton('Buildings', 4),
                ],
              ),
            ),

            // Demo content
            Expanded(child: _buildDemoContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoButton(String title, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _currentDemo = index;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentDemo == index
            ? Colors.blue
            : Colors.grey.shade800,
        foregroundColor: Colors.white,
      ),
      child: Text(title),
    );
  }

  Widget _buildDemoContent() {
    switch (_currentDemo) {
      case 0:
        return _buildCharacterDemo();
      case 1:
        return _buildWeaponDemo();
      case 2:
        return _buildEffectDemo();
      case 3:
        return _buildVehicleDemo();
      case 4:
        return _buildBuildingDemo();
      default:
        return _buildCharacterDemo();
    }
  }

  Widget _buildCharacterDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Character Sprites',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Player characters
          const Text(
            'Player States:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildCharacterCard('Idle', CharacterState.idle, true),
              _buildCharacterCard('Walking', CharacterState.walking, true),
              _buildCharacterCard('Running', CharacterState.running, true),
              _buildCharacterCard('Attacking', CharacterState.attacking, true),
              _buildCharacterCard('Hurt', CharacterState.hurt, true),
              _buildCharacterCard(
                'Celebrating',
                CharacterState.celebrating,
                true,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Police characters
          const Text(
            'Police States:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildPoliceCard('Idle', PoliceState.idle),
              _buildPoliceCard('Alert', PoliceState.alert),
              _buildPoliceCard('Chasing', PoliceState.chasing),
              _buildPoliceCard('Shooting', PoliceState.shooting),
              _buildPoliceCard('Arresting', PoliceState.arresting),
              _buildPoliceCard('Hurt', PoliceState.hurt),
            ],
          ),

          const SizedBox(height: 30),

          // Civilian characters
          const Text(
            'Civilian Types:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildCivilianCard('Man', CivilianType.man, CivilianState.idle),
              _buildCivilianCard(
                'Woman',
                CivilianType.woman,
                CivilianState.idle,
              ),
              _buildCivilianCard(
                'Child',
                CivilianType.child,
                CivilianState.idle,
              ),
              _buildCivilianCard(
                'Elderly',
                CivilianType.elderly,
                CivilianState.idle,
              ),
              _buildCivilianCard(
                'Homeless',
                CivilianType.homeless,
                CivilianState.idle,
              ),
              _buildCivilianCard(
                'Scared',
                CivilianType.man,
                CivilianState.scared,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weapon Sprites',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Firearms
          const Text(
            'Firearms:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildWeaponCard('Pistol', WeaponType.pistol, WeaponState.idle),
              _buildWeaponCard('Uzi', WeaponType.uzi, WeaponState.idle),
              _buildWeaponCard('AR15', WeaponType.ar15, WeaponState.idle),
              _buildWeaponCard('Shotgun', WeaponType.shotgun, WeaponState.idle),
            ],
          ),

          const SizedBox(height: 30),

          // Melee weapons
          const Text(
            'Melee Weapons:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildWeaponCard('Knife', WeaponType.knife, WeaponState.idle),
              _buildWeaponCard('Bat', WeaponType.bat, WeaponState.idle),
              _buildWeaponCard('Grenade', WeaponType.grenade, WeaponState.idle),
              _buildWeaponCard('Vest', WeaponType.vest, WeaponState.idle),
            ],
          ),

          const SizedBox(height: 30),

          // Weapon states
          const Text(
            'Weapon States:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildWeaponCard('Idle', WeaponType.pistol, WeaponState.idle),
              _buildWeaponCard('Firing', WeaponType.pistol, WeaponState.firing),
              _buildWeaponCard(
                'Reloading',
                WeaponType.pistol,
                WeaponState.reloading,
              ),
              _buildWeaponCard(
                'Dropped',
                WeaponType.pistol,
                WeaponState.dropped,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEffectDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Effect Sprites',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Combat effects
          const Text(
            'Combat Effects:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildEffectCard('Muzzle Flash', EffectType.muzzleFlash),
              _buildEffectCard('Explosion', EffectType.explosion),
              _buildEffectCard('Blood', EffectType.blood),
              _buildEffectCard('Spark', EffectType.spark),
            ],
          ),

          const SizedBox(height: 30),

          // Environmental effects
          const Text(
            'Environmental Effects:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildEffectCard('Smoke', EffectType.smoke),
              _buildEffectCard('Fire', EffectType.fire),
              _buildEffectCard('Trail', EffectType.trail),
            ],
          ),

          const SizedBox(height: 30),

          // Weather effects
          const Text(
            'Weather Effects:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildWeatherCard('Rain', WeatherType.rain),
              _buildWeatherCard('Snow', WeatherType.snow),
              _buildWeatherCard('Fog', WeatherType.fog),
              _buildWeatherCard('Dust', WeatherType.dust),
            ],
          ),

          const SizedBox(height: 30),

          // Status effects
          const Text(
            'Status Effects:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildStatusCard('Poison', StatusEffectType.poison),
              _buildStatusCard('Burn', StatusEffectType.burn),
              _buildStatusCard('Freeze', StatusEffectType.freeze),
              _buildStatusCard('Boost', StatusEffectType.boost),
              _buildStatusCard('Shield', StatusEffectType.shield),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle Sprites',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Civilian vehicles
          const Text(
            'Civilian Vehicles:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildVehicleCard('Car', VehicleType.car, VehicleState.idle),
              _buildVehicleCard('Truck', VehicleType.truck, VehicleState.idle),
              _buildVehicleCard(
                'Motorcycle',
                VehicleType.motorcycle,
                VehicleState.idle,
              ),
              _buildVehicleCard('Taxi', VehicleType.taxi, VehicleState.idle),
            ],
          ),

          const SizedBox(height: 30),

          // Emergency vehicles
          const Text(
            'Emergency Vehicles:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildVehicleCard(
                'Police',
                VehicleType.police,
                VehicleState.idle,
              ),
              _buildVehicleCard(
                'Ambulance',
                VehicleType.ambulance,
                VehicleState.idle,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Vehicle states
          const Text(
            'Vehicle States:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildVehicleCard('Idle', VehicleType.car, VehicleState.idle),
              _buildVehicleCard('Moving', VehicleType.car, VehicleState.moving),
              _buildVehicleCard(
                'Crashed',
                VehicleType.car,
                VehicleState.crashed,
              ),
              _buildVehicleCard(
                'Exploding',
                VehicleType.car,
                VehicleState.exploding,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Building Sprites',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Commercial buildings
          const Text(
            'Commercial Buildings:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildBuildingCard(
                'Store',
                BuildingType.store,
                BuildingState.idle,
              ),
              _buildBuildingCard('Bank', BuildingType.bank, BuildingState.idle),
              _buildBuildingCard('Bar', BuildingType.bar, BuildingState.idle),
              _buildBuildingCard(
                'Hospital',
                BuildingType.hospital,
                BuildingState.idle,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Criminal buildings
          const Text(
            'Criminal Buildings:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildBuildingCard(
                'Crackhouse',
                BuildingType.crackhouse,
                BuildingState.idle,
              ),
              _buildBuildingCard(
                'Gunshack',
                BuildingType.gunshack,
                BuildingState.idle,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Other buildings
          const Text(
            'Other Buildings:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildBuildingCard(
                'House',
                BuildingType.house,
                BuildingState.idle,
              ),
              _buildBuildingCard(
                'Police',
                BuildingType.police,
                BuildingState.idle,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Building states
          const Text(
            'Building States:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildBuildingCard(
                'Idle',
                BuildingType.store,
                BuildingState.idle,
              ),
              _buildBuildingCard(
                'Damaged',
                BuildingType.store,
                BuildingState.damaged,
              ),
              _buildBuildingCard(
                'Burning',
                BuildingType.store,
                BuildingState.burning,
              ),
              _buildBuildingCard(
                'Destroyed',
                BuildingType.store,
                BuildingState.destroyed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(
    String label,
    CharacterState state,
    bool isPlayer,
  ) {
    return Container(
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdvancedAnimations.createCharacterAnimation(
            isPlayer: isPlayer,
            state: state,
            size: 60,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPoliceCard(String label, PoliceState state) {
    return Container(
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ComprehensiveSprites.createPoliceSprite(size: 60, state: state),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCivilianCard(
    String label,
    CivilianType type,
    CivilianState state,
  ) {
    return Container(
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ComprehensiveSprites.createCivilianSprite(
            size: 60,
            state: state,
            type: type,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponCard(String label, WeaponType type, WeaponState state) {
    return Container(
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ComprehensiveSprites.createWeaponSprite(
            size: 60,
            type: type,
            state: state,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEffectCard(String label, EffectType type) {
    return Container(
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ComprehensiveSprites.createEffectSprite(
            size: 60,
            type: type,
            state: EffectState.active,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(String label, WeatherType type) {
    return Container(
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdvancedAnimations.createWeatherAnimation(
            type: type,
            intensity: 0.5,
            containerSize: const Size(60, 60),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String label, StatusEffectType type) {
    return Container(
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdvancedAnimations.createStatusEffect(
            type: type,
            size: 60,
            duration: const Duration(seconds: 2),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(String label, VehicleType type, VehicleState state) {
    return Container(
      width: 150,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ComprehensiveSprites.createVehicleSprite(
            size: 60,
            type: type,
            state: state,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingCard(
    String label,
    BuildingType type,
    BuildingState state,
  ) {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ComprehensiveSprites.createBuildingSprite(
            size: 60,
            type: type,
            state: state,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
