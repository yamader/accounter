import "package:flutter/material.dart";

class FilledCard extends StatelessWidget {
  const FilledCard({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: child,
    );
  }
}
