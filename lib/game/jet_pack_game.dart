import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart'; // Add this import for Anchor
import 'package:jetpack_guy_video_game/game/components/player.dart';
import 'package:jetpack_guy_video_game/game/components/enemies.dart';

class JetPackGame extends FlameGame with HasCollisionDetection, TapDetector {
  late JetPackGuy player;
  int score = 0;
  double distance = 0;
  final Random random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Setup camera - now with proper Anchor import
    camera.viewfinder.anchor = Anchor.topLeft;

    // Add player
    player = JetPackGuy();
    add(player);

    // Add enemy spawner
    add(EnemySpawner());
  }

  @override
  void update(double dt) {
    super.update(dt);
    distance += dt * 50;
    score = distance.toInt();
  }

  @override
  void onTap() {
    player.shoot();
  }
}