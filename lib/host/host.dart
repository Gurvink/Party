import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:party/host/lobby.dart';

class HostApp extends StatefulWidget{
  const HostApp({super.key});

  @override
  HostAppState createState() => HostAppState();
}

class HostAppState extends State<HostApp> {
  late FlameGame game;

  @override
  void initState() {
    super.initState();
    game = GameLobby();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
          game: game,
      ),
    );
  }
}