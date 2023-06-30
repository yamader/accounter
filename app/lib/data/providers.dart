import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:shared_preferences/shared_preferences.dart";

import "models.dart";

final pkgProvider = Provider<PackageInfo>(
    (_) => throw UnimplementedError("PackageInfo is not instantiated yet."));

final prefProvider = Provider<SharedPreferences>((_) =>
    throw UnimplementedError("SharedPreferences is not instantiated yet."));

final dbProvider = Provider((ref) {
  final db = AccounterDB();
  ref.onDispose(() => db.close());
  return db;
});

final thisMonthProvider = StreamProvider((ref) {
  final db = ref.watch(dbProvider);
  return db.watchThisMonthBalances();
});
