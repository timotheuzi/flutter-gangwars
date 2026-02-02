import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:droid_gangwar_flutter/screens/main_screen.dart';
import 'package:droid_gangwar_flutter/providers/game_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: const GangWars(),
    ),
  );
}

class GangWars extends StatelessWidget {
  const GangWars({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Droid Gangwar',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'GameFont',
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
