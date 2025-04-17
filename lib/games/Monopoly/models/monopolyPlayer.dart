import 'package:flutter/cupertino.dart';
import 'package:party/games/Monopoly/models/space.dart';
import 'package:party/host/player.dart';

class monopolyPlayer extends Player {
  late Space currentSpace;
  int money;
  monopolyPlayer({required super.socket, required this.money});

  factory monopolyPlayer.fromPlayer(Player player, int money, Space startingspace) {
    var monoplayer = monopolyPlayer(socket: player.socket, money: money);
    monoplayer.name = player.name;
    monoplayer.currentSpace = startingspace;
    return monoplayer;
  }
}