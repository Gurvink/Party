import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:party/models/navigationService.dart';
import 'package:party/network.dart';

class CreatePlayerScreen extends StatefulWidget {
  const CreatePlayerScreen({super.key});

  @override
  State<CreatePlayerScreen> createState() => _CreatePlayerScreenState();
}

class _CreatePlayerScreenState extends State<CreatePlayerScreen> {
  final TextEditingController nameController = TextEditingController();
  Color selectedColor = Colors.red;
  final NavigationService navigationService = NavigationService();

  final List<Color> colorOptions = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kies je naam en kleur'), automaticallyImplyLeading: false,),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Naam',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Text('Kies een kleur:'),
            SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: colorOptions.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == color ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vul eerst je naam in')),
                  );
                  return;
                }
                
                Client.instance.sendMessage('username', name);
                Client.instance.sendMessage('color', colorOptions.indexOf(selectedColor));
                Client.instance.sendMessage('cube', 'start');
              },
              child: Text('Bevestig'),
            )
          ],
        ),
      ),
    );
  }
}
