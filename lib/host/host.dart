import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:party/host/game.dart';

class HostApp extends StatefulWidget{
  @override
  _HostAppState createState() => _HostAppState();
}

class _HostAppState extends State<HostApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Party Host',
      home: GameWidget<HostGame>.controlled(
        gameFactory: HostGame.new,
      ),
    );
  }
}