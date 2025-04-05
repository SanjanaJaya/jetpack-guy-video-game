import 'package:flutter/material.dart';
import 'package:flame/game.dart'; // Add this import for GameWidget
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

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