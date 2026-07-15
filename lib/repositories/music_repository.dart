import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/remote/music_json_data_source.dart';
import '../database/app_database.dart';

/// Repository interface for music data operations.
abstract class MusicRepository {
  Future<List<MusicJsonEntry>> getOnlineMusic();
  Future<List<MusicJsonEntry>> getRecommended();
  Future<List<MusicJsonEntry>> getTrending();
  Future<List<MusicJsonEntry>> searchMusic(String query);
  Future<void> syncToDatabase(List<MusicJsonEntry> entries);
}

/// Implementation of [MusicRepository].
class MusicRepositoryImpl implements MusicRepository {
  final MusicJsonDataSource _remoteDataSource;
  final AppDatabase _database;

  MusicRepositoryImpl(this._remoteDataSource, this._database);

  @override
  Future<List<MusicJsonEntry>> getOnlineMusic() async {
    return _remoteDataSource.loadMusicData();
  }

  @override
  Future<List<MusicJsonEntry>> getRecommended() async {
    final all = await _remoteDataSource.loadMusicData();
    all.shuffle();
    return all.take(10).toList();
  }

  @override
  Future<List<MusicJsonEntry>> getTrending() async {
    final all = await _remoteDataSource.loadMusicData();
    // Sort by most recent date for "trending"
    all.sort((a, b) {
      final da = a.parsedDate ?? DateTime(2000);
      final db = b.parsedDate ?? DateTime(2000);
      return db.compareTo(da);
    });
    return all.take(10).toList();
  }

  @override
  Future<List<MusicJsonEntry>> searchMusic(String query) async {
    final all = await _remoteDataSource.loadMusicData();
    final lower = query.toLowerCase();
    return all
        .where((e) =>
            e.title.toLowerCase().contains(lower) ||
            e.author.toLowerCase().contains(lower))
        .toList();
  }

  @override
  Future<void> syncToDatabase(List<MusicJsonEntry> entries) async {
    for (final entry in entries) {
      final existing = await _database.songById(entry.id);
      if (existing == null) {
        await _database.insertSong(SongsCompanion.insert(
          title: entry.title,
          url: Value(entry.url),
          cover: const Value.absent(),
          format: Value(entry.type),
          artistId: const Value.absent(),
          albumId: const Value.absent(),
          localPath: const Value.absent(),
          duration: const Value.absent(),
          size: const Value.absent(),
          trackNumber: const Value.absent(),
        ));
      }
    }
  }
}

// ── Riverpod Providers ──

final musicJsonDataSourceProvider = Provider<MusicJsonDataSource>((ref) {
  return MusicJsonDataSource();
});

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  return MusicRepositoryImpl(
    ref.watch(musicJsonDataSourceProvider),
    ref.watch(databaseProvider),
  );
});
