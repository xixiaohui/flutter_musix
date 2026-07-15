import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../../repositories/music_repository.dart';

/// Search state.
class SearchState {
  final String query;
  final List<MusicJsonEntry> results;
  final List<String> suggestions;
  final List<String> history;
  final bool isLoading;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.suggestions = const [],
    this.history = const [],
    this.isLoading = false,
  });

  SearchState copyWith({
    String? query,
    List<MusicJsonEntry>? results,
    List<String>? suggestions,
    List<String>? history,
    bool? isLoading,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Manages search state including debounced search and history.
class SearchNotifier extends StateNotifier<SearchState> {
  final MusicRepository _repository;
  Timer? _debounce;

  SearchNotifier(this._repository) : super(const SearchState());

  void search(String query) {
    _debounce?.cancel();

    if (query.isEmpty) {
      state = state.copyWith(query: '', results: [], suggestions: [], isLoading: false);
      return;
    }

    state = state.copyWith(query: query, isLoading: true);

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final results = await _repository.searchMusic(query);
        final suggestions = results
            .take(5)
            .map((e) => e.title)
            .toList();

        // Add to history
        final history = List<String>.from(state.history);
        if (!history.contains(query)) {
          history.insert(0, query);
          if (history.length > 20) history.removeLast();
        }

        if (mounted) {
          state = state.copyWith(
            results: results,
            suggestions: suggestions,
            history: history,
            isLoading: false,
          );
        }
      } catch (e) {
        if (mounted) {
          state = state.copyWith(isLoading: false);
        }
      }
    });
  }

  void clearHistory() {
    state = state.copyWith(history: []);
  }

  void removeFromHistory(String query) {
    final history = List<String>.from(state.history)..remove(query);
    state = state.copyWith(history: history);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref.watch(musicRepositoryProvider));
});
