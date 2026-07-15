import 'package:drift/drift.dart';

class Recents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get songId => integer()();
  DateTimeColumn get accessedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
