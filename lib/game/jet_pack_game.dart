import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:jetpack_guy_video_game/game/components/player.dart';
import 'package:jetpack_guy_video_game/game/components/background.dart';
import 'package:jetpack_guy_video_game/game/components/enemies.dart';

class JetPackGame extends FlameGame with HasCollisionDetection, TapDetector {
  late Player player;
  int score = 0;
  double distance = 0;
  final Random random = Random();
  bool isTouching = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add background first
    add(Background());

    // Setup camera
    camera.viewfinder.anchor = Anchor.center;

    // Add player
    player = Player();
    add(player);
    camera.follow(player);

    // Add enemy spawner
    add(EnemySpawner());
  }

  @override
  void update(double dt) {
    super.update(dt);
    distance += dt * 50;
    score = distance.toInt();

    if (isTouching) {
      player.startThrust();
    } else {
      player.stopThrust();
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    isTouching = true;
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    isTouching = false;
  }

  @override
  void onTapCancel(int pointerId) {
    isTouching = false;
  }

  @override
  void onTap() {
    player.shoot();
  }
}