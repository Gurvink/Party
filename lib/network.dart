import 'dart:io';
import 'package:party/host/player.dart';
import 'package:party/models/observableList.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Server {
  ObservableList<Player> clients = ObservableList();
  late HttpServer server;
  
  void start({int port = 3000}) async {
    server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    
    await for (var request in server) {
      if(WebSocketTransformer.isUpgradeRequest(request)){
        var socket = await WebSocketTransformer.upgrade(request);
        Player player = Player(name: "player${clients.length}", socket: socket);
        print("New player: ${player.name}");
        clients.add(player);
        socket.listen((data) {
          player.processInput(data);
        }).onDone(() {
          print("Connection closed");
          clients.remove(player);
        });
      }
    }
  }



}

class Client {
  void connect() async{
    var socket = await WebSocketChannel.connect(Uri.parse('ws://192.168.16.106:3000'));

    socket.stream.listen((message) {
      print(message.toString());
    });

    socket.sink.add('Hallo!');
  }
}