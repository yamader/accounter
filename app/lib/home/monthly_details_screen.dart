import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class MonthlyDetailsScreen extends HookConsumerWidget {
  static Route route(int id) =>
      MaterialPageRoute(builder: (_) => MonthlyDetailsScreen(id: id));

  const MonthlyDetailsScreen({
    required this.id,
    super.key,
  });

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold();
  }
}
