import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gangwar/screens/main_screen.dart';
import 'package:gangwar/providers/game_provider.dart';

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
      title: 'Gangwar',
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
