import "package:accounter/data/providers.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";

class MoneyIcon extends HookConsumerWidget {
  const MoneyIcon({
    this.color,
    this.size,
    super.key,
  });

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(prefProvider);
    final symbolRupee = prefs.getBool("symbol_rupee") ?? false;

    return Icon(
      symbolRupee ? LucideIcons.indianRupee : LucideIcons.japaneseYen,
      size: size,
      color: color,
    );
  }
}
