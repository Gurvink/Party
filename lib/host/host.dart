import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:party/games/Monopoly/monopoly.dart';
import 'package:party/host/lobby.dart';

import '../models/navigationService.dart';

class HostApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    builder: (context, child) {
      return PopScope(
          canPop: false,
          child: child!
      );
    },
    initialRoute: '/',
    navigatorKey: navigatorKey,
    routes: {
      '/': (context) => GameWidget(game: GameLobby()),
      '/Monopoly': (context) => GameWidget(game: Monopoly()),
    },
  );
  }
}