import "package:accounter/data/providers.dart";
import "package:drift/drift.dart" show Value;
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../data/db.dart";

class NewBalance extends HookConsumerWidget {
  const NewBalance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);

    final title = useState("");
    final amount = useState(0);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 10,
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "タイトル",
              ),
              onChanged: (String value) {
                title.value = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "金額?",
              ),
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                amount.value = int.parse(value);
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  db.addBalance(BalancesCompanion(
                    amount: Value(amount.value),
                    title: Value(title.value),
                  ));
                },
                child: const Text("追加"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
