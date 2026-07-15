import 'package:drift/drift.dart';

class CacheEntries extends Table {
  TextColumn get key => text()();
  BlobColumn get data => blob()();
  DateTimeColumn get expires => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
