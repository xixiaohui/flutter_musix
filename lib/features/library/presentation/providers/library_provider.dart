import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../../repositories/music_repository.dart';

/// Tabs in the library.
enum LibraryTab { songs, albums, artists }

/// State for the library page.
class LibraryState {
  final LibraryTab selectedTab;
  final List<MusicJsonEntry> songs;
  final List<MusicJsonEntry> albums;
  final List<MusicJsonEntry> artists;
  final bool isLoading;
  final String? errorMessage;

  const LibraryState({
    this.selectedTab = LibraryTab.songs,
    this.songs = const [],
    this.albums = const [],
    this.artists = const [],
    this.isLoading = true,
    this.errorMessage,
  });

  LibraryState copyWith({
    LibraryTab? selectedTab,
    List<MusicJsonEntry>? songs,
    List<MusicJsonEntry>? albums,
    List<MusicJsonEntry>? artists,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LibraryState(
      selectedTab: selectedTab ?? this.selectedTab,
      songs: songs ?? this.songs,
      albums: albums ?? this.albums,
      artists: artists ?? this.artists,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LibraryNotifier extends StateNotifier<LibraryState> {
  final MusicRepository _repository;

  LibraryNotifier(this._repository) : super(const LibraryState()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _repository.getOnlineMusic();
      state = state.copyWith(
        songs: data,
        albums: data,
        artists: data,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectTab(LibraryTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  void sortSongsByName() {
    final sorted = List<MusicJsonEntry>.from(state.songs)
      ..sort((a, b) => a.title.compareTo(b.title));
    state = state.copyWith(songs: sorted);
  }
}

final libraryProvider =
    StateNotifierProvider<LibraryNotifier, LibraryState>((ref) {
  return LibraryNotifier(ref.watch(musicRepositoryProvider));
});
