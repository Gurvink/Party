import 'package:flutter/material.dart';
import 'package:party/client/screens/connectedScreen.dart';
import 'package:party/client/screens/connectionScreen.dart';
import 'package:party/client/screens/createPlayerScreen.dart';
import 'package:party/client/screens/monopoly/mainMonopolyScreen.dart';
import 'package:party/models/navigationService.dart';

class ClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/Monopoly/Main',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => connectionScreen(),
        '/connected':  (context) => ConnectedScreen(),
        '/createPlayer': (context) => CreatePlayerScreen(),
        '/Monopoly/Main': (context) => MainMonopolyScreen(),
      },
    );
  }
}