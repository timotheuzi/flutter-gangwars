import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/building_entry_animation.dart';
import '../widgets/wandering_animation.dart';
import '../widgets/city_navigation.dart';
import '../screens/procedural_demo_screen.dart';
import '../screens/procedural_open_world_screen.dart';
import 'main_menu_screen.dart';
import 'city_screen.dart';
import 'crackhouse_screen.dart';
import 'gunshack_screen.dart';
import 'bank_screen.dart';
import 'bar_screen.dart';
import 'infobooth_screen.dart';
import 'alleyway_screen.dart';
import 'picknsave_screen.dart';
import 'credits_screen.dart';
import 'mud_fight_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    if (gameProvider.showingBuildingAnimation) {
      return SafeArea(
        child: BuildingEntryAnimation(
          buildingType: gameProvider.buildingAnimationType,
          onAnimationComplete: () => gameProvider.completeBuildingAnimation(),
        ),
      );
    }

    if (gameProvider.showingWanderingAnimation) {
      return SafeArea(
        child: WanderingAnimation(
          onAnimationComplete: () => gameProvider.completeWanderingAnimation(),
        ),
      );
    }

    return switch (gameProvider.currentScreen) {
      'main_menu' => const MainMenuScreen(),
      'city' => const CityScreen(),
      'city_navigation' => const CityNavigation(),
      'procedural_demo' => const ProceduralDemoScreen(),
      'procedural_open_world' => const ProceduralOpenWorldScreen(),
      'crackhouse' => const CrackhouseScreen(),
      'gunshack' => const GunshackScreen(),
      'bank' => const BankScreen(),
      'bar' => const BarScreen(),
      'infobooth' => const InfoBoothScreen(),
      'alleyway' => const AlleywayScreen(),
      'picknsave' => const PickNSaveScreen(),
      'credits' => const CreditsScreen(),
      'mud_fight' => const MudFightScreen(),
      _ => const MainMenuScreen(),
    };
  }
}
