// lib/game/components/bullets.dart
import 'package:flame/components.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class PlayerBullet extends SpriteComponent with HasGameRef<JetPackGame> {
  static const double speed = 400.0;

  PlayerBullet(Vector2 position) {
    this.position = position;
    size = Vector2(20.0, 10.0);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('projectiles/player_bullet.png');
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += speed * dt;

    if (position.x > gameRef.size.x) {
      removeFromParent();
    }
  }
}