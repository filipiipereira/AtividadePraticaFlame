import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../flamy_breakout_game.dart';

class Paddle extends RectangleComponent with HasGameRef<FlamyBreakoutGame> {
  
  final double speed = 400; // Velocidade de movimento
  
  Paddle()
      : super(
          size: Vector2(80, 10),
          paint: Paint()..color = Colors.white,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Adiciona a hitbox para a bola colidir
    add(RectangleHitbox());
  }
  
  // O método DEVE receber dt para movimento suave
  void move(double direction, double dt) {
    final double speed = 400; // Velocidade em pixels por segundo
    if (direction == 0) return;
    
    // Calcula o deslocamento suave
    final distanceToMove = speed * dt * direction; 
    
    final newX = x + distanceToMove; 
    
    // Garante que o paddle não saia da tela
    final minX = size.x / 2;
    final maxX = FlamyBreakoutGame.gameAreaWidth - size.x / 2; 
    
    x = newX.clamp(minX, maxX);
  }
}