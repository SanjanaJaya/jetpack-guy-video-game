import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class EnemyPlane extends SpriteComponent
    with HasGameRef<JetPackGame>, CollisionCallbacks {
  static const double speed = 150.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load single PNG image (not sprite sheet)
    sprite = await Sprite.load(
      'enemies/enemy_plane1.png',
      images: gameRef.images,
    );

    size = Vector2(100.0, 80.0); // Set appropriate size
    position = Vector2(
      gameRef.size.x,
      gameRef.size.y * 0.2 + (gameRef.size.y * 0.6) * gameRef.random.nextDouble(),
    );

    // Add hitbox (adjust as needed)
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= speed * dt;
    if (position.x < -width) {
      removeFromParent();
    }
  }
}

class EnemySpawner extends Component with HasGameRef<JetPackGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TimerComponent(
      period: 3.0,
      repeat: true,
      onTick: () => gameRef.add(EnemyPlane()),
    ));
  }
}