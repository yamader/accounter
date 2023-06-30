import "package:flutter/material.dart";

extension ObjectEx on Object {
  String get hex6dig =>
      hashCode.toRadixString(16).padLeft(6, "0").substring(0, 6);
}

extension FutureEx<T> on Future<T> {
  // for developing
  Future<T> get delay async {
    await Future.delayed(const Duration(seconds: 2));
    return this;
  }
}

extension ContextEx on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  NavigatorState get nav => Navigator.of(this);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnack(
          SnackBar snack) =>
      ScaffoldMessenger.of(this).showSnackBar(snack);
}
