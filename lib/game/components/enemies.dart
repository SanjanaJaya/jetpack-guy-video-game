import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class EnemySpawner extends Component with HasGameRef<JetPackGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TimerComponent(
      period: 3,
      repeat: true,
      onTick: () => gameRef.add(EnemyPlane()),
    ));
  }
}

class EnemyPlane extends SpriteComponent with HasGameRef<JetPackGame>, CollisionCallbacks {
  static const double speed = 150;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('enemies/enemy_plane.png');
    size = Vector2(80, 60);
    position = Vector2(
      gameRef.size.x,
      gameRef.random.nextDouble() * gameRef.size.y * 0.8,
    );
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= speed * dt;
    if (position.x < -width) removeFromParent();
  }
}