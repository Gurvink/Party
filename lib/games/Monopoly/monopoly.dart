import 'dart:async';
import 'dart:collection';
import 'package:flame/game.dart';
import 'package:party/games/Monopoly/models/board.dart';
import 'package:party/games/Monopoly/models/space.dart';
import 'package:party/games/Monopoly/models/space_data.dart';
import 'package:party/host/player.dart';
import 'package:party/network.dart';

class Monopoly extends FlameGame{
  List<Space> spaces = List<Space>.from(standardSpaces);
  late MonopolyBoard board = MonopolyBoard(spaces: spaces);
  Queue<Player> players = Queue();

  @override
  FutureOr<void> onLoad() {
    Server.instance.clients.forEach((player) {
      player.setGameLogic(MonopolyLogic(startSpace: spaces.first));
      players.add(player);
    });
    for(int i=0; i<spaces.length; i++){
      var currentSpace = spaces[i];
      if(i==0){
        currentSpace.previous = spaces[spaces.length-1];
      } else {
        currentSpace.previous = spaces[i-1];
      }
      if(i==spaces.length-1){
        currentSpace.next = spaces.first;
      } else {
        currentSpace.next = spaces[i+1];
      }
    }
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

  void gameFlow(Player currentPlayer){

  }
}

class MonopolyLogic implements GameLogic{
  @override
  Map<String, dynamic> items = {};

  MonopolyLogic({required startSpace}){
    items.addAll({'money' : 1500});
    items.addAll({'Space' : startSpace});
  }

  @override
  void handleInput(data) {
    switch(data['type']){
      case '':
    }
  }
}