import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:party/host/player.dart';
import 'package:party/models/navigationService.dart';
import 'package:party/models/observableList.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart' as shelf;

class Server {
  ObservableList<Player> clients = ObservableList();
  late HttpServer server;
  late Player host;
  late HttpServer webServer;

  Server._constructor();

  static final Server instance = Server._constructor();
  
  void start({int port = 3000}) async {
    startWebServer();
    server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    
    await for (var request in server) {
      if(WebSocketTransformer.isUpgradeRequest(request)) {
        var socket = await WebSocketTransformer.upgrade(request);
        Player player = Player(socket: socket);
        if(clients.length == 0){
          player.isHost = true;
          host = player;
        }
        clients.add(player);
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

  Future<void> startWebServer() async {
    final router = shelf.Router();
    
    router.get('/<path|.*>', (Request request, String path) async {
      if (path.isEmpty) {
        path = 'index.html';
      }

      final assetPath = 'assets/web/$path';
      try {
        final byteData = await rootBundle.load(assetPath);
        final Uint8List content = byteData.buffer.asUint8List();

        final mimeType = _getMimeType(path);

        return Response.ok(content, headers: {
          HttpHeaders.contentTypeHeader: mimeType,
        });
      } catch (e) {
        return Response.notFound('Bestand niet gevonden: $path');
      }
    });

      webServer = await io.serve(
        router,
        InternetAddress.anyIPv4,
        8080,
      );
  }

  String _getMimeType(String path) {
    if (path.endsWith('.html')) return 'text/html';
    if (path.endsWith('.js')) return 'application/javascript';
    if (path.endsWith('.css')) return 'text/css';
    if (path.endsWith('.png')) return 'image/png';
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'image/jpeg';
    if (path.endsWith('.svg')) return 'image/svg+xml';
    if (path.endsWith('.json')) return 'application/json';
    return 'application/octet-stream';
  }
}

class Client {
  Client._constructor();
  static final Client instance = Client._constructor();
  final NavigationService _navigationService = NavigationService();
  late final socket;
  late InputProcess inputProcess;

  void connect() async {
    var ipaddress = await getLocalIp();
    socket = WebSocketChannel.connect(Uri.parse('ws://$ipaddress:3000'));

    socket.stream.listen((message) {
      var json = jsonDecode(message);
      switch(json['type']) {
        case('change'):
          _navigationService.navigateTo('/${json['data']}');
          break;
        default:
          inputProcess.processInput(json);
      }
    });
  }

  void setInputProcess(InputProcess process){
    inputProcess = process;
  }

  void sendMessage(String type, dynamic data){
    var json = jsonEncode({
      'type': type,
      'data': data,
    });
    socket.sink.add(json);
  }
}

abstract class InputProcess{
  void processInput(data);
}

Future<String> getLocalIp() async {
  final interfaces = await NetworkInterface.list(
    type: InternetAddressType.IPv4,
    includeLoopback: false,
  );

  for (var interface in interfaces){
    for (var addr in interface.addresses){
      if(!addr.isLoopback){
        return addr.address;
      }
    }
  }
  return 'Ip niet gevonden';
}