import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:party/client/client.dart';
import 'package:party/host/host.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    runApp(MaterialApp(
      home: ClientApp(),
    ));
  } else {
    runApp(HostApp());
  }
}