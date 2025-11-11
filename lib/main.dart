import 'package:atividade_pratica/game/flamy_breakout_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  // O Widget principal que executa o jogo Flame
  runApp(
    GameWidget(
      game: FlamyBreakoutGame(),
    ),
  );
}