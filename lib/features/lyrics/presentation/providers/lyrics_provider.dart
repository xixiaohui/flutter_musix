import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/lyric_line.dart';
import '../../domain/use_cases/parse_lyrics.dart';

/// State for the lyrics view.
class LyricsState {
  final List<LyricLine> lines;
  final int currentLineIndex;
  final bool isLoading;
  final String? errorMessage;
  final String? sourceText;

  const LyricsState({
    this.lines = const [],
    this.currentLineIndex = 0,
    this.isLoading = false,
    this.errorMessage,
    this.sourceText,
  });

  LyricsState copyWith({
    List<LyricLine>? lines,
    int? currentLineIndex,
    bool? isLoading,
    String? errorMessage,
    String? sourceText,
  }) {
    return LyricsState(
      lines: lines ?? this.lines,
      currentLineIndex: currentLineIndex ?? this.currentLineIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      sourceText: sourceText ?? this.sourceText,
    );
  }
}

class LyricsNotifier extends StateNotifier<LyricsState> {
  final ParseLyricsUseCase _parser;

  LyricsNotifier(this._parser) : super(const LyricsState());

  /// Loads and parses LRC text.
  void loadLyrics(String lrcText) {
    state = state.copyWith(isLoading: true, sourceText: lrcText);
    try {
      final lines = _parser(lrcText);
      state = state.copyWith(lines: lines, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Updates which line is currently highlighted based on playback position.
  void updatePosition(Duration position) {
    if (state.lines.isEmpty) return;
    // Binary search for the current line
    var index = 0;
    for (var i = 0; i < state.lines.length; i++) {
      if (state.lines[i].timestamp <= position) {
        index = i;
      } else {
        break;
      }
    }
    if (index != state.currentLineIndex) {
      state = state.copyWith(currentLineIndex: index);
    }
  }

  /// Seeks to a specific line's timestamp.
  Duration? seekToLine(int index) {
    if (index < 0 || index >= state.lines.length) return null;
    state = state.copyWith(currentLineIndex: index);
    return state.lines[index].timestamp;
  }
}

final lyricsProvider = StateNotifierProvider<LyricsNotifier, LyricsState>((ref) {
  return LyricsNotifier(ParseLyricsUseCase());
});
