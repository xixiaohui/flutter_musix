import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/songs.dart';
import 'tables/albums.dart';
import 'tables/artists.dart';
import 'tables/playlists.dart';
import 'tables/playlist_songs.dart';
import 'tables/history.dart';
import 'tables/downloads.dart';
import 'tables/lyrics.dart';
import 'tables/settings.dart';
import 'tables/cache_entries.dart';
import 'tables/recents.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Songs,
    Albums,
    Artists,
    Playlists,
    PlaylistSongs,
    History,
    Downloads,
    Lyrics,
    Settings,
    CacheEntries,
    Recents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA journal_mode=WAL');
          await customStatement('PRAGMA foreign_keys=ON');
        },
      );

  // ── Songs ──
  Future<List<Song>> allSongs() => select(songs).get();
  Stream<List<Song>> watchAllSongs() => select(songs).watch();
  Future<List<Song>> searchSongs(String query) =>
      (select(songs)..where((t) => t.title.like('%$query%'))).get();
  Future<List<Song>> favoriteSongs() =>
      (select(songs)..where((t) => t.isFavorite.equals(true))).get();
  Future<Song?> songById(int id) =>
      (select(songs)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> insertSong(SongsCompanion song) => into(songs).insert(song);
  Stream<List<Song>> watchFavoriteSongs() =>
      (select(songs)..where((t) => t.isFavorite.equals(true))).watch();
  Future<void> toggleFavorite(int songId) async {
    final song = await songById(songId);
    if (song != null) {
      await (update(songs)..where((t) => t.id.equals(songId))).write(
        SongsCompanion(isFavorite: Value(!song.isFavorite)),
      );
    }
  }

  // ── Albums ──
  Future<List<Album>> allAlbums() => select(albums).get();
  Future<Album?> albumById(int id) =>
      (select(albums)..where((t) => t.id.equals(id))).getSingleOrNull();

  // ── Artists ──
  Future<List<Artist>> allArtists() => select(artists).get();
  Future<Artist?> artistById(int id) =>
      (select(artists)..where((t) => t.id.equals(id))).getSingleOrNull();

  // ── Playlists ──
  Future<List<Playlist>> allPlaylists() => select(playlists).get();
  Stream<List<Playlist>> watchAllPlaylists() => select(playlists).watch();
  Future<int> createPlaylist(PlaylistsCompanion playlist) =>
      into(playlists).insert(playlist);
  Future<void> deletePlaylist(int id) =>
      (delete(playlists)..where((t) => t.id.equals(id))).go();

  // ── Playlist Songs (custom name to avoid conflict) ──
  Future<List<PlaylistSong>> getPlaylistSongs(int playlistId) =>
      (select(playlistSongs)
            ..where((t) => t.playlistId.equals(playlistId))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .get();
  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    final existing = await (select(playlistSongs)
          ..where((t) =>
              t.playlistId.equals(playlistId) & t.songId.equals(songId)))
        .get();
    if (existing.isEmpty) {
      final count = await (select(playlistSongs)
            ..where((t) => t.playlistId.equals(playlistId)))
          .get()
          .then((list) => list.length);
      await into(playlistSongs).insert(
        PlaylistSongsCompanion.insert(
          playlistId: playlistId,
          songId: songId,
          position: count,
        ),
      );
    }
  }
  Future<void> removeSongFromPlaylist(int playlistId, int songId) =>
      (delete(playlistSongs)
            ..where((t) =>
                t.playlistId.equals(playlistId) & t.songId.equals(songId)))
          .go();

  // ── History ──
  Future<void> addToHistory(int songId) =>
      into(history).insert(HistoryCompanion.insert(songId: songId));
  Future<List<HistoryData>> getRecentHistory({int limit = 50}) =>
      (select(history)
            ..orderBy([(t) => OrderingTerm.desc(t.playedAt)])
            ..limit(limit))
          .get();
  Stream<List<HistoryData>> watchHistory() =>
      (select(history)
            ..orderBy([(t) => OrderingTerm.desc(t.playedAt)]))
          .watch();

  // ── Downloads ──
  Future<int> addDownload(int songId) =>
      into(downloads).insert(DownloadsCompanion.insert(songId: songId));
  Stream<List<Download>> watchDownloads() => select(downloads).watch();

  // ── Recents ──
  Future<void> addToRecent(int songId) async {
    // Remove old entry if exists, then insert new one
    await (delete(recents)..where((t) => t.songId.equals(songId))).go();
    await into(recents).insert(RecentsCompanion.insert(songId: songId));
  }
  Future<List<Recent>> getRecentSongs({int limit = 20}) =>
      (select(recents)
            ..orderBy([(t) => OrderingTerm.desc(t.accessedAt)])
            ..limit(limit))
          .get();

  // ── Settings ──
  Future<String?> getSetting(String key) =>
      (select(settings)..where((t) => t.key.equals(key)))
          .map((t) => t.value)
          .getSingleOrNull();
  Future<void> setSetting(String key, String value) =>
      into(settings).insertOnConflictUpdate(
        SettingsCompanion.insert(key: key, value: value),
      );

  // ── Cache ──
  Future<Uint8List?> getCache(String key) =>
      (select(cacheEntries)..where((t) => t.key.equals(key)))
          .map((t) => t.data)
          .getSingleOrNull();
  Future<void> setCache(String key, Uint8List data, {DateTime? expires}) =>
      into(cacheEntries).insertOnConflictUpdate(
        CacheEntriesCompanion.insert(
          key: key,
          data: data,
          expires: Value(expires),
        ),
      );
  Future<void> clearExpiredCache() =>
      (delete(cacheEntries)
            ..where((t) => t.expires.isSmallerThanValue(DateTime.now())))
          .go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'musix.db'));
    return NativeDatabase.createInBackground(file);
  });
}
