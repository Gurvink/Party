import 'package:flutter/material.dart';
import 'package:party/client/screens/lobby/connectedScreen.dart';
import 'package:party/client/screens/lobby/connectionScreen.dart';
import 'package:party/client/screens/lobby/createPlayerScreen.dart';
import 'package:party/client/screens/lobby/hostScreen.dart';
import 'package:party/client/screens/monopoly/mainMonopolyScreen.dart';
import 'package:party/models/navigationService.dart';

class ClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return PopScope(
          canPop: false,
            child: child!
        );
      },
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => ConnectionScreen(),
        '/connected':  (context) => ConnectedScreen(),
        '/createPlayer': (context) => CreatePlayerScreen(),
        '/host': (context) => HostScreen(),
        '/Monopoly/Main': (context) => MainMonopolyScreen(),
      },
    );
  }
}