import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/camera.dart';
import 'package:flutter/material.dart';
import 'components/player.dart';
import 'components/background.dart';
import 'components/enemies.dart';
import 'components/bullets.dart';

class JetPackGame extends FlameGame with HasCollisionDetection, HasTappables {
  late Player player;
  int score = 0;
  int playerHealth = 100;
  double distance = 0;
  final Random random = Random();
  bool isThrusting = false;

  late final CameraComponent cameraComponent;
  final Vector2 _viewportResolution = Vector2(540, 960);

  @override
  Color backgroundColor() => const Color(0xFF000000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final world = World();
    final viewport = FixedResolutionViewport(resolution: _viewportResolution);
    cameraComponent = CameraComponent(world: world, viewport: viewport);
    addAll([cameraComponent, world]);

    world.add(Background());
    player = Player();
    world.add(player);
    cameraComponent.follow(player);
    world.add(EnemySpawner());

    overlays.add('hud');
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    final tapPosition = info.eventPosition.game;
    if (tapPosition.x > size.x / 2) {
      // Right side - thrust
      isThrusting = true;
    } else {
      // Left side - shoot
      player.shoot();
    }
    super.onTapDown(pointerId, info);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    isThrusting = false;
    super.onTapUp(pointerId, info);
  }

  @override
  void onTapCancel(int pointerId) {
    isThrusting = false;
    super.onTapCancel(pointerId);
  }

  @override
  void update(double dt) {
    super.update(dt);
    distance += dt * 50;
    score = distance.toInt();

    if (isThrusting) {
      player.startThrust();
    } else {
      player.stopThrust();
    }
  }

  void decreaseHealth(int amount) {
    playerHealth -= amount;
    if (playerHealth <= 0) {
      playerHealth = 0;
      overlays.add('gameOver');
    }
  }
}