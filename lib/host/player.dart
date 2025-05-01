import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

const List<Color> colorOptions = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.teal,
];

class Player {
  WebSocket socket;
  bool isHost = false;
  late GameLogic gameLogic;
  late Color color;
  late String name;

  Player({required this.socket});

  void processInput(data){
    switch(data['type']) {
      case 'message':
        print(data['data']);
        break;
      case 'username':
        name = data['data'];
        break;
      case 'color':
        color = colorOptions.elementAt(data['data']);
        break;
      default:
        gameLogic.handleInput(data);
    }
  }
  void setGameLogic(GameLogic logic){
    gameLogic = logic;
  }

  void sendMessage(String type, dynamic data){
    var json = jsonEncode({
      'type': type,
      'data': data,
    });
    socket.add(json);
  }
}


abstract class GameLogic{
  Map<String, dynamic> items = {};
  void handleInput(data);
}