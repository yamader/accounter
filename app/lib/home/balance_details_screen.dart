import "package:accounter/data/models.dart";
import "package:accounter/data/providers.dart";
import "package:accounter/utils.dart";
import "package:accounter/widgets/money_icon.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:shimmer/shimmer.dart";

class BalanceDetailsScreen extends HookConsumerWidget {
  static Route route(int id) => MaterialPageRoute(
        builder: (_) => BalanceDetailsScreen(id: id),
      );

  const BalanceDetailsScreen({
    required this.id,
    super.key,
  });

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final balanceFuture = useMemoized(() => db.getBalance(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text("収支の詳細"),
      ),
      body: _Details(balanceFuture: balanceFuture),
    );
  }
}

class _Details extends HookConsumerWidget {
  const _Details({
    required this.balanceFuture,
  });

  final Future<Balance> balanceFuture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = useFuture(balanceFuture);

    if (snapshot.hasData) {
      final balance = snapshot.data!;

      return ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Material(
              shape: CircleBorder(),
              color: Colors.orange,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: MoneyIcon(size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(balance.title ?? "無題の収支",
                style: TextStyle(
                  color: balance.title == null
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                )),
          ]),
        ),
        const Divider(),
        ListTile(
          title: const Text("金額"),
          trailing: Text(
            "￥${balance.amount.abs()}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          onLongPress: () {
            Fluttertoast.showToast(msg: "コピーしたい");
          },
        ),
        ListTile(
          title: const Text("カテゴリ"),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(
              "${balance.amount > 0 ? "収入" : "支出"} - ${balance.category ?? "未分類"}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(LucideIcons.chevronRight),
          ]),
          onTap: () {
            context.showSnack(const SnackBar(
              content: Text("カテゴリなんて無えよ"),
            ));
          },
        ),
        ListTile(
          title: const Text("日付"),
          trailing: Text(
            balance.timestamp.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]);
    } else {
      if (snapshot.hasError) context.nav.pop(true);

      // todo: balance_detail_screen
      // todo: shimmer

      return Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade200,
        child: ListView(children: const [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  shape: CircleBorder(),
                  color: Colors.black,
                  child: SizedBox(width: 48, height: 48),
                ),
                SizedBox(width: 16),
                Material(
                  color: Colors.black,
                  child: SizedBox(width: 160, height: 24),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Material(
              color: Colors.black,
              child: SizedBox(width: 160, height: 24),
            ),
            trailing: Material(
              color: Colors.black,
              child: SizedBox(width: 160, height: 24),
            ),
          ),
          ListTile(
            title: Material(
              color: Colors.black,
              child: SizedBox(width: 160, height: 24),
            ),
            trailing: Material(
              color: Colors.black,
              child: SizedBox(width: 160, height: 24),
            ),
          ),
          ListTile(
            title: Material(
              color: Colors.black,
              child: SizedBox(width: 160, height: 24),
            ),
            trailing: Material(
                color: Colors.black, child: SizedBox(width: 160, height: 24)),
          ),
        ]),
      );
    }
  }
}
