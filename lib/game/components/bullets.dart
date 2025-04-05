import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class Bullet extends SpriteComponent with HasGameRef<JetPackGame> {
  static const double speed = 500.0;

  Bullet(Vector2 position) {
    this.position = position;
    size = Vector2(20.0, 10.0);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('projectiles/player_bullet.png');
  }

  @override
  void update(double dt) {
    position.x += speed * dt;
    if (position.x > gameRef.size.x) {
      removeFromParent();
    }
  }
}