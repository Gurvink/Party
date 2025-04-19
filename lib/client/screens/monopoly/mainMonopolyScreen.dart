import 'package:flutter/material.dart';
import 'package:party/games/Monopoly/models/property.dart';
import 'package:party/games/Monopoly/models/space.dart';

class MainMonopolyScreen extends StatefulWidget {
  const MainMonopolyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _mainMonopolyScreen();
}

class _mainMonopolyScreen extends State<MainMonopolyScreen>{
  int money = 0;
  List<Space> properties = [Space(type: spaceType.property, property: Property(price: 100, rent: [1,22,3,4,5], color: colorType.brown, name: 'test', description: 'Test ding', housePrice: 50, mortgage: 50))];

  void toonDetails(Space space){

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
                        'In bezit:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            return Text('• ${properties[index]}');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),
            Text('de rest'),
          ],
        ),
      ),
    );
  }

}