import "package:flutter/material.dart";

class ErrorTile extends StatelessWidget {
  const ErrorTile({
    this.msg = "エラーが発生しました",
    super.key,
  });

  final String msg;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const Icon(Icons.error),
        title: const Text("エラー"),
        subtitle: Text(msg),
        iconColor: Theme.of(context).colorScheme.onError,
        textColor: Theme.of(context).colorScheme.onError,
        tileColor: Theme.of(context).colorScheme.error,
      );
}
