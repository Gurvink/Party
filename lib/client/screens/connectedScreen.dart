import 'package:flutter/material.dart';
import 'package:party/network.dart';

class ConnectedScreen extends StatelessWidget {
  const ConnectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Connected!\nWaiting for game", textAlign: TextAlign.center,),
            Padding(padding: EdgeInsets.all(16.0)),
            ElevatedButton(
                onPressed: () => Client.instance.sendMessage('jump', 'jump'),
                child: Text("Jump!")
            )
          ],
        ),
      ),
    );
  }
}