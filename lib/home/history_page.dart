import "package:accounter/data/models.dart";
import "package:accounter/data/providers.dart";
import "package:accounter/utils.dart";
import "package:accounter/widgets/error_tile.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "balance_details_screen.dart";

class HistoryPage extends HookConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // target date
    final mo = useState(DateTime.now().month);

    return const Padding(
      padding: EdgeInsets.all(0),
      child: Column(children: [
        Text("← 今月 →"),
        Flexible(
          child: Scrollbar(
            child: Balances(),
          ),
        ),
      ]),
    );
  }
}

class Balances extends HookConsumerWidget {
  const Balances({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final balancesStream = ref.watch(thisMonthProvider);

    return ListView(
      children: balancesStream.when(
        data: (balances) => [
          ...balances.map((balance) => ListTile(
                leading: const Material(
                  color: Colors.orange,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.currency_bitcoin,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Opacity(
                  opacity: balance.title == null ? .5 : 1,
                  child: Text(balance.title ?? "--",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                subtitle: Text(balance.timestamp.toString()),
                trailing: Text(
                    balance.amount > 0
                        ? "+${balance.amount}"
                        : balance.amount.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () async {
                  final res = await context.nav
                      .push(BalanceDetailsScreen.route(balance.id));
                  if (res && context.mounted) {
                    context.showSnack(const SnackBar(
                      content: Text("データの取得に失敗しました"),
                    ));
                  }
                },
                onLongPress: () async {
                  await db.deleteBalance(balance.id);
                  Fluttertoast.showToast(msg: "削除しました");
                },
              )),
          const SizedBox(height: 80),
        ],
        error: (err, stack) => const [
          ErrorTile(msg: "データの取得に失敗しました"),
        ],
        loading: () => [
          // shimmer
        ],
      ),
    );
  }
}
