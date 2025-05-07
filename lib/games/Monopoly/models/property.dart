import 'dart:ui';

import 'package:flutter/material.dart';

enum colorType{brown, lightBlue, pink, orange, red, yellow, green, darkBlue, station, company}

class Property{
  final colorType color;
  final int price;
  final List<int> rent;
  final int housePrice;
  final int mortgage;
  final int housesCount = 0;
  final String name;
  final String description;
  bool inMortgage = false;

  Property({required this.price, required this.rent, required this.color, required this.name, required this.description, required this.housePrice, required this.mortgage});
}

Color getColor(colorType type){
  switch(type) {
    case colorType.brown:
      return Colors.brown;
    case colorType.lightBlue:
      return Colors.lightBlueAccent;
    case colorType.pink:
      return Colors.pinkAccent;
    case colorType.orange:
      return Colors.deepOrange;
    case colorType.red:
      return Colors.red;
    case colorType.yellow:
      return Colors.yellow;
    case colorType.green:
      return Colors.green;
    case colorType.darkBlue:
      return Color.fromARGB(255, 0, 34, 195);
    case colorType.station:
      return Colors.black54;
    case colorType.company:
      return Color.fromARGB(255, 62, 62, 62);
  }
}