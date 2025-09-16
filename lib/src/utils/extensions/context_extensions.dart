import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void showSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<dynamic> backOrTo(PageRouteInfo<dynamic> route) async {
    if (router.canPop()) {
      return router.maybePop();
    } else {
      return router.replace(route);
    }
  }
}
