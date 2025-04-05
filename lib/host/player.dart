import 'dart:convert';
import 'dart:io';
import 'package:party/network.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Player {
  String name;
  WebSocket socket;

  Player({required this.name, required this.socket});

  void processInput(data){
    var message = jsonDecode(data);
    switch(message['type']) {
      case DataType.Message:
        print(message['data']);
        break;
      case DataType.Username:
        name = message['data'];
        break;
      default:
        print('Type: ${message['type']}, Message: ${message[data]}');
        break;
    }
  }
}