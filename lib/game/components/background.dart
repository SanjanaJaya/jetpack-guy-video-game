import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart'; // For Colors and debugPrint
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class Background extends ParallaxComponent<JetPackGame> with HasGameRef<JetPackGame> {
  @override
  Future<void> onLoad() async {
    // Initialize debug prints
    debugPrint('Loading background...');

    try {
      parallax = await gameRef.loadParallax(
        [
          ParallaxImageData('background/parallax.png'),
        ],
        baseVelocity: Vector2(20, 0),
        repeat: ImageRepeat.repeat,
      );
      debugPrint('Background loaded successfully!');
    } catch (e) {
      debugPrint('Error loading background: $e');
      // Fallback - create a solid color background
      final background = RectangleComponent(
        size: gameRef.size,
        paint: Paint()..color = const Color(0xFF222244),
      );
      add(background);
    }
  }
}