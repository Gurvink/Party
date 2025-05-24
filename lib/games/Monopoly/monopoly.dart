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
import 'package:party/games/Monopoly/models/hud.dart';
import 'package:party/games/Monopoly/models/space.dart';
import 'package:party/games/Monopoly/models/space_data.dart';
import 'package:party/host/player.dart';
import 'package:party/models/navigationService.dart';
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
    Server.instance.clients.ClearListeners();
    Server.instance.clients.onRemove = (_) {
      var navigation = NavigationService();
      if(Server.instance.clients.length <= 0){
        navigation.goBack();
      }
    };
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
        size: Vector2.all(32),
      ));
      player.setGameLogic(MonopolyLogic(space: spaces.first, pawn: pawn, game: this));
      add(pawn);
      player.changePage('Monopoly');
      players.addFirst(player);
    });
    add(HudComponent(players: players.toList()));
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
        print((e.gameLogic as MonopolyLogic).ready);
        if (!(e.gameLogic as MonopolyLogic).ready) {
          ready = false;
        }
      });
      if(ready){
        sleep(Duration(seconds:3));
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
        }
      case GameState.movingPlayer:
        Space space = (currentPlayer.gameLogic as MonopolyLogic).space;
        final gotoVector = board.tiles[space]!.rectangleComponent.center;
        print(gotoVector);
        (currentPlayer.gameLogic as MonopolyLogic).pawn.moveTo(gotoVector);
        if (diceRoll == 0) {
          state = GameState.resolvingTile;
          return;
        }
        //sleep(Duration(seconds: 1));
        diceRoll--;
        Space s = (currentPlayer.gameLogic as MonopolyLogic).space.next;
        print('on Space ${s.type.name}');
        if (s.type == SpaceType.start) {
          (currentPlayer.gameLogic as MonopolyLogic).money += 200;
          currentPlayer.sendMessage('start', 200);
        }
        (currentPlayer.gameLogic as MonopolyLogic).space = s;
      case GameState.resolvingTile:
        Space s = (currentPlayer.gameLogic as MonopolyLogic).space;
        if (firstTime) {
          print('show space');
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
      case SpaceType.property:
        if(space.owner == null) {
          currentPlayer.sendMessage('showProperty', standardSpaces.indexOf(space));
        } else {
          currentPlayer.sendMessage('showRent', standardSpaces.indexOf(space));
        }
      case SpaceType.chance:
        currentPlayer.sendMessage('showCard', 'chance');
      case SpaceType.community:
        currentPlayer.sendMessage('showCard', 'Community');
      case SpaceType.tax:
        currentPlayer.sendMessage('payTax', space.rent);
      case SpaceType.jail:
        currentPlayer.sendMessage('doNothing', '');
      case SpaceType.police:
        currentPlayer.sendMessage('GoToJail', '');
      case SpaceType.station:
        currentPlayer.sendMessage('showProperty', standardSpaces.indexOf(space));
      case SpaceType.company:
        currentPlayer.sendMessage('showProperty', standardSpaces.indexOf(space));
      case SpaceType.parking:
        currentPlayer.sendMessage('doNothing', '');
      case SpaceType.start:
        currentPlayer.sendMessage('doNothing', '');
      }
  }
}

class MonopolyLogic implements GameLogic{
  int money = 1500;
  Space space;
  bool go = false;
  bool ready = false;
  Pawn pawn;
  Monopoly game;

  MonopolyLogic({required this.space, required this.pawn, required this.game});

  @override
  void handleInput(data) {
    switch(data['type']){
      case 'go':
        go = true;
      case 'buy':
        int price = data['data'];
        money -= price;
        space.owner = currentPlayer;
        game.board.tiles[space]!.addOwner(currentPlayer, space);
        go = true;
      case 'ready':
        print('ready');
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
    add(cube);
  }

  void moveTo(Vector2 target) {
    add(
        MoveEffect.to(
          target,
          EffectController(duration: 1, curve: Curves.easeInOut),
        )
    );
  }
}