import 'package:drift/drift.dart';

class Downloads extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get songId => integer()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get filePath => text().nullable()();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
