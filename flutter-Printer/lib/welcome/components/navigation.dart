import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  void pop() {
    return navigationKey.currentState!.pop();
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigationKey.currentState!.pushNamed(routeName, arguments: arguments);
  }


}
