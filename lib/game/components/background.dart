import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:jetpack_guy_video_game/game/jet_pack_game.dart';

class Background extends PositionComponent with HasGameRef<JetPackGame> {
  final Random _random = Random();
  static const List<Color> _skyGradient = [
    Color(0xFF1A2980),
    Color(0xFF26D0CE),
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Use camera viewport size instead of game size
    size = gameRef.cameraComponent.viewport.size;
    _createBackground();
  }

  void _createBackground() {
    removeAll(children);

    // Main sky gradient background - now fills camera viewport
    add(
      RectangleComponent(
        size: size,
        paint: Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _skyGradient,
          ).createShader(
            Rect.fromLTWH(0, 0, size.x, size.y),
          ),
      )..position = Vector2.zero(),
    );

    // Add clouds (3 layers of parallax)
    _addCloudLayer(0.3, 15, 50, 100); // Distant clouds
    _addCloudLayer(0.6, 10, 80, 120); // Mid-distance clouds
    _addCloudLayer(1.0, 5, 100, 150); // Close clouds

    // Add stars
    for (int i = 0; i < 150; i++) {
      add(
        CircleComponent(
          position: Vector2(
            size.x * _random.nextDouble(),
            size.y * _random.nextDouble(),
          ),
          radius: _random.nextDouble() * 2 + 0.5,
          paint: Paint()..color = Colors.white.withAlpha(150),
        ),
      );
    }
  }

  void _addCloudLayer(double speed, int count, double minSize, double maxSize) {
    for (int i = 0; i < count; i++) {
      final cloud = Cloud(
        speed: speed,
        size: Vector2.all(minSize + _random.nextDouble() * (maxSize - minSize)),
        position: Vector2(
          size.x * _random.nextDouble(),
          size.y * 0.7 * _random.nextDouble(),
        ),
        gameRef: gameRef,
      );
      add(cloud);
    }
  }
}

class Cloud extends PositionComponent {
  final double speed;
  final JetPackGame gameRef;
  final Paint _paint = Paint()
    ..color = Colors.white.withOpacity(0.7)
    ..style = PaintingStyle.fill;

  Cloud({
    required this.speed,
    required this.gameRef,
    required super.size,
    required super.position,
  });

  @override
  void render(Canvas canvas) {
    canvas.drawOval(size.toRect(), _paint);
  }

  @override
  void update(double dt) {
    position.x -= speed * 30 * dt;
    if (position.x < -size.x * 2) {
      position.x = gameRef.cameraComponent.viewport.size.x + size.x;
      position.y = gameRef.cameraComponent.viewport.size.y * 0.7 * gameRef.random.nextDouble();
    }
  }
}