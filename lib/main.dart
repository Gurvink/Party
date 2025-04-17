import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:party/client/client.dart';
import 'package:party/host/host.dart';
import 'package:party/host/lobby.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    runApp(MaterialApp(
      home: ClientApp(),
    ));
  } else {
    await windowManager.ensureInitialized();
    await windowManager.setFullScreen(true);
    runApp(MaterialApp(
      home: HostApp(),
    ));
  }
}