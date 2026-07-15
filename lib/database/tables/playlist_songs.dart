import 'package:drift/drift.dart';

class PlaylistSongs extends Table {
  IntColumn get playlistId => integer()();
  IntColumn get songId => integer()();
  IntColumn get position => integer()();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {playlistId, songId};
}
