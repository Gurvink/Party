import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:party/network.dart';

class ClientApp extends StatefulWidget{
  @override
  _ClientAppState createState() => _ClientAppState();
}

class _ClientAppState extends State<ClientApp> {
  final Client _server = Client();
  final NetworkScanner _scanner = NetworkScanner();
  List<String> _activeServers = [];

  @override
  void initState() {
    super.initState();
    _scanForServers();
  }

  // Scan naar servers en update de lijst
  void _scanForServers() async {
    List<String> servers = await _scanner.scanNetwork('0.0.0');
    setState(() {
      _activeServers = servers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actieve Servers')),
      body: ListView.builder(
        itemCount: _activeServers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: ElevatedButton(
                onPressed: () => _server.connect(_activeServers[index]),
                child: Text('Server: ${_activeServers[index]}')
            ),
          );
        },
      ),
    );
  }
}