import 'dart:io';

import 'package:flutter/foundation.dart';

class Server {
  HttpServer? _server;
  final List<WebSocket> _clients = [];
  bool isRunning = false;

  Future<void> startServer({int port = 3000}) async {
    if(kIsWeb) return;

    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    print('Server draait op: ${_server?.address.address}:${_server?.port}');
    isRunning = true;
    _server!.listen((HttpRequest request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)){
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        _clients.add(socket);
        socket.listen((data) => _handleMessage(data));
      }
    });
  }
  
  void _handleMessage (String message){
    print(message);
  }
}

class Client {
  WebSocket? _socket;

  Future<void> connect (String host) async {
    try {
      _socket = await WebSocket.connect('ws://$host:3000');
    } catch (e){
      print(e);
    }
  }

  void send(String message) {
    _socket?.add(message);
  }
}

class NetworkScanner{
  Future<List<String>> scanNetwork(String subnet) async {
    List<String> activeServers = [];
    for (int i = 0; i <= 255; i++) {
      String ip = '$subnet.$i';
      try {
        final result = await Process.run('ping', ['-c', '1', ip]);

        if (result.exitCode == 0) {
          activeServers.add(ip);
        }
      } catch (e) {
        print('Fout bij het pingen van $ip: $e');
      }
    }
    return activeServers;
  }
}