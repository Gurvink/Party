import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:party/games/Monopoly/models/property.dart';
import 'package:party/games/Monopoly/models/space.dart';

class MonopolyBoard extends PositionComponent{
  Map<Space, RectangleComponent> tiles = {};
  List<Space> spaces;
  double tileSize;

  MonopolyBoard({required this.spaces, this.tileSize = 80});

  @override
  Future<void> onLoad() async{
    await super.onLoad();

    removeAll(children);

    final Paint borderPaint = BasicPalette.white.paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

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
        position = Vector2((10-i) * tileSize, 10 * tileSize);
      } else if (i <= spaces.length/4*2) { //left
        position = Vector2(0, (20 - i) * tileSize);
      } else if (i <= spaces.length/4*3)  { //top
        position = Vector2((i - 20)  * tileSize, 0);
      } else {
        position = Vector2(10 * tileSize, (i - 30) * tileSize);
      }
      late Color color;
      late Color textColor;
      if(space.property == null){
        if(space.type == spaceType.jail){
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

      final spaceComponent = RectangleComponent(
        position: position,
        size: Vector2.all(tileSize),
        paint: Paint()..color = color
      );

      final text = TextComponent(
        text: space.property == null ? space.type.name : space.property!.name,
        textRenderer: TextPaint(style: TextStyle(fontSize: 10, color: textColor)),
        position: position + Vector2.all(4),
        anchor: Anchor.topLeft,
      );

      tiles.addAll({space:spaceComponent});

      add(spaceComponent);
      add(text);
    }
  }
}