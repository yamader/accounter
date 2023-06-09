import "package:accounter/data/db.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

final dbProvider = Provider((ref) {
  final db = AccounterDB();
  ref.onDispose(() => db.close());
  return db;
});

final balancesProvider = StreamProvider((ref) {
  final db = ref.watch(dbProvider);
  return db.watchBalances();
});
