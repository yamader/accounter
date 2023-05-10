import "package:accounter/data/db.dart";
import "package:drift/drift.dart" show Value;
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class NewBalance extends StatefulWidget {
  const NewBalance({super.key});

  @override
  State<NewBalance> createState() => _NewBalanceState();
}

class _NewBalanceState extends State<NewBalance> {
  String _title = "";
  int _amount = 0;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AccounterDB>(context);

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
                setState(() => _title = value);
              },
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "金額?",
              ),
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                setState(() => _amount = int.parse(value));
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  db.addBalance(BalancesCompanion(
                    amount: Value(_amount),
                    title: Value(_title),
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
