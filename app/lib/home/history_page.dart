import "package:accounter/data/models.dart";
import "package:accounter/data/providers.dart";
import "package:accounter/utils.dart";
import "package:accounter/widgets/error_tile.dart";
import "package:accounter/widgets/money_icon.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";

import "balance_details_screen.dart";

class HistoryPage extends HookConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesStream = ref.watch(thisMonthProvider);
    final searchController = useTextEditingController();
    useListenable(searchController);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: SearchBar(
          controller: searchController,
          trailing: [
            searchController.text.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(LucideIcons.search),
                  )
                : IconButton(
                    onPressed: searchController.clear,
                    icon: const Icon(LucideIcons.delete),
                  )
          ],
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 8),
          ),
          hintText: "検索 (ORです)",
        ),
      ),
      Flexible(
        child: Scrollbar(
          child: ListView(
            children: balancesStream.when(
              data: (balances) {
                final res = balances.where((i) => searchController.text
                    .split(" ")
                    .any((j) => i.title?.contains(j) ?? false));
                return [
                  // todo: 月をまたいだ場合は、月の区切りを表示する
                  ...res.map((balance) => BalanceTile(balance: balance)),
                  res.isEmpty
                      ? const ListTile(
                          leading: Icon(LucideIcons.helpCircle),
                          title: Text("マッチする履歴はありません"),
                        )
                      : const SizedBox(height: 80), // FABの分
                ];
              },
              error: (err, stack) => const [
                ErrorTile(msg: "データの取得に失敗しました"),
              ],
              loading: () => [
                // shimmer
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

class BalanceTile extends HookConsumerWidget {
  const BalanceTile({
    required this.balance,
    super.key,
  });

  final Balance balance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);

    return ListTile(
      leading: const Material(
        color: Colors.orange,
        shape: CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: MoneyIcon(color: Colors.white),
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
          balance.amount > 0 ? "+${balance.amount}" : balance.amount.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
      onTap: () async {
        final res =
            await context.nav.push(BalanceDetailsScreen.route(balance.id)) ??
                false;
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
    );
  }
}
