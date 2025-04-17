import 'dart:developer';
import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> navigateTo(String routeName,
      {bool clearStack = false}) async {
    log("Navigating to: $routeName");

    if (navigatorKey.currentState == null) {
      debugPrint("Navigator is not ready yet!");
      return;
    }

    if (clearStack) {
      navigatorKey.currentState!
          .pushNamedAndRemoveUntil(routeName, (route) => false);
    } else {
      navigatorKey.currentState!.pushNamed(routeName);
    }
  }
}
