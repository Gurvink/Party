import 'dart:async';
import 'package:flame/game.dart';
import 'package:party/games/Monopoly/models/board.dart';
import 'package:party/games/Monopoly/models/monopolyPlayer.dart';
import 'package:party/games/Monopoly/models/space.dart';
import 'package:party/games/Monopoly/models/space_data.dart';
import 'package:party/network.dart';

class monopoly extends FlameGame{
  List<monopolyPlayer> players = [];
  List<Space> spaces = List<Space>.from(standardSpaces);
  late MonopolyBoard board = MonopolyBoard(spaces: spaces);

  @override
  FutureOr<void> onLoad() {
    Server.instance.clients.forEach((e) {
      players.add(monopolyPlayer.fromPlayer(e, 500, spaces.first));
    });
    add(board);
    
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 canvasSize){
    super.onGameResize(canvasSize);

    final double tileCount = spaces.length/4;
    final double padding = 50;

    final double tileSize = ((canvasSize.x < canvasSize.y ? canvasSize.x : canvasSize.y) - padding * 2) / tileCount;

    board.tileSize = tileSize;

    board.position = Vector2(
        0,
        0,
    );
    board.size = Vector2(tileSize * tileCount, tileSize * tileCount);
    board.onLoad();
  }
}