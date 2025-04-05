import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextComponent with HasGameRef {
  ScoreText() : super(
    text: 'Score: 0',
    position: Vector2(10, 10),
    textRenderer: TextPaint(
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}

class HealthText extends TextComponent with HasGameRef {
  HealthText() : super(
    text: 'Health: 100%',
    position: Vector2(10, 40),
    textRenderer: TextPaint(
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}