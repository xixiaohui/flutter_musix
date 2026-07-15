import 'package:drift/drift.dart';

class Artists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 500)();
  TextColumn get image => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get genre => text().nullable()();
  IntColumn get albumCount => integer().withDefault(const Constant(0))();
  IntColumn get songCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
