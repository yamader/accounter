import "dart:io";

import "package:accounter/utils.dart";
import "package:drift/drift.dart";
import "package:drift/native.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";

import "models.dart";

part "db.g.dart";

@DriftDatabase(tables: [Balances, Categories])
class AccounterDB extends _$AccounterDB {
  AccounterDB() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();

        // seed
        await batch((batch) {
          batch.insertAll(categories, [
            CategoriesCompanion.insert(name: "食費"),
            CategoriesCompanion.insert(name: "交通費"),
            CategoriesCompanion.insert(name: "日用品"),
            CategoriesCompanion.insert(name: "趣味"),
            CategoriesCompanion.insert(name: "その他"),
          ]);
        });
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // migrations
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "db.sqlite"));
    return NativeDatabase.createInBackground(file);
  });
}
