import 'package:flutter/material.dart';
import 'package:party/client/screens/connectedScreen.dart';
import 'package:party/client/screens/connectionScreen.dart';
import 'package:party/client/screens/createPlayerScreen.dart';
import 'package:party/models/navigationService.dart';
import 'package:party/network.dart';

class ClientApp extends StatelessWidget {
  final NavigationService _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => connectionScreen(),
        '/connected':  (context) => ConnectedScreen(),
        '/createPlayer': (context) => CreatePlayerScreen(),
      },
    );
  }
}