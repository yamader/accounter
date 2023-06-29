import "package:accounter/data/providers.dart";
import "package:accounter/widgets/outlined_card.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class CategoryAmount extends HookConsumerWidget {
  const CategoryAmount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);

    return const OutlinedCard(
      child: Column(children: [
        Text("カテゴリーごとの金額"),
      ]),
    );
  }
}
