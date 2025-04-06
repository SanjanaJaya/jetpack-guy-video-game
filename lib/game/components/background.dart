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
    size = gameRef.cameraComponent.viewport.size;
    _createBackground();
  }

  void _createBackground() {
    removeAll(children);

    // Main gradient background
    add(
      RectangleComponent(
        size: size,
        paint: Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _skyGradient,
          ).createShader(Rect.fromLTWH(0, 0, size.x, size.y)),
      )..position = Vector2.zero(),
    );

    // Create parallax layers
    _createParallaxLayers();

    // Add stars
    _createStarField();
  }

  void _createParallaxLayers() {
    // Distant clouds (slowest)
    _addCloudLayer(
      speed: 0.3,
      count: 20,
      minSize: 40,
      maxSize: 80,
      opacity: 0.5,
      yRange: 0.6,
    );

    // Mid-distance clouds
    _addCloudLayer(
      speed: 0.6,
      count: 15,
      minSize: 60,
      maxSize: 100,
      opacity: 0.7,
      yRange: 0.7,
    );

    // Close clouds (fastest)
    _addCloudLayer(
      speed: 1.0,
      count: 10,
      minSize: 80,
      maxSize: 150,
      opacity: 0.9,
      yRange: 0.8,
    );
  }

  void _createStarField() {
    final starFieldWidth = size.x * 3; // Wider than viewport
    final starFieldHeight = size.y;

    for (int i = 0; i < 200; i++) {
      add(
        CircleComponent(
          position: Vector2(
            starFieldWidth * _random.nextDouble(),
            starFieldHeight * _random.nextDouble(),
          ),
          radius: _random.nextDouble() * 3 + 0.5,
          paint: Paint()
            ..color = Colors.white
            ..color = Colors.white.withAlpha(
                (_random.nextDouble() * 100 + 100).toInt()),
        ),
      );
    }
  }

  void _addCloudLayer({
    required double speed,
    required int count,
    required double minSize,
    required double maxSize,
    required double opacity,
    required double yRange,
  }) {
    final cloudWidth = size.x * 2;
    for (int i = 0; i < count; i++) {
      final cloudSize = minSize + _random.nextDouble() * (maxSize - minSize);
      add(
        Cloud(
          speed: speed,
          size: Vector2(cloudSize * 1.5, cloudSize),
          position: Vector2(
            cloudWidth * _random.nextDouble(),
            size.y * yRange * _random.nextDouble(),
          ),
          gameRef: gameRef,
          opacity: opacity,
        ),
      );
    }
  }
}

class Cloud extends PositionComponent {
  final double speed;
  final JetPackGame gameRef;
  final double opacity;
  late final Paint _paint;

  Cloud({
    required this.speed,
    required this.gameRef,
    required super.size,
    required super.position,
    required this.opacity,
  }) {
    _paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;
  }

  @override
  void render(Canvas canvas) {
    // Draw a fluffy cloud with multiple circles
    final center = size / 2;
    canvas.drawCircle(center.toOffset(), size.y / 2, _paint);
    canvas.drawCircle(
      Offset(center.x - size.y * 0.6, center.y),
      size.y * 0.7,
      _paint,
    );
    canvas.drawCircle(
      Offset(center.x + size.y * 0.6, center.y),
      size.y * 0.7,
      _paint,
    );
  }

  @override
  void update(double dt) {
    position.x -= speed * 50 * dt;

    // Reset cloud when it goes off screen
    if (position.x < -size.x * 2) {
      position.x = gameRef.cameraComponent.viewport.size.x + size.x;
      position.y = gameRef.cameraComponent.viewport.size.y *
          (0.5 + gameRef.random.nextDouble() * 0.3);
    }
  }
}