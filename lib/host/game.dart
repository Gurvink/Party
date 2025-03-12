import 'package:flame/game.dart';
import 'package:party/network.dart';

class HostGame extends FlameGame {
  final Server _server = Server();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    if(!_server.isRunning){
      print('Starting server');
      await _server.startServer();
    } else {
      print('Not Starting server');
    }
  }

  @override
  void update(double dt){
    super.update(dt);
  }
}