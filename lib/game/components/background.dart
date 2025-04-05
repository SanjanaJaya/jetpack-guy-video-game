import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class Background extends ParallaxComponent<JetPackGame> with HasGameRef<JetPackGame> {
  @override
  Future<void> onLoad() async {
    try {
      parallax = await gameRef.loadParallax(
        [ParallaxImageData('background/parallax.png')],
        baseVelocity: Vector2(20, 0),
        repeat: ImageRepeat.repeat,
      );
    } catch (e) {
      add(RectangleComponent(
        size: gameRef.size,
        paint: Paint()..color = const Color(0xFF222244),
      ));
    }
  }
}