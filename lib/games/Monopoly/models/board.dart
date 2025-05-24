import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:party/games/Monopoly/models/property.dart';
import 'package:party/games/Monopoly/models/space.dart';
import 'package:party/host/player.dart';

class MonopolyBoard extends PositionComponent{
  Map<Space, Tile> tiles = {};
  List<Space> spaces;
  double tileSize;

  MonopolyBoard({required this.spaces, this.tileSize = 80});

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    removeAll(children);

    final middleArea = RectangleComponent(
      position: Vector2(tileSize+1, tileSize+1),
      size: Vector2(tileSize*9-2, tileSize*9-2),
      paint: Paint()..color = Colors.white,
    );
    add(middleArea);

    for (int i = 0; i < spaces.length; i++){
      final space = spaces[i];
      Vector2 position;
      if (i <= spaces.length/4) { //bottom
        space.side = Side.bottom;
        position = Vector2((10-i) * tileSize, 10 * tileSize);
      } else if (i <= spaces.length/4*2) { //left
        space.side = Side.left;
        position = Vector2(0, (20 - i) * tileSize);
      } else if (i <= spaces.length/4*3)  { //top
        space.side = Side.top;
        position = Vector2((i - 20)  * tileSize, 0);
      } else { //right
        space.side = Side.right;
        position = Vector2(10 * tileSize, (i - 30) * tileSize);
      }
      late Color color;
      late Color textColor;
      if(space.property == null){
        if(space.type == SpaceType.jail){
          color = Colors.deepOrangeAccent;
          textColor = Colors.white;
        } else {
          color = Colors.white;
          textColor = Colors.black;
        }
      } else {
        color = getColor(space.property!.color);
        textColor = Colors.white;
      }

      var paint = Paint()..color = color;

      final spaceComponent = RectangleComponent(
        position: position,
        size: Vector2.all(tileSize),
        paint: paint
      );

      final text = TextComponent(
        text: space.property == null ? space.type.name : space.property!.name,
        textRenderer: TextPaint(style: TextStyle(fontSize: 10, color: textColor)),
        position: position + Vector2.all(4),
        anchor: Anchor.topLeft,
      );

      var tile = Tile(rectangleComponent: spaceComponent, textComponent: text);
      add(tile);

      tiles.addAll({space:tile});
    }
  }
}

class Tile extends PositionComponent{
  final RectangleComponent rectangleComponent;
  final TextComponent textComponent;
  late RectangleComponent ownerBox;

  Tile({required this.rectangleComponent, required this.textComponent});

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(rectangleComponent);
    add(textComponent);
  }

  void addOwner(Player player, Space space){
    var cubePosition = Vector2.zero();
    var side = false;
    switch(space.side) {
      case Side.top:
        cubePosition = position += Vector2(0, size.y);
      case Side.right:
        side = true;
        cubePosition = position += Vector2(-size.x, 0);
      case Side.left:
        side = true;
        cubePosition = position += Vector2(size.x, 0);
      case Side.bottom:
        cubePosition = position += Vector2(0, -size.y/2);
    }
    _createCube(cubePosition, player.color, side);
  }

  void _createCube(Vector2 position, Color color, bool side) {
    final paint = Paint()
      ..color = color;
    var cubeSize = size;
    if (side) {
      cubeSize.x = cubeSize.x / 2;
    } else {
      cubeSize.y = cubeSize.y / 2;
    }
    ownerBox = RectangleComponent(
        position: position,
        size: cubeSize,
        paint: paint,
        priority: 1
    );
    add(ownerBox);
  }
}