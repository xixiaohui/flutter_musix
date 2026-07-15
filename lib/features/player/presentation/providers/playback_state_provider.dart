import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI-facing playback state.
class PlaybackState {
  final String currentTitle;
  final String currentArtist;
  final String? coverUrl;
  final Duration position;
  final Duration duration;
  final Duration buffered;
  final bool isPlaying;
  final bool isBuffering;
  final bool isFavorite;
  final bool isShuffled;
  final bool isRepeating;
  final IconData repeatIcon;
  final double speed;

  const PlaybackState({
    this.currentTitle = 'Not Playing',
    this.currentArtist = 'Select a song to start',
    this.coverUrl,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.buffered = Duration.zero,
    this.isPlaying = false,
    this.isBuffering = false,
    this.isFavorite = false,
    this.isShuffled = false,
    this.isRepeating = false,
    this.repeatIcon = Icons.repeat,
    this.speed = 1.0,
  });

  double get progress =>
      duration.inMilliseconds > 0
          ? position.inMilliseconds / duration.inMilliseconds
          : 0;

  double get bufferProgress =>
      duration.inMilliseconds > 0
          ? buffered.inMilliseconds / duration.inMilliseconds
          : 0;

  PlaybackState copyWith({
    String? currentTitle,
    String? currentArtist,
    String? coverUrl,
    Duration? position,
    Duration? duration,
    Duration? buffered,
    bool? isPlaying,
    bool? isBuffering,
    bool? isFavorite,
    bool? isShuffled,
    bool? isRepeating,
    IconData? repeatIcon,
    double? speed,
  }) {
    return PlaybackState(
      currentTitle: currentTitle ?? this.currentTitle,
      currentArtist: currentArtist ?? this.currentArtist,
      coverUrl: coverUrl ?? this.coverUrl,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      buffered: buffered ?? this.buffered,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      isFavorite: isFavorite ?? this.isFavorite,
      isShuffled: isShuffled ?? this.isShuffled,
      isRepeating: isRepeating ?? this.isRepeating,
      repeatIcon: repeatIcon ?? this.repeatIcon,
      speed: speed ?? this.speed,
    );
  }
}

/// Notifier for the playback UI state.
class PlaybackStateNotifier extends StateNotifier<PlaybackState> {
  PlaybackStateNotifier() : super(const PlaybackState());

  void updateTitle(String title, String artist) {
    state = state.copyWith(currentTitle: title, currentArtist: artist);
  }

  void updatePosition(Duration position, Duration duration) {
    state = state.copyWith(position: position, duration: duration);
  }

  void updatePlaying(bool playing) {
    state = state.copyWith(isPlaying: playing);
  }

  void updateBuffered(Duration buffered) {
    state = state.copyWith(buffered: buffered);
  }

  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }

  void toggleShuffle() {
    state = state.copyWith(isShuffled: !state.isShuffled);
  }

  void toggleRepeat() {
    final isRepeating = !state.isRepeating;
    state = state.copyWith(
      isRepeating: isRepeating,
      repeatIcon: isRepeating ? Icons.repeat_one : Icons.repeat,
    );
  }

  void setSpeed(double speed) {
    state = state.copyWith(speed: speed);
  }
}

final playbackStateProvider =
    StateNotifierProvider<PlaybackStateNotifier, PlaybackState>(
  (ref) => PlaybackStateNotifier(),
);
