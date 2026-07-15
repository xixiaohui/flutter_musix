import 'package:drift/drift.dart';

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  TextColumn get type => text().withDefault(const Constant('string'))();

  @override
  Set<Column> get primaryKey => {key};
}
