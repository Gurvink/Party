import 'package:flutter/material.dart';
import 'package:party/games/Monopoly/models/property.dart';
import 'package:party/games/Monopoly/models/space.dart';
import 'package:party/network.dart';

class MainMonopolyScreen extends StatefulWidget {
  const MainMonopolyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _mainMonopolyScreen();
}

class _mainMonopolyScreen extends State<MainMonopolyScreen> {
  int money = 0;
  List<Property> properties = [];

  void addProperty(Property property){
    setState(() {
      properties.add(property);
    });
  }

  void toonDetails(Property property) {
    Color textColor = property.color == colorType.yellow ? Colors.black : Colors
        .white;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
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
                    for(var rent in property.rent) ...[
                      Text('${property.rent.indexOf(rent)} ${property.rent.indexOf(rent) == 1 ? 'huis' : 'huizen'}: €${rent}'),
                    ],
                    SizedBox(height: 10),
                    Text('Waarde: ${property.price}')
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () => print('in de hypotheek'),
                      child: Text(
                          'In de hypotheek: €${property.mortgage}')),
                  ElevatedButton(onPressed: () => print('Bouw huis'),
                      child: Text(
                          'Bouw een huis: €${property.housePrice}')),
                ],
              ),
            ],
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
              'Money: $money',
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
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          var space = properties[index];
                          return ListTile(
                            title: Text(space.name),
                            subtitle: Text(space.description),
                            onTap: () => toonDetails(space),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Text('de rest'),
          ],
        ),
      ),
    );
  }
}

class MonopolyInputs implements InputProcess {
  @override
  void processInput(data) {
    switch(data['type']){
      case 'property':
        _mainMonopolyScreen().addProperty(data['data']);
    }
  }
}

