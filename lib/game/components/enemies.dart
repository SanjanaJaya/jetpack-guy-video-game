import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/collisions.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class EnemyPlane extends SpriteComponent
    with HasGameRef<JetPackGame>, CollisionCallbacks {
  static const double speed = 150.0; // Changed to double

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('enemy_plane1.png');
    size = Vector2(80.0, 60.0); // Changed to double
    position = Vector2(
      gameRef.size.x,
      gameRef.size.y * 0.2 + (gameRef.size.y * 0.6) * gameRef.random.nextDouble(),
    );
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= speed * dt;
    if (position.x < -width) removeFromParent();
  }
}

class EnemySpawner extends Component with HasGameRef<JetPackGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TimerComponent(
      period: 3.0, // Changed to double
      repeat: true,
      onTick: () => gameRef.add(EnemyPlane()),
    ));
  }
}