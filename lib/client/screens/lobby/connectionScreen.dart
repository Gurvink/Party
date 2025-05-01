import 'package:flutter/material.dart';
import 'package:party/network.dart';

class ConnectionScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to PartyTime!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Client.instance.connect(),
              child: Text('Verstuur'),
            ),
          ],
        ),
      ),
    );
  }
}