import "package:accounter/data/models.dart";
import "package:accounter/data/providers.dart";
import "package:drift/drift.dart" show Value;
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";

enum _AmountType { income, expense }

class NewBalance extends HookConsumerWidget {
  const NewBalance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);

    final type = useState(_AmountType.expense);
    final title = useState("");
    final amount = useState(0);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("収支を記録",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  )),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton(
                segments: const [
                  ButtonSegment(
                    value: _AmountType.income,
                    icon: Icon(LucideIcons.download),
                    label: Text("収入"),
                  ),
                  ButtonSegment(
                    value: _AmountType.expense,
                    icon: Icon(LucideIcons.upload),
                    label: Text("支出"),
                  ),
                ],
                selected: {type.value},
                onSelectionChanged: (value) {
                  type.value = value.first;
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "タイトル",
              ),
              onChanged: (value) {
                title.value = value;
              },
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "金額",
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
              onChanged: (value) {
                amount.value = int.parse(value);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  if (title.value.isEmpty && amount.value == 0) {
                    await Fluttertoast.showToast(msg: "有効な値を入力してください");
                    return;
                  }
                  await db.addBalance(BalancesCompanion(
                    amount: Value(type.value == _AmountType.expense
                        ? -amount.value
                        : amount.value),
                    title: Value(title.value.isEmpty ? null : title.value),
                  ));
                  if (context.mounted) Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("追加",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
