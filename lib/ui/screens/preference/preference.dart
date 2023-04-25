import "package:flutter/material.dart";

class PreferenceScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => const PreferenceScreen(),
      );

  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Preference"),
      ),
    );
  }
}
