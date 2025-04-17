import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:party/host/player.dart';
import 'package:party/models/navigationService.dart';
import 'package:party/models/observableList.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Server {
  ObservableList<Player> clients = ObservableList();
  late HttpServer server;

  Server._constructor();

  static final Server instance = Server._constructor();
  
  void start({int port = 3000}) async {
    server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    
    await for (var request in server) {
      if(WebSocketTransformer.isUpgradeRequest(request)) {
        var socket = await WebSocketTransformer.upgrade(request);
        Player player = Player(socket: socket);
        clients.add(player);
        if(clients.length == 1){
          player.isHost = true;
        }
        socket.add(jsonEncode({
          'type' : 'change',
          'data' : 'createPlayer'
        }));
        socket.listen((data) {
          player.processInput(jsonDecode(data));
        }).onDone(() {
          clients.remove(player);
        });
      }
    }
  }



}

class Client {
  Client._constructor();
  static final Client instance = Client._constructor();
  final NavigationService _navigationService = NavigationService();
  late final socket;

  void connect() async {
    socket = await WebSocketChannel.connect(Uri.parse('ws://192.168.16.98:3000'));

    socket.stream.listen((message) {
      var json = jsonDecode(message);
      switch(json['type']){
        case('change'):
          _navigationService.navigateTo('/${json['data']}');
          break;
      }
    });
  }

  void sendMessage(String type, dynamic data){
    var json = jsonEncode({
      'type': type,
      'data': data,
    });
    socket.sink.add(json);
  }
}