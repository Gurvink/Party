import 'dart:convert';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:party/games/Monopoly/models/chance_data.dart';
import 'package:party/games/Monopoly/models/property.dart';
import 'package:party/games/Monopoly/models/space_data.dart';
import 'package:party/models/observableList.dart';
import 'package:party/network.dart';
import 'dart:async' as async;

class MainMonopolyScreen extends StatefulWidget {
  const MainMonopolyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _mainMonopolyScreen();
}

class _mainMonopolyScreen extends State<MainMonopolyScreen> {
  Player player = Player();
  bool active = false;

  @override
  void initState(){
    super.initState();
    var input = MonopolyInputs();
    input.screen = this;
    Client.instance.setInputProcess(input);
    player.money = 1500;
    player.properties.onAdd = (_) {
      setState(() {});
    };
    player.properties.onRemove = (_) {
      setState(() {});
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Client.instance.sendMessage('ready', '');
    });
  }

  void refresh(){
    setState(() {});
  }

  void showDice(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Throw Dice'),
            content: Text("Het is jouw beurt!\nGooi de dobbelsteen"),
            actions: [
              ElevatedButton(onPressed: () {
                Client.instance.sendMessage('go', '');
                Navigator.pop(context);
              }, child: Text("Gooi"))
            ],
          );
        });
  }

  void showCard(String type) {
    var card = cards.random();
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(type),
            content: Text(card.Text),
            actions: [
              ElevatedButton(onPressed: () {
                card.action();
                Client.instance.sendMessage('go', '');
              }, child: Text('Oke'))
            ],
          );
        }
    );
  }

  void showProperty(Property property, bool owned, bool rent) {
    Color textColor = property.color == colorType.yellow ? Colors.black : Colors
        .white;
    showDialog(
        context: context,
        barrierDismissible: owned,
        builder: (context) {
          return AlertDialog(
            content: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: getColor(property.color),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(property.name, style: TextStyle(
                                color: textColor),),
                            Text(property.description, style: TextStyle(
                                color: textColor),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Huur:'),
                      if(property.color == colorType.station) ...[
                        for(var rent in property.rent) ...[
                          Text('${property.rent.indexOf(rent)} ${property.rent
                              .indexOf(rent) == 1
                              ? 'station'
                              : 'stations'}: €${rent}')
                        ]
                      ] else if(property.color == colorType.company) ...[
                        Text('Huur: 4x het aantal ogen van de worp. \n\n'
                            'Indien beide bedrijven in bezit 10x het aantal ogen.')
                      ] else
                        ...[
                          for(var rent in property.rent) ...[
                            Text('${property.rent.indexOf(rent)} ${property.rent
                                .indexOf(rent) == 1
                                ? 'huis'
                                : 'huizen'}: €${rent}'),
                          ],
                        ],
                      SizedBox(height: 10),
                      Text('Waarde: €${property.price}')
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(owned) ...[
                      if(active && property.color != colorType.station && property.color != colorType.company) ...[
                        ElevatedButton(onPressed: () =>
                            print('in de hypotheek'),
                            child: Text(
                                'In de hypotheek: €${property.mortgage}')),
                        ElevatedButton(onPressed: () => print('Bouw huis'),
                            child: Text(
                                'Bouw een huis: €${property.housePrice}')),
                      ]
                    ] else if(rent) ...[
                      ElevatedButton(onPressed: (){
                        player.money -= property.rent[property.housesCount];
                      }, child: Text("Betaal de huur: €${property.rent[property.housesCount]}")),
                    ] else
                      ...[
                        ElevatedButton(onPressed: () {
                          player.addProperty(property);
                          Navigator.pop(context);
                        }, child: Text('Koop het voor ${property.price}')),
                        ElevatedButton(onPressed: () {
                          Client.instance.sendMessage('go', '');
                          Navigator.pop(context);
                        }, child: Text('Koop het niet'))
                      ]
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Money: ${player.money}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Properties:',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: ListView.builder(
                        itemCount: player.properties.length,
                        itemBuilder: (context, index) {
                          var space = player.properties[index];
                          return ListTile(
                            title: Text(space.name),
                            subtitle: Text(space.description),
                            onTap: () => showProperty(space, true, false),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if(active) {
                    active = false;
                    Client.instance.sendMessage('go', '');
                  }
                },
                child: Text("End Turn"),
              )
          ],
        ),
      ),
    );
  }
}

class Player{
  int money = 0;
  ObservableList<Property> properties = ObservableList();

  void addProperty(Property property){
    if(money < property.price){
      return;
    } else {
      money -= property.price;
      properties.add(property);
      Client.instance.sendMessage('buy', property.price );
    }
  }

  void buildHouse(Property property){
    var set = standardSpaces.where((e) => e.property?.color == property.color);
    set.forEach((e) {

    });
  }
}

class MonopolyInputs implements InputProcess {
  late _mainMonopolyScreen screen;
  @override
  void processInput(data) {
    switch(data['type']){
      case 'showProperty':
        var property = standardSpaces.elementAt(data['data']).property;
        screen.showProperty(property!, false, false);
      case 'showRent':
        var property = standardSpaces.elementAt(data['data']).property;
        screen.showProperty(property!, false, true);
      case 'showCard':
        screen.showCard(data['data']);
      case 'showDice':
        screen.showDice();
      case 'endTurn':
        screen.active = true;
        screen.refresh();
    }
  }
}

