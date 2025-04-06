import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';
import 'package:jetpack_guy_video_game/game/components/bullets.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<JetPackGame>, CollisionCallbacks {
  static const double thrustPower = 500.0;
  static const double maxSpeed = 300.0;
  static const double gravity = 800.0;
  static const double horizontalSpeed = 200.0; // Constant horizontal movement

  static const double frameWidth = 128.0;
  static const double frameHeight = 128.0;
  static const int frameCount = 4;
  static const double frameTime = 0.1;

  final Vector2 velocity = Vector2.zero();
  late SpriteAnimation _flightAnimation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      final spriteImage = await gameRef.images.load(
        'characters/jetpack_guy.png',
      );

      final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(frameWidth, frameHeight),
      );

      _flightAnimation = spriteSheet.createAnimation(
        row: 0,
        stepTime: frameTime,
        to: frameCount,
      )..loop = true;

      animation = _flightAnimation;
      size = Vector2(64.0, 64.0);
      anchor = Anchor.center;
      position = Vector2(100, gameRef.size.y / 2);

      add(CircleHitbox(radius: 20.0));
    } catch (e) {
      add(RectangleComponent(
        size: Vector2(64.0, 64.0),
        paint: Paint()..color = const Color(0xFF0000FF),
      ));
    }
  }

  void startThrust() {
    animation?.stepTime = frameTime * 0.7;
  }

  void stopThrust() {
    animation?.stepTime = frameTime * 1.5;
  }

  void shoot() {
    gameRef.add(Bullet(position + Vector2(width, 0)));
  }

  @override
  void update(double dt) {
    velocity.y += gravity * dt;

    if ((gameRef as JetPackGame).isThrusting) {
      velocity.y -= thrustPower * dt;
    }

    // Constant horizontal movement
    velocity.x = horizontalSpeed;

    velocity.y = velocity.y.clamp(-maxSpeed, maxSpeed);
    velocity.x = velocity.x.clamp(0, horizontalSpeed); // Ensure no going back

    position += velocity * dt;

    position.y = position.y.clamp(size.y / 2, gameRef.size.y - size.y / 2);
    position.x = position.x.clamp(size.x / 2, gameRef.size.x - size.x / 2);
  }
}