import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/ball.dart';
import 'components/paddle.dart';
import 'components/brick.dart';

class FlamyBreakoutGame extends FlameGame 
    with HasCollisionDetection, KeyboardEvents { // Usa KeyboardEvents

  int score = 0;
  int lives = 3;
  late TextComponent scoreText;
  late TextComponent livesText;
  bool _initialized = false;
  
  // Variável para rastrear a direção de movimento do Paddle (-1, 0, 1)
  double _moveDirection = 0; 
  
  // Constante para definir o tamanho da zona de jogo (Viewport)
  static const gameAreaWidth = 600.0;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Deferir a configuração que depende do tamanho real do jogo para onGameResize.
    // onGameResize será chamado assim que o tamanho real estiver disponível; lá
    // configuramos viewport, adicionamos paddle/bola/paredes/tirojos/HUD.
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    if (_initialized) return;

    // Agora que temos o tamanho real, configuramos o viewport com a altura correta
    camera.viewport = FixedResolutionViewport(resolution: Vector2(gameAreaWidth, newSize.y));

    // 1. ADICIONA A BOLA E O PADDLE
    add(Paddle());

    // Posiciona o paddle corretamente no centro inferior (usa size que agora
    // corresponde à resolução do viewport: x == gameAreaWidth)
    final paddle = children.whereType<Paddle>().firstOrNull;
    paddle?.position = Vector2(size.x / 2, size.y - 40);

    resetBall();

    // 2. CONSTRÓI AS PAREDES INVISÍVEIS (Exceto a inferior, que causa "Game Over")
    final borderThickness = 10.0;

    add(RectangleComponent(
      position: Vector2(0, 0), 
      size: Vector2(size.x, borderThickness),
      children: [RectangleHitbox()],
      paint: Paint()..color = Colors.red,
    ));

    // Parede Esquerda
    add(RectangleComponent(
      position: Vector2(0, 0), 
      size: Vector2(borderThickness, size.y),
      children: [RectangleHitbox()],
      paint: Paint()..color = Colors.red,
    ));

    // Parede Direita
    add(RectangleComponent(
      position: Vector2(size.x - borderThickness, 0), 
      size: Vector2(borderThickness, size.y),
      children: [RectangleHitbox()],
      paint: Paint()..color = Colors.red,
    ));

    // 3. CRIA OS TIJOLOS
    createBricks();

    // 4. CRIA O HUD (Heads-Up Display)
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(10, 10),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 24)),
    );
    livesText = TextComponent(
      text: 'Lives: 3',
      position: Vector2(size.x - 100, 10),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 24)),
    );
    add(scoreText);
    add(livesText);

    _initialized = true;
  }
  
  // MÉTODOS DE INPUT DO TECLADO
  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    _moveDirection = 0; // Zera a direção a cada evento
    
    // Verifica se a seta para a Esquerda está pressionada
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _moveDirection = -0.5;
    } 
    // Verifica se a seta para a Direita está pressionada
    else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _moveDirection = 0.5;
    }
    
    return KeyEventResult.handled; // Indica que o evento foi tratado
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Move o Paddle continuamente com base na direção
    final paddle = children.whereType<Paddle>().firstOrNull;
    // ⬇️ CORREÇÃO: Passar o delta time (dt) para um movimento suave ⬇️
    paddle?.move(_moveDirection, dt); // Assumindo que move agora recebe dt
    
    // ATIVIDADE PRÁTICA 1: Lógica de Perda de Vida
    // Se a bola sair da tela por baixo
    final ball = children.whereType<Ball>().firstOrNull;
    if (ball != null && ball.position.y > size.y) {
      // ⬇️ COMEÇAR AQUI ⬇️

    }
  }

  void increaseScore(int value) {
    score += value;
    scoreText.text = 'Score: $score';
  }
  
  void decreaseLife() {
    lives -= 1;
    livesText.text = 'Lives: $lives';
    
    if (lives <= 0) {
      // ATIVIDADE PRÁTICA 3: Implementar lógica de Game Over
    }
  }

  void resetBall() {
    children.whereType<Ball>().forEach((ball) => ball.removeFromParent());
    add(Ball(
      position: Vector2(size.x / 2, size.y * 0.7),
      velocity: Vector2(150, -200),
    ));
  }

  void createBricks() {
    final brickWidth = 60.0;
    final brickHeight = 20.0;
    final spacing = 4.0;
    final rows = 5;
    final cols = 8;
    
    final startX = (gameAreaWidth - (cols * (brickWidth + spacing))) / 2;
    final startY = 50.0;

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final position = Vector2(
          startX + c * (brickWidth + spacing),
          startY + r * (brickHeight + spacing),
        );
        final color = r.isEven ? Colors.blue : Colors.red;
        
        add(Brick(
          position: position,
          size: Vector2(brickWidth, brickHeight),
          color: color,
        ));
      }
    }
  }
}