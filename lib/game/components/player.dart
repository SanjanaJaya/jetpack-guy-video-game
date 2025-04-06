import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';
import 'bullets.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<JetPackGame>, CollisionCallbacks {
  static const double thrustPower = 600.0;
  static const double maxSpeed = 350.0;
  static const double gravity = 900.0;
  static const double horizontalSpeed = 250.0;

  final Vector2 velocity = Vector2.zero();
  late SpriteAnimation _flightAnimation;
  double _shootCooldown = 0.0;
  static const double shootCooldownTime = 0.3;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      final spriteImage = await gameRef.images.load('characters/jetpack_guy.png');
      final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(128.0, 128.0),
      );
      _flightAnimation = spriteSheet.createAnimation(
        row: 0,
        stepTime: 0.1,
        to: 4,
      )..loop = true;
      animation = _flightAnimation;
    } catch (e) {
      add(RectangleComponent(
        size: Vector2(80.0, 80.0),
        paint: Paint()..color = const Color(0xFF0000FF),
      ));
    }

    size = Vector2(80.0, 80.0);
    anchor = Anchor.center;
    position = Vector2(100, gameRef.size.y / 2);
    add(CircleHitbox(radius: 25.0));
  }

  void startThrust() {
    animation?.stepTime = 0.07;
  }

  void stopThrust() {
    animation?.stepTime = 0.15;
  }

  void shoot() {
    if (_shootCooldown <= 0) {
      gameRef.add(Bullet(position + Vector2(width / 2, 0)));
      _shootCooldown = shootCooldownTime;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_shootCooldown > 0) {
      _shootCooldown -= dt;
    }

    velocity.y += gravity * dt;
    if (gameRef.isThrusting) {
      velocity.y -= thrustPower * dt;
    }

    velocity.x = horizontalSpeed;
    velocity.y = velocity.y.clamp(-maxSpeed, maxSpeed);
    position += velocity * dt;
    position.y = position.y.clamp(size.y / 2, gameRef.size.y - size.y / 2);
  }
}