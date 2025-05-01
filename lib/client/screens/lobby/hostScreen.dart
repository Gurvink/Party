import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party/host/player.dart';
import 'package:party/models/observableList.dart';
import 'package:party/network.dart';

class HostScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  List<String> games = ['Monopoly'];
  String selectedGame = 'Monopoly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("You're the Host!"), automaticallyImplyLeading: false,),
      body: Column(
        children: [
          Wrap(
            spacing: 12,
            children: games.map((game) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGame = game;
                  });
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: selectedGame == game ? Colors.green : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: Text(game, textAlign: TextAlign.center,),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
              onPressed: () {
                Client.instance.sendMessage('startGame', selectedGame);
              },
              child: Text('Start game!'))
        ],
      ),
    );
  }
}