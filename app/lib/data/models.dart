import "package:accounter/utils.dart";
import "package:drift/drift.dart";

import "db.dart";

export "db.dart";

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
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text().withDefault(Variable(name.hex6dig))();
}

class Periodicals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text().withDefault(Variable(name.hex6dig))();
  IntColumn get period => integer()();
}

extension DbEx on AccounterDB {
  Future<Balance> getBalance(int id) =>
      (select(balances)..where((t) => t.id.equals(id))).getSingle().delay;

  Stream<List<Balance>> watchThisMonthBalances() => (select(balances)
        // todo: 今月だけに絞る
        // ..where((t) => t.timestamp.isBetweenValues(
        //     DateTime.now().startOfMonth, DateTime.now().endOfMonth))
        ..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]))
      .watch();

  Future<int> addBalance(BalancesCompanion entry) =>
      into(balances).insert(entry).delay;

  Future<int> deleteBalance(int id) =>
      (delete(balances)..where((t) => t.id.equals(id))).go().delay;

  Future<List<Category>> getCategories() => select(categories).get().delay;
}
