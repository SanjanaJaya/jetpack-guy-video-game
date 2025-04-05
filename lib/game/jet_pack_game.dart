import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:jet_pack_guy/game/components/player.dart';
import 'package:jet_pack_guy/game/components/enemies.dart';

class JetPackGame extends FlameGame with HasCollisionDetection, TapDetector {
  late JetPackGuy player;
  int score = 0;
  double distance = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Setup camera
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