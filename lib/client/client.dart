import 'package:flutter/material.dart';
import 'package:party/network.dart';

class ClientApp extends StatefulWidget{
  @override
  _ClientAppState createState() => _ClientAppState();
}

class _ClientAppState extends State<ClientApp> {
  final Client _server = Client();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actieve Servers')),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Voer je gebruikersnaam in',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => _server.connect(),
              child: Text("verbind")
          ),
        ],
      ),
      )
    );
  }
}