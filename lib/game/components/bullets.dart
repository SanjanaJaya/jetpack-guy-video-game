import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

// Import the enemy class (make sure the path is correct)
import 'enemies.dart';

class Bullet extends SpriteComponent
    with HasGameRef<JetPackGame>, CollisionCallbacks {
  static const double speed = 600.0;

  Bullet(Vector2 position) {
    this.position = position;
    size = Vector2(30.0, 15.0);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('projectiles/player_bullet.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x += speed * dt;
    if (position.x > gameRef.size.x) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Check if the other component is an EnemyPlane
    if (other is EnemyPlane) {
      removeFromParent(); // Remove the bullet
      other.removeFromParent(); // Remove the enemy
      gameRef.score += 10; // Optional: Add score
    }
  }
}