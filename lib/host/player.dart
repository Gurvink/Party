import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';

class Player {
  String name;
  WebSocket socket;

  Player({required this.name, required this.socket});

  void processInput(data){
    print(data);
  }
}