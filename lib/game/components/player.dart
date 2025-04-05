import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:jetpack_guy_video_game/game/components/bullets.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class JetPackGuy extends SpriteAnimationComponent
    with HasGameRef<JetPackGame>, CollisionCallbacks {
  // Physics constants
  static const double gravity = 400.0;
  static const double jumpForce = -250.0;

  // Sprite sheet configuration (512x128 with 4 frames)
  static const double _frameWidth = 128.0;
  static const double _frameHeight = 128.0;
  static const int _frameCount = 4;
  static const double _frameTime = 0.1;
  static const double _renderScale = 0.5; // Render at 64x64

  // Game state
  double health = 100.0;
  final Vector2 velocity = Vector2.zero();
  late final TextPaint debugTextPaint;
  double _debugTimer = 0.0; // For debug logging

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    debugTextPaint = TextPaint(
      style: const TextStyle(color: Colors.white, fontSize: 12),
    );

    debugPrint('Loading player sprite sheet...');

    try {
      final spriteImage = await gameRef.images.load(
        'characters/jetpack_guy.png',
      );

      final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(_frameWidth, _frameHeight),
      );

      animation = spriteSheet.createAnimation(
        row: 0,
        stepTime: _frameTime,
        to: _frameCount,
      )..loop = true;

      size = Vector2(
        _frameWidth * _renderScale,
        _frameHeight * _renderScale,
      );

      position = Vector2(100.0, gameRef.size.y / 2.0);
      anchor = Anchor.center;

      add(CircleHitbox(
        radius: size.x / 2.5,
        anchor: Anchor.center,
      ));

    } catch (e) {
      debugPrint('Error loading sprite: $e');
      _createFallbackVisuals();
    }
  }

  void _createFallbackVisuals() {
    add(RectangleComponent(
      size: Vector2(64.0, 64.0),
      paint: Paint()..color = Colors.blue,
    )..add(
      TextComponent(
        text: 'PLAYER',
        textRenderer: debugTextPaint,
        anchor: Anchor.center,
      ),
    ),
    );
  }

  @override
  void render(Canvas canvas) {
    if (gameRef.debugMode) {
      canvas.drawRect(
        size.toRect(),
        Paint()
          ..color = Colors.red.withOpacity(0.3)
          ..style = PaintingStyle.stroke,
      );
    }
    super.render(canvas);
  }

  void flyUp() => velocity.y = jumpForce;

  void shoot() {
    gameRef.add(PlayerBullet(position + Vector2(width, 0.0)));
    debugPrint('Player shot bullet at ${position.toString()}');
  }

  void takeDamage(double damage) {
    health -= damage;
    debugPrint('Player took $damage damage. Health: $health');
    if (health <= 0) gameOver();
  }

  void gameOver() {
    debugPrint('GAME OVER');
    // Handle game over
  }

  @override
  void update(double dt) {
    velocity.y += gravity * dt;
    position += velocity * dt;
    position.y = position.y.clamp(0.0, gameRef.size.y - height);

    // Debug logging (every second)
    _debugTimer += dt;
    if (_debugTimer >= 1.0) {
      _debugTimer = 0.0;
      debugPrint('Player position: $position');
    }
  }
}