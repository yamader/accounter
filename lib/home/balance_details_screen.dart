import "package:accounter/data/providers.dart";
import "package:accounter/widgets/error_tile.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
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
    final db = ref.read(dbProvider);
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

  final Future balanceFuture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = useFuture(balanceFuture);

    if (snapshot.hasData) {
      return ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Material(
              shape: CircleBorder(),
              color: Colors.orange,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.currency_bitcoin,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(snapshot.data.title ?? "無題の収支",
                style: TextStyle(
                  color: snapshot.data.title == null
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
            "￥${snapshot.data.amount.abs()}",
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
              "${snapshot.data.amount > 0 ? "収入" : "支出"} - ${snapshot.data.category ?? "未分類"}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.navigate_next),
          ]),
          onTap: () {
            Fluttertoast.showToast(msg: "ここでなんかする");
          },
        ),
        ListTile(
          title: const Text("日付"),
          trailing: Text(
            snapshot.data.timestamp.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]);
    } else if (snapshot.hasError) {
      return ListView(children: const [
        ErrorTile(msg: "データの取得に失敗しました"),
      ]);
    } else {
      return Shimmer.fromColors(
        baseColor: const Color(0xFFEBEBF4),
        highlightColor: const Color(0xFFF4F4F4),
        child: ListView(children: const [
          ListTile(
            leading: Icon(Icons.title),
            title: Text("hogehoge"),
          ),
        ]),
      );
    }
  }
}
