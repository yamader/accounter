import "dart:io";

import "package:drift/drift.dart";
import "package:drift/native.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";

part "db.g.dart";

class Balances extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get amount => integer()();

  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  TextColumn get title => text().nullable()();

  TextColumn get comment => text().nullable()();

  IntColumn get category => integer().nullable().references(Categories, #id)();
}

@DataClassName("Category")
class Categories extends Table {
  static String toColor(Object seed) =>
      seed.hashCode.toRadixString(16).padLeft(6, "0").substring(0, 6);

  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get color =>
      text().withDefault(Variable(Categories.toColor(name)))();
}

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

  Future<Balance> getBalance(int id) =>
      (select(balances)..where((t) => t.id.equals(id))).getSingle();

  Stream<List<Balance>> watchThisMonthBalances() => (select(balances)
        // todo: 今月だけに絞る
        // ..where((t) => t.timestamp.isBetweenValues(
        //     DateTime.now().startOfMonth, DateTime.now().endOfMonth))
        ..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]))
      .watch();

  Future<int> addBalance(BalancesCompanion entry) =>
      into(balances).insert(entry);

  Future<void> deleteBalance(int id) =>
      (delete(balances)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "db.sqlite"));
    return NativeDatabase.createInBackground(file);
  });
}
