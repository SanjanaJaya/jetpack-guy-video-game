import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart'; // Added for hitboxes
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class JetPackGuy extends SpriteAnimationComponent
    with HasGameRef<JetPackGame>, CollisionCallbacks {
  static const double gravity = 400.0;
  static const double jumpForce = -250.0;
  double health = 100.0;
  final Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteImage = await gameRef.images.load('characters/jetpack_guy.png');

    final spriteSheet = SpriteSheet(
      image: spriteImage,
      srcSize: Vector2(32.0, 32.0),
    );

    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.1,
      to: 4,
    );

    position = Vector2(100.0, gameRef.size.y / 2.0);
    size = Vector2(64.0, 64.0);
    anchor = Anchor.center;

    // Proper hitbox implementation
    add(CircleHitbox(
      radius: 20.0,
      anchor: Anchor.center,
    ));
  }

  void flyUp() => velocity.y = jumpForce;

  void shoot() {
    gameRef.world.add(PlayerBullet(position + Vector2(width, 0.0)));
  }

  void takeDamage(double damage) {
    health -= damage;
    if (health <= 0) gameOver();
  }

  void gameOver() {
    // Game over logic
  }

  @override
  void update(double dt) {
    velocity.y += gravity * dt;
    position += velocity * dt;
    position.y = position.y.clamp(0.0, gameRef.size.y - height);
  }
}