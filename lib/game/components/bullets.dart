import 'package:flame/components.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class PlayerBullet extends SpriteComponent with HasGameRef<JetPackGame> {
  static const double speed = 400;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('player_bullet.png');
    size = Vector2(20, 10);
  }

  @override
  void update(double dt) {
    position.x += speed * dt;
    if (position.x > gameRef.size.x) removeFromParent();
  }
}

class EnemyBullet extends SpriteComponent with HasGameRef<JetPackGame> {
  static const double speed = 300;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('enemy_bullet.png');
    size = Vector2(20, 10);
  }

  @override
  void update(double dt) {
    position.x -= speed * dt;
    if (position.x < -width) removeFromParent();
  }
}