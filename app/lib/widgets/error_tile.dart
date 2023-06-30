import "package:accounter/utils.dart";
import "package:flutter/material.dart";
import "package:lucide_icons/lucide_icons.dart";

class ErrorTile extends StatelessWidget {
  const ErrorTile({
    this.msg = "エラーが発生しました",
    super.key,
  });

  final String msg;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const Icon(LucideIcons.alertTriangle),
        title: const Text("エラー"),
        subtitle: Text(msg),
        iconColor: context.colorScheme.onError,
        textColor: context.colorScheme.onError,
        tileColor: context.colorScheme.error,
      );
}
