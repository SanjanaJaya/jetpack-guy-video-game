import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class EnemySpawner extends Component with HasGameRef<JetPackGame> {
  double _spawnTimer = 0.0;
  double _spawnInterval = 2.5;

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer += dt;

    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0.0;
      _spawnInterval = 2.0 + gameRef.random.nextDouble() * 3.0;
      gameRef.add(EnemyPlane());
    }
  }
}

class EnemyPlane extends SpriteComponent
    with HasGameRef<JetPackGame>, CollisionCallbacks {
  static const double speed = 200;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('enemies/enemy_plane.png');
    size = Vector2(100, 75);
    position = Vector2(
      gameRef.size.x,
      gameRef.random.nextDouble() * gameRef.size.y * 0.8,
    );
    priority = 2;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= speed * dt;
    if (position.x < -width) removeFromParent();
  }
}