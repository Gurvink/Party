import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:party/host/player.dart';
import 'package:party/models/navigationService.dart';
import 'package:party/network.dart';

class GameLobby extends FlameGame{
  @override
  Future<void> onLoad() async {
    Server.instance.clients.onAdd = () {
      var client = Server.instance.clients[Server.instance.clients.length-1];
      var cube = Cube();
      add(cube);
      if(client.isHost){
        client.setGameLogic(HostLogic(cube: cube, player: client));
      } else {
        client.setGameLogic(LobbyLogic(cube: cube, player: client));
      }
    };
    Server.instance.clients.onRemove = (item) {
      var cube = item.gameLogic.items['cube']; 
      remove(cube);
    };

    var topText = TextComponent(
      text: 'Ga naar 0.0.0.0:8080 om te spelen.',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(topText);
    final ip = await getLocalIp();
    topText.text = "Ga naar $ip:8080 om te spelen!";
    return super.onLoad();
  }

  @override
  Color backgroundColor() {
    return Colors.blue;
  }
}

class HostLogic implements GameLogic {
  @override
  Map<String, dynamic> items = {};

  HostLogic({required cube, required player}){
    items.addAll({'cube' : cube});
    items.addAll({'player' : player});
  }

  @override
  void handleInput(data) {
    switch(data['type']){
      case 'cube':
        Cube cube = items['cube'];
        Player player = items['player'];
        player.sendMessage('change', 'host');
        cube.setHostCube(player.color, player.name);
        break;
      case 'starGame':
        var navigation = NavigationService();
        switch(data['data']){
          case 'Monopoly':
            navigation.navigateTo('/Monopoly');
            break;
        }
    }
  }

}

class LobbyLogic implements GameLogic{
  @override
  Map<String, dynamic> items = {};

  LobbyLogic({required cube, required player}){
    items.addAll({'cube' : cube});
    items.addAll({'player' : player});
  }

  @override
  void handleInput(data) {
    switch(data['type']) {
      case 'jump':
        Cube cube = items['cube'];
        cube.velocity.y = -cube.gravity * 40;
        break;
      case 'cube':
        Cube cube = items['cube'];
        Player player = items['player'];
        player.sendMessage('change', 'connected');
        cube.setCube(player.color, player.name);
        break;
    }
  }
}

class Cube extends PositionComponent with HasGameReference<GameLobby>{
  Vector2 velocity = Vector2.zero();
  double gravity = 20;

  late RectangleComponent cube;
  late TextComponent nameText;

  Cube() : super(anchor: Anchor.center, position: Vector2.random() * 100, size: Vector2.all(48.0));

  @override
  FutureOr<void> onLoad() {
    cube = RectangleComponent(
      size: Vector2(100, 100),
      paint: Paint()..color = Colors.transparent,
    );
    nameText = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),),);
    nameText.anchor = Anchor.center;
    nameText.position = cube.size / 2;

    add(cube);
    add(nameText);
    return super.onLoad();
  }

  void setHostCube(Color color, String name){
    setCube(color, name);
    position.x = game.size.x / 1.5;
    gravity = 0;
  }

  void setCube(Color color, String name){
    cube.paint = Paint()..color = color;
    nameText.text = name;
  }

  @override
  void update(double dt){
    velocity.y += gravity;
    position += velocity * dt;
    if(position.y >= game.size.y-size.y){
      position.y = game.size.y-size.y;
      velocity.y = 0;
    } else if(position.y < 0){
      position.y = size.y;
      velocity.y = 0;
    }
    super.update(dt);
  }
}