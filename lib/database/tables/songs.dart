import 'package:drift/drift.dart';

class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  IntColumn get artistId => integer().nullable()();
  IntColumn get albumId => integer().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get localPath => text().nullable()();
  TextColumn get cover => text().nullable()();
  TextColumn get format => text().withDefault(const Constant('mp3'))();
  IntColumn get duration => integer().nullable()();
  IntColumn get size => integer().nullable()();
  IntColumn get trackNumber => integer().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isLocal => boolean().withDefault(const Constant(false))();
  BoolColumn get isDownloaded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

}
