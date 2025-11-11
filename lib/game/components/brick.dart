import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Brick extends RectangleComponent with CollisionCallbacks {
  
  Brick({
    required Vector2 position,
    required Vector2 size,
    required Color color,
  }) : super(
          position: position,
          size: size,
          paint: Paint()..color = color,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Adiciona a hitbox para detecção de colisão com a bola
    add(RectangleHitbox());
  }
}