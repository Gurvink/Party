import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:party/games/Monopoly/monopoly.dart';
import 'package:party/host/player.dart';

class HudComponent extends PositionComponent with HasGameRef<Monopoly> {
  final List<Player> players;

  HudComponent({required this.players});

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    position = Vector2(game.board.size.x + game.board.tileSize, 0);
    size = Vector2(game.size.x - game.board.size.x - game.board.tileSize, game.size.y);

    final background = RectangleComponent(
      size: size,
      paint:  Paint()..color = Color.fromRGBO(0, 0, 0, 100),
    );

    add(background);

    double yOffset = 20;

    for(final player in players){
      final logic = (player.gameLogic as MonopolyLogic);
      final text = TextComponent(
        text: '${player.name}: €${logic.money}',
        position: Vector2(10, yOffset),
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.white, fontSize: 14),
        )
      );

      add(text);
      yOffset += 30;
    }
  }
}