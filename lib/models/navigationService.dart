import 'package:flutter/cupertino.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class NavigationService {
  Future<void> navigateTo(String route, {Object? arguments}) async {
    await navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }
  void goBack() {
    navigatorKey.currentState?.pop();
  }
  Future<void> replaceWith(String route, {Object? arguments}) async {
    await navigatorKey.currentState?.pushReplacementNamed(route, arguments: arguments);
  }
}