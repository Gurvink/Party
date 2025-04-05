import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:party/host/player.dart';
import 'package:party/network.dart';

class GameLobby extends FlameGame{
  Server server = Server();

  @override
  FutureOr<void> onLoad() {
    var random = Random();
    server.start();
    server.clients.onAdd = () {
      var client = server.clients[server.clients.length-1];
      var player = WaitingPlayer(position: Vector2(random.nextDouble() * size.x, 0), player: client);
      add(player);
    };
    return super.onLoad();
  }

  @override
  Color backgroundColor() {
    return Colors.blue;
  }
}

class WaitingPlayer extends SpriteComponent with HasGameReference<GameLobby>{
  Player player;
  Vector2 velocity = Vector2.zero();
  double gravity = 2.0;

  WaitingPlayer({required position, required this.player}) : super(anchor: Anchor.center, position: position);

  @override
  Future<void> onLoad() async {
    sprite = await generateSprite(Paint()..color = Colors.green);
    return super.onLoad();
  }

  @override
  void update(double dt){
    velocity.y += gravity;
    position += velocity * dt;

    if(position.y >= game.size.y){
      position.y = 0;
      velocity.y = 0;
    }
    super.update(dt);
  }

  Future<Sprite> generateSprite(Paint paint) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, 100, 100),
      paint,
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(100, 100);
    return Sprite(img);
  }
}