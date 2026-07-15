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
    _positionSub = _player.createPositionStream(
      steps: 200,
      minPeriod: const Duration(milliseconds: 200),
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
      if (mounted) {
        state = state.copyWith(
          isPlaying: ps.playing,
          isBuffering: ps.processingState == ProcessingState.buffering ||
              ps.processingState == ProcessingState.loading,
          buffered: _player.bufferedPosition,
        );
      }
    });

    _sequenceSub = _player.sequenceStateStream.listen((seq) {
      if (mounted) {
        final index = seq?.currentIndex;
        if (index != null && index < state.queue.length) {
          state = state.copyWith(
            currentIndex: index,
            currentSong: state.queue[index],
          );
        }
      }
    });
  }

  // ── Core Playback ──

  /// Play a single song.
  Future<void> playSong(MusicJsonEntry song) async {
    try {
      state = state.copyWith(
        queue: [song],
        errorMessage: null,
      );
      await _player.setAudioSource(AudioSource.uri(Uri.parse(song.url)));
      await _player.play();
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
      final sources =
          songs.map((s) => AudioSource.uri(Uri.parse(s.url))).toList();
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: sources, useLazyPreparation: true),
        initialIndex: startIndex,
      );
      await _player.play();
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

  Future<void> seek(Duration position) async => _player.seek(position);
  Future<void> seekToNext() async => _player.seekToNext();
  Future<void> seekToPrevious() async => _player.seekToPrevious();
  Future<void> skipToIndex(int index) async =>
      _player.seek(Duration.zero, index: index);

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

  /// Clear the queue and stop playback.
  Future<void> clearQueue() async {
    await _player.stop();
    await _player.setAudioSource(ConcatenatingAudioSource(children: []));
    if (mounted) {
      state = const PlaybackState();
    }
  }

  /// Remove error so user can retry.
  void clearError() => state = state.copyWith(errorMessage: null);

  // ── Favorite ──
  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }

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
  return PlaybackController();
});

/// Convenience: watch only the current song.
final currentSongProvider = Provider<MusicJsonEntry?>((ref) {
  return ref.watch(playbackControllerProvider).currentSong;
});
