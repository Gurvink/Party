import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:party/games/Monopoly/models/board.dart';
import 'package:party/games/Monopoly/models/space.dart';
import 'package:party/games/Monopoly/models/space_data.dart';
import 'package:party/host/player.dart';
import 'package:party/network.dart';

enum GameState {waitingForRoll, movingPlayer, resolvingTile, endTurn}

late Player currentPlayer;

class Monopoly extends FlameGame{
  List<Space> spaces = List<Space>.from(standardSpaces);
  late MonopolyBoard board = MonopolyBoard(spaces: spaces);
  Queue<Player> players = Queue();
  final Random _random = Random();
  GameState state = GameState.waitingForRoll;
  int diceRoll = 0;
  bool allReady = false;
  bool firstTime = true;

  @override
  FutureOr<void> onLoad() {
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

    Server.instance.clients.forEach((player) {
      var pawn = Pawn(cube: RectangleComponent(
        paint: Paint()..color = player.color,
        anchor: Anchor.center,
      ));
      player.setGameLogic(MonopolyLogic(space: spaces.first, pawn: pawn));
      add(pawn);
      player.changePage('Monopoly');
      players.addFirst(player);
    });
    currentPlayer = players.removeFirst();

    super.onLoad();
  }

  @override
  void onGameResize(Vector2 size){
    super.onGameResize(size);

    final double tileCount = spaces.length/4;
    final double padding = 50;

    final double tileSize = ((size.x < size.y ? size.x : size.y) - padding * 2) / tileCount;

    board.tileSize = tileSize;

    board.position = Vector2(
        0,
        0,
    );
    board.size = Vector2(tileSize * tileCount, tileSize * tileCount);
    board.onLoad();
  }

  @override
  void update(double dt){
    super.update(dt);

    if(!allReady) {
      bool ready = true;
      players.forEach((e) {
        if (!(e.gameLogic as MonopolyLogic).ready) {
          ready = false;
        }
      });
      if(ready){
        allReady = true;
      } else {
        return;
      }
    }

    switch(state) {
      case GameState.waitingForRoll:
        if (firstTime) {
          print('${currentPlayer.name} is aan de beurt. ');
          currentPlayer.sendMessage('showDice', 'diceRoll');
          firstTime = false;
          (currentPlayer.gameLogic as MonopolyLogic).go = false;
        }
        if ((currentPlayer.gameLogic as MonopolyLogic).go) {
          diceRoll = _rollDice();
          print(diceRoll);
          state = GameState.movingPlayer;
          firstTime = true;
          currentPlayer.sendMessage('removeScreen', '');
        }
      case GameState.movingPlayer:
        if (diceRoll == 0) {
          state = GameState.resolvingTile;
          return;
        }
        diceRoll--;
        Space s = (currentPlayer.gameLogic as MonopolyLogic).space.next!;
        print('on Space ${s.type.name}');
        if (s.type == spaceType.start) {
          (currentPlayer.gameLogic as MonopolyLogic).money += 200;
        }
        (currentPlayer.gameLogic as MonopolyLogic).space = s;
        (currentPlayer.gameLogic as MonopolyLogic).pawn.moveTo(board.tiles[s]!.position);
        sleep(Duration(seconds: 1));
      case GameState.resolvingTile:
        Space s = (currentPlayer.gameLogic as MonopolyLogic).space;
        if (firstTime) {
          showSpaceDetails(s);
          (currentPlayer.gameLogic as MonopolyLogic).go = false;
          firstTime = false;
        }
        if ((currentPlayer.gameLogic as MonopolyLogic).go) {
          state = GameState.endTurn;
          firstTime = true;
        }
      case GameState.endTurn:
        if(firstTime){
          currentPlayer.sendMessage('endTurn', '');
          (currentPlayer.gameLogic as MonopolyLogic).go = false;
          firstTime = false;
        }
        if ((currentPlayer.gameLogic as MonopolyLogic).go) {
          print('${currentPlayer.name} is klaar ');
          players.addLast(currentPlayer);
          currentPlayer = players.removeFirst();
          state = GameState.waitingForRoll;
          firstTime = true;
        }
    }
  }

  int _rollDice() {
    int die1 = _random.nextInt(6) + 1;
    int die2 = _random.nextInt(6) + 1;
    return die1 + die2;
  }

  void showSpaceDetails(Space space){
    switch(space.type) {
      case spaceType.property:
        if(space.owner == null) {
          currentPlayer.sendMessage('showProperty', standardSpaces.indexOf(space));
        } else {
          currentPlayer.sendMessage('showRent', standardSpaces.indexOf(space));
        }
      case spaceType.chance:
        currentPlayer.sendMessage('showCard', 'chance');
      case spaceType.community:
        currentPlayer.sendMessage('showCard', 'Community');
      case spaceType.tax:
        currentPlayer.sendMessage('payTax', space.rent);
      case spaceType.jail:
      case spaceType.police:
        currentPlayer.sendMessage('GoToJail', '');
      case spaceType.station:
        currentPlayer.sendMessage('showProperty', standardSpaces.indexOf(space));
      case spaceType.company:
        currentPlayer.sendMessage('showProperty', standardSpaces.indexOf(space));
      case spaceType.parking:
      case spaceType.start:
      }
  }
}

class MonopolyLogic implements GameLogic{
  int money = 1500;
  Space space;
  bool go = false;
  bool ready = false;
  Pawn pawn;

  MonopolyLogic({required this.space, required this.pawn});

  @override
  void handleInput(data) {
    switch(data['type']){
      case 'go':
        go = true;
      case 'buy':
        int price = data['data'];
        money -= price;
        space.owner = currentPlayer;
      case 'ready':
        ready = true;
    }
  }
}

class Pawn extends PositionComponent {
  late RectangleComponent cube;

  Pawn({required this.cube});

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    size = Vector2.all(16);
    anchor = Anchor.center;
    position = Vector2(32,32);
  }

  void moveTo(Vector2 target) {
    add(
        MoveEffect.to(
          target,
          EffectController(duration: 0.5, curve: Curves.easeInOut),
        )
    );
  }
}