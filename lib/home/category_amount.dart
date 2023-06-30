import "package:accounter/data/models.dart";
import "package:accounter/data/providers.dart";
import "package:accounter/widgets/outlined_card.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class CategoryAmount extends HookConsumerWidget {
  const CategoryAmount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final catsFuture = useMemoized(() => db.getCategories());

    return const OutlinedCard(
      child: Column(children: [
        Text("カテゴリーごとの金額"),
      ]),
    );
  }
}

class _Categories extends HookConsumerWidget {
  const _Categories({
    required this.catsFuture,
  });

  final Future<List<Category>> catsFuture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = useFuture(catsFuture);

    // todo: wip
    return ListView(children: const []);
    if (snapshot.hasData) {
    } else if (snapshot.hasError) {
    } else {}
  }
}
