import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../../repositories/music_repository.dart';

/// A simple playlist model for the UI layer.
class PlaylistModel {
  final String id;
  final String name;
  final String? description;
  final List<MusicJsonEntry> songs;

  const PlaylistModel({
    required this.id,
    required this.name,
    this.description,
    this.songs = const [],
  });
}

class PlaylistState {
  final List<PlaylistModel> playlists;
  final bool isLoading;

  const PlaylistState({this.playlists = const [], this.isLoading = true});

  PlaylistState copyWith({List<PlaylistModel>? playlists, bool? isLoading}) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PlaylistNotifier extends StateNotifier<PlaylistState> {
  final MusicRepository _repository;

  PlaylistNotifier(this._repository) : super(const PlaylistState()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _repository.getOnlineMusic();
      // Create sample playlists from the data
      final playlists = [
        PlaylistModel(
          id: '1', name: 'Favorites', description: 'My favorite tracks',
          songs: data.take(5).toList(),
        ),
        PlaylistModel(
          id: '2', name: 'Chill Vibes', description: 'Relaxing music',
          songs: data.skip(5).take(6).toList(),
        ),
        PlaylistModel(
          id: '3', name: 'Workout', description: 'High energy beats',
          songs: data.reversed.take(8).toList(),
        ),
      ];
      state = state.copyWith(playlists: playlists, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void createPlaylist(String name, {String? description}) {
    final newList = [
      ...state.playlists,
      PlaylistModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, description: description),
    ];
    state = state.copyWith(playlists: newList);
  }

  void deletePlaylist(String id) {
    state = state.copyWith(playlists: state.playlists.where((p) => p.id != id).toList());
  }
}

final playlistProvider = StateNotifierProvider<PlaylistNotifier, PlaylistState>((ref) {
  return PlaylistNotifier(ref.watch(musicRepositoryProvider));
});
