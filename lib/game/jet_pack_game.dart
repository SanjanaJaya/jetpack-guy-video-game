import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/camera.dart';
import 'package:flutter/material.dart';
import 'package:jetpack_guy_video_game/game/components/player.dart';
import 'package:jetpack_guy_video_game/game/components/background.dart';
import 'package:jetpack_guy_video_game/game/components/enemies.dart';

class JetPackGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  late Player player;
  int score = 0;
  double distance = 0;
  final Random random = Random();
  bool isThrusting = false;

  late final CameraComponent cameraComponent;

  @override
  Color backgroundColor() => const Color(0xFF000000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final world = World();
    cameraComponent = CameraComponent(
      world: world,
      viewport: FixedResolutionViewport(resolution: Vector2(1600, 900)),
    );

    addAll([cameraComponent, world]);

    // Background should be added first to be at the bottom layer
    final background = Background();
    world.add(background);

    cameraComponent.viewfinder.anchor = Anchor.center;

    player = Player();
    world.add(player);
    cameraComponent.follow(player);

    world.add(EnemySpawner());
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

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (event.localPosition.x > size.x / 2) {
      isThrusting = true;
    } else {
      player.shoot();
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (event.localPosition.x > size.x / 2) {
      isThrusting = false;
    }
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);
    isThrusting = false;
  }
}