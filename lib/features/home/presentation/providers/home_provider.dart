import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../../repositories/music_repository.dart';

/// The state for the Home page.
class HomeState {
  final List<MusicJsonEntry> recentlyPlayed;
  final List<MusicJsonEntry> continueListening;
  final List<MusicJsonEntry> recommended;
  final List<MusicJsonEntry> trending;
  final List<MusicJsonEntry> albums;
  final List<MusicJsonEntry> artists;
  final List<String> genres;
  final List<String> moods;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.recentlyPlayed = const [],
    this.continueListening = const [],
    this.recommended = const [],
    this.trending = const [],
    this.albums = const [],
    this.artists = const [],
    this.genres = const [],
    this.moods = const [],
    this.isLoading = true,
    this.errorMessage,
  });

  HomeState copyWith({
    List<MusicJsonEntry>? recentlyPlayed,
    List<MusicJsonEntry>? continueListening,
    List<MusicJsonEntry>? recommended,
    List<MusicJsonEntry>? trending,
    List<MusicJsonEntry>? albums,
    List<MusicJsonEntry>? artists,
    List<String>? genres,
    List<String>? moods,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      recentlyPlayed: recentlyPlayed ?? this.recentlyPlayed,
      continueListening: continueListening ?? this.continueListening,
      recommended: recommended ?? this.recommended,
      trending: trending ?? this.trending,
      albums: albums ?? this.albums,
      artists: artists ?? this.artists,
      genres: genres ?? this.genres,
      moods: moods ?? this.moods,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Provider that manages the home page data.
class HomeNotifier extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    final repo = ref.watch(musicRepositoryProvider);

    try {
      final musicData = await repo.getOnlineMusic();

      // Shuffle for recommended
      final recommended = List<MusicJsonEntry>.from(musicData)..shuffle();
      final trending = List<MusicJsonEntry>.from(musicData);
      trending.sort((a, b) {
        final da = a.parsedDate ?? DateTime(2000);
        final db = b.parsedDate ?? DateTime(2000);
        return db.compareTo(da);
      });

      return HomeState(
        recentlyPlayed: musicData.take(8).toList(),
        continueListening: musicData.reversed.take(4).toList(),
        recommended: recommended.take(10).toList(),
        trending: trending.take(10).toList(),
        albums: musicData.take(6).toList(),
        artists: musicData.reversed.take(6).toList(),
        genres: ['Pop', 'Rock', 'Jazz', 'Classical', 'Electronic', 'Hip-Hop'],
        moods: ['Chill', 'Workout', 'Focus', 'Party', 'Relax', 'Sleep'],
        isLoading: false,
      );
    } catch (e) {
      return HomeState(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final homeProvider =
    AsyncNotifierProvider<HomeNotifier, HomeState>(HomeNotifier.new);
