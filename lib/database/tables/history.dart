import 'package:drift/drift.dart';

class History extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get songId => integer()();
  DateTimeColumn get playedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get playDuration => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
