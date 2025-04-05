import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class JetPackGuy extends SpriteAnimationComponent
    with HasGameRef<JetPackGame>, CollisionCallbacks {
  static const double gravity = 400;
  static const double jumpForce = -250;
  double health = 100;
  final Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('jetpack_guy.png'),
      srcSize: Vector2(32, 32),
    );

    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.1,
      to: 4,
    );

    position = Vector2(100, gameRef.size.y / 2);
    size = Vector2(64, 64);
    anchor = Anchor.center;
  }

  void flyUp() => velocity.y = jumpForce;

  void shoot() {
    gameRef.add(PlayerBullet(position + Vector2(width, 0)));
  }

  void takeDamage(double damage) {
    health -= damage;
    if (health <= 0) gameOver();
  }

  void gameOver() {
    // Implement game over logic
  }

  @override
  void update(double dt) {
    velocity.y += gravity * dt;
    position += velocity * dt;
    position.y = position.y.clamp(0, gameRef.size.y - height);
  }
}