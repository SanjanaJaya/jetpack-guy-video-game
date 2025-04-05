import 'package:flutter/material.dart';
import 'package:jet_pack_guy/game/jet_pack_game.dart';

void main() {
  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(game: JetPackGame()),
      ),
    );
  }
}