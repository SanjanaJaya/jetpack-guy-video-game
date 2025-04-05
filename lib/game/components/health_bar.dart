import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealthBar extends PositionComponent {
  final double maxHealth;
  double currentHealth;

  HealthBar({required this.maxHealth, required this.currentHealth});

  @override
  void render(Canvas canvas) {
    final bgRect = Rect.fromLTWH(0, 0, width, height);
    final bgPaint = Paint()..color = Colors.grey;
    canvas.drawRect(bgRect, bgPaint);

    final healthWidth = width * (currentHealth / maxHealth);
    final healthRect = Rect.fromLTWH(0, 0, healthWidth, height);
    final healthPaint = Paint()..color = Colors.green;
    canvas.drawRect(healthRect, healthPaint);

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(bgRect, borderPaint);
  }
}