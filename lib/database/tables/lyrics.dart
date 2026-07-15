import 'package:drift/drift.dart';

class Lyrics extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get songId => integer()();
  TextColumn get lrcText => text()();
  TextColumn get lrcType => text().withDefault(const Constant('line'))();
  TextColumn get language => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
