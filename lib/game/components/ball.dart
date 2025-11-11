import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../flamy_breakout_game.dart';
import 'brick.dart';
import 'paddle.dart';

class Ball extends CircleComponent 
    with HasGameRef<FlamyBreakoutGame>, CollisionCallbacks {

  Vector2 velocity;
  
  Ball({
    required Vector2 position,
    required this.velocity,
  }) : super(
          radius: 6,
          position: position,
          paint: Paint()..color = Colors.yellowAccent,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Limita dt para evitar "tunneling" quando o frame delta é muito grande
    final double maxDt = 0.04; // ~25 FPS chunk
    final double stepDt = dt.clamp(0, maxDt);

    // Lógica de movimento da bola
    position += velocity * stepDt;

    // Fallback: se a bola atravessou as paredes por causa de velocidade/frames,
    // corrige posição e reflete a componente relevante da velocidade.
    final double leftBound = 0 + radius;
    final double rightBound = gameRef.size.x - radius;
    final double topBound = 0 + radius;

    // esquerda
    if (position.x < leftBound) {
      position.x = leftBound;
      velocity.x = -velocity.x;
    }

    // direita
    if (position.x > rightBound) {
      position.x = rightBound;
      velocity.x = -velocity.x;
    }

    // topo
    if (position.y < topBound) {
      position.y = topBound;
      velocity.y = -velocity.y;
    }
  }
  
  // =======================================================
  // ATIVIDADES PRÁTICA 3: IMPLEMENTAR COLISÕES AQUI
  // =======================================================

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // Segurança: precisa de ao menos um ponto de interseção
    if (intersectionPoints.isEmpty) return;

    // Calcular ponto médio de interseção (mais robusto que usar somente o first)
    final Vector2 avgPoint = intersectionPoints.fold(Vector2.zero(), (acc, p) => acc..add(p)) / intersectionPoints.length.toDouble();

    Vector2 collisionNormal = (absoluteCenter - avgPoint);

    // ⬇️ COMEÇAR AQUI ⬇️
      // Use velocity.reflect(collisionNormal) para rebater a bola
      // velocity = velocity.reflect(collisionNormal);

    if (other is RectangleComponent) {}

    else if (other is Paddle) {}

    else if (other is Brick) {}
  }
}