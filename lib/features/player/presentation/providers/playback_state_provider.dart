import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../data/datasources/remote/music_json_data_source.dart';

/// UI-facing playback state — driven by just_audio streams.
class PlaybackState {
  final MusicJsonEntry? currentSong;
  final List<MusicJsonEntry> queue;
  final int currentIndex;
  final Duration position;
  final Duration duration;
  final Duration buffered;
  final bool isPlaying;
  final bool isBuffering;
  final bool isFavorite;
  final bool isDownloaded;
  final double downloadProgress;
  final bool isShuffled;
  final LoopMode loopMode;
  final double speed;
  final String? errorMessage;

  const PlaybackState({
    this.currentSong,
    this.queue = const [],
    this.currentIndex = -1,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.buffered = Duration.zero,
    this.isPlaying = false,
    this.isBuffering = false,
    this.isFavorite = false,
    this.isDownloaded = false,
    this.downloadProgress = 0,
    this.isShuffled = false,
    this.loopMode = LoopMode.off,
    this.speed = 1.0,
    this.errorMessage,
  });

  String get currentTitle => currentSong?.title ?? 'Not Playing';
  String get currentArtist => currentSong?.author ?? 'Select a song to start';

  double get progress =>
      duration.inMilliseconds > 0
          ? position.inMilliseconds / duration.inMilliseconds
          : 0;

  double get bufferProgress =>
      duration.inMilliseconds > 0
          ? buffered.inMilliseconds / duration.inMilliseconds
          : 0;

  bool get isRepeating => loopMode == LoopMode.one || loopMode == LoopMode.all;

  IconData get repeatIcon {
    switch (loopMode) {
      case LoopMode.one:
        return Icons.repeat_one;
      case LoopMode.all:
        return Icons.repeat;
      default:
        return Icons.repeat;
    }
  }

  PlaybackState copyWith({
    MusicJsonEntry? currentSong,
    List<MusicJsonEntry>? queue,
    int? currentIndex,
    Duration? position,
    Duration? duration,
    Duration? buffered,
    bool? isPlaying,
    bool? isBuffering,
    bool? isFavorite,
    bool? isDownloaded,
    double? downloadProgress,
    bool? isShuffled,
    LoopMode? loopMode,
    double? speed,
    String? errorMessage,
  }) {
    return PlaybackState(
      currentSong: currentSong ?? this.currentSong,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      buffered: buffered ?? this.buffered,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      isShuffled: isShuffled ?? this.isShuffled,
      loopMode: loopMode ?? this.loopMode,
      speed: speed ?? this.speed,
      errorMessage: errorMessage,
    );
  }
}

/// Unified playback controller — owns AudioPlayer and syncs state to UI.
class PlaybackController extends StateNotifier<PlaybackState> {
  final AudioPlayer _player;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<SequenceState?>? _sequenceSub;

  PlaybackController()
      : _player = AudioPlayer(),
        super(const PlaybackState()) {
    _listenToPlayer();
  }

  // ── Stream Sync ──
  void _listenToPlayer() {
    // Position — throttled to ~4 updates/sec for smooth seekbar without over-rebuilding
    _positionSub = _player.createPositionStream(
      steps: 250,
      minPeriod: const Duration(milliseconds: 250),
      maxPeriod: const Duration(milliseconds: 500),
    ).listen((pos) {
      if (mounted) {
        state = state.copyWith(
          position: pos,
          duration: _player.duration ?? state.duration,
        );
      }
    });

    _durationSub = _player.durationStream.listen((dur) {
      if (mounted && dur != null) {
        state = state.copyWith(duration: dur);
      }
    });

    _playerStateSub = _player.playerStateStream.listen((ps) {
      if (!mounted) return;
      state = state.copyWith(
        isPlaying: ps.playing,
        // Only flag as buffering during actual buffer refill, not initial loading
        isBuffering: ps.processingState == ProcessingState.buffering,
        buffered: _player.bufferedPosition,
        // Auto-clear error when playback resumes successfully
        errorMessage: ps.playing ? null : state.errorMessage,
      );
      // Record history when playback completes naturally (end of song)
      if (ps.processingState == ProcessingState.completed && state.currentSong != null) {
        _recordHistory(state.currentSong!);
      }
    });

    _sequenceSub = _player.sequenceStateStream.listen((seq) {
      if (!mounted) return;
      final index = seq?.currentIndex;
      if (index != null && index < state.queue.length) {
        state = state.copyWith(
          currentIndex: index,
          currentSong: state.queue[index],
          isShuffled: _player.shuffleModeEnabled,
          loopMode: _player.loopMode,
        );
      }
    });
  }

  // ── Core Playback ──

  /// Play a single song with skip support.
  /// If [allSongs] is provided, next/prev buttons work across the full list.
  Future<void> playSong(MusicJsonEntry song, {List<MusicJsonEntry>? allSongs}) async {
    try {
      final songs = allSongs ?? [song];
      final startIndex = songs.indexWhere((s) => s.url == song.url);
      final idx = startIndex >= 0 ? startIndex : 0;
      state = state.copyWith(
        queue: songs,
        currentIndex: idx,
        currentSong: songs[idx],
        errorMessage: null,
      );
      final sources = songs.map((s) => AudioSource.uri(Uri.parse(s.url))).toList();
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: sources, useLazyPreparation: true),
        initialIndex: idx,
      );
      await _player.play();
      _recordHistory(songs[idx]);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to play: $e');
    }
  }

  /// Play a list of songs starting from [startIndex].
  Future<void> playList(List<MusicJsonEntry> songs, {int startIndex = 0}) async {
    if (songs.isEmpty) return;
    try {
      state = state.copyWith(
        queue: songs,
        currentIndex: startIndex,
        currentSong: songs[startIndex],
        errorMessage: null,
      );
      final sources = songs.map((s) => AudioSource.uri(Uri.parse(s.url))).toList();
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: sources, useLazyPreparation: true),
        initialIndex: startIndex, preload: false,
      );
      await _player.play();
      _recordHistory(songs[startIndex]);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to play: $e');
    }
  }

  /// Play all songs from the JSON data source.
  Future<void> playAll(List<MusicJsonEntry> songs, {int startIndex = 0}) async {
    await playList(songs, startIndex: startIndex);
  }

  Future<void> play() async => _player.play();
  Future<void> pause() async => _player.pause();
  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seek(Duration position) async {
    final dur = _player.duration ?? Duration.zero;
    if (dur == Duration.zero) return;
    final p = position < Duration.zero ? Duration.zero : (position > dur ? dur : position);
    await _player.seek(p);
  }

  Future<void> seekToNext() async {
    if (state.queue.length <= 1) return; // Nothing to skip to
    await _player.seekToNext();
  }

  Future<void> seekToPrevious() async {
    if (_player.position.inMilliseconds > 3000) {
      // Restart current song
      await _player.seek(Duration.zero);
    } else {
      await _player.seekToPrevious();
    }
  }

  Future<void> skipToIndex(int index) async {
    if (index < 0 || index >= state.queue.length) return;
    await _player.seek(Duration.zero, index: index);
  }

  // ── Playback Mode ──
  Future<void> toggleShuffle() async {
    final shuffled = !_player.shuffleModeEnabled;
    await _player.setShuffleModeEnabled(shuffled);
    if (mounted) {
      state = state.copyWith(isShuffled: shuffled);
    }
  }

  Future<void> toggleRepeat() async {
    final nextMode = _nextLoopMode(_player.loopMode);
    await _player.setLoopMode(nextMode);
    if (mounted) {
      state = state.copyWith(loopMode: nextMode);
    }
  }

  LoopMode _nextLoopMode(LoopMode current) {
    switch (current) {
      case LoopMode.off:
        return LoopMode.all;
      case LoopMode.all:
        return LoopMode.one;
      case LoopMode.one:
        return LoopMode.off;
    }
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    if (mounted) {
      state = state.copyWith(speed: speed);
    }
  }

  // ── Queue Management ──
  Future<void> addToQueue(MusicJsonEntry song) async {
    final source = _player.audioSource;
    if (source is ConcatenatingAudioSource) {
      await source.add(AudioSource.uri(Uri.parse(song.url)));
      if (mounted) {
        state = state.copyWith(queue: [...state.queue, song]);
      }
    } else {
      // No queue yet — create one with current + new song
      final songs = [
        if (state.currentSong != null) state.currentSong!,
        song,
      ];
      await playList(songs, startIndex: 0);
    }
  }

  Future<void> removeFromQueue(int index) async {
    final source = _player.audioSource;
    if (source is ConcatenatingAudioSource && source.length > index) {
      await source.removeAt(index);
      if (mounted) {
        final newQueue = List<MusicJsonEntry>.from(state.queue)..removeAt(index);
        state = state.copyWith(queue: newQueue);
      }
    }
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    final source = _player.audioSource;
    if (source is ConcatenatingAudioSource) {
      await source.move(oldIndex, newIndex);
      if (mounted) {
        final newQueue = List<MusicJsonEntry>.from(state.queue);
        final item = newQueue.removeAt(oldIndex);
        newQueue.insert(newIndex, item);
        state = state.copyWith(queue: newQueue);
      }
    }
  }

  /// Clear the queue and completely stop playback.
  Future<void> clearQueue() async {
    await _player.stop();
    await _player.setAudioSource(ConcatenatingAudioSource(children: []));
    await _player.setShuffleModeEnabled(false);
    await _player.setLoopMode(LoopMode.off);
    await _player.setSpeed(1.0);
    if (mounted) {
      state = const PlaybackState();
    }
  }

  /// Remove error so user can retry.
  void clearError() => state = state.copyWith(errorMessage: null);

  // ── Favorite ──
  void toggleFavorite() {
    final song = state.currentSong;
    if (song == null) return;
    final nowFav = !state.isFavorite;
    state = state.copyWith(isFavorite: nowFav);
    if (nowFav) {
      onSongFavorited?.call(song);
    } else {
      onSongUnfavorited?.call(song);
    }
  }

  static void Function(MusicJsonEntry)? onSongFavorited;
  static void Function(MusicJsonEntry)? onSongUnfavorited;

  // ── History ──
  void _recordHistory(MusicJsonEntry song) {
    onSongPlayed?.call(song);
  }

  static void Function(MusicJsonEntry)? onSongPlayed;

  // ── Download ──
  void downloadCurrentSong() {
    final song = state.currentSong;
    if (song == null || state.isDownloaded) return;

    state = state.copyWith(isDownloaded: true, downloadProgress: 0);

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return false;
      final newProgress = state.downloadProgress + 0.09;
      if (newProgress >= 1.0) {
        state = state.copyWith(downloadProgress: 1.0);
        if (mounted) {
          _onDownloadComplete(song);
        }
        return false;
      }
      state = state.copyWith(downloadProgress: newProgress);
      return true;
    });
  }

  void _onDownloadComplete(MusicJsonEntry song) {
    // Notify downloads provider (set via callback)
    onSongDownloaded?.call(song);
  }

  /// Callback set by the downloads provider to receive completed downloads.
  static void Function(MusicJsonEntry)? onSongDownloaded;

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _sequenceSub?.cancel();
    _player.dispose();
    super.dispose();
  }
}

/// Global playback provider — accessed from anywhere in the app.
final playbackControllerProvider =
    StateNotifierProvider<PlaybackController, PlaybackState>((ref) {
  final controller = PlaybackController();
  // Wire callbacks
  PlaybackController.onSongDownloaded = (song) => ref.read(downloadedSongsProvider.notifier).addSong(song);
  PlaybackController.onSongFavorited = (song) => ref.read(favoriteSongsProvider.notifier).addSong(song);
  PlaybackController.onSongUnfavorited = (song) => ref.read(favoriteSongsProvider.notifier).removeSong(song);
  PlaybackController.onSongPlayed = (song) => ref.read(playHistoryProvider.notifier).addEntry(song);
  ref.onDispose(() {
    PlaybackController.onSongDownloaded = null;
    PlaybackController.onSongFavorited = null;
    PlaybackController.onSongUnfavorited = null;
    PlaybackController.onSongPlayed = null;
  });
  return controller;
});

/// Convenience: watch only the current song.
final currentSongProvider = Provider<MusicJsonEntry?>((ref) {
  return ref.watch(playbackControllerProvider).currentSong;
});

// ── Downloads Provider ──

class DownloadedSongsNotifier extends StateNotifier<List<MusicJsonEntry>> {
  DownloadedSongsNotifier() : super([]);
  void addSong(MusicJsonEntry song) { if (!state.any((s) => s.url == song.url)) state = [...state, song]; }
  void removeSong(MusicJsonEntry song) { state = state.where((s) => s.url != song.url).toList(); }
  void clearAll() => state = [];
  bool isDownloaded(MusicJsonEntry song) => state.any((s) => s.url == song.url);
}
final downloadedSongsProvider = StateNotifierProvider<DownloadedSongsNotifier, List<MusicJsonEntry>>((ref) => DownloadedSongsNotifier());

// ── Favorites Provider ──

class FavoriteSongsNotifier extends StateNotifier<List<MusicJsonEntry>> {
  FavoriteSongsNotifier() : super([]);
  void addSong(MusicJsonEntry song) { if (!state.any((s) => s.url == song.url)) state = [...state, song]; }
  void removeSong(MusicJsonEntry song) { state = state.where((s) => s.url != song.url).toList(); }
}
final favoriteSongsProvider = StateNotifierProvider<FavoriteSongsNotifier, List<MusicJsonEntry>>((ref) => FavoriteSongsNotifier());

// ── History Provider ──

class HistoryEntry {
  final MusicJsonEntry song;
  final DateTime playedAt;
  const HistoryEntry({required this.song, required this.playedAt});
}

class PlayHistoryNotifier extends StateNotifier<List<HistoryEntry>> {
  PlayHistoryNotifier() : super([]);
  void addEntry(MusicJsonEntry song) {
    state = [HistoryEntry(song: song, playedAt: DateTime.now()), ...state];
    if (state.length > 100) state = state.sublist(0, 100);
  }
  void clearAll() => state = [];
}
final playHistoryProvider = StateNotifierProvider<PlayHistoryNotifier, List<HistoryEntry>>((ref) => PlayHistoryNotifier());

