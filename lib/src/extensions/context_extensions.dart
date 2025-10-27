import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void showSnackBar(String text) {
    if (mounted) {
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
    }
  }
}
