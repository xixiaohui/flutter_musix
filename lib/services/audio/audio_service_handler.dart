import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Background audio service handler.
///
/// Enables background playback, lock screen controls,
/// notification controls, and Bluetooth/headset controls.
class MelodifyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player;

  MelodifyAudioHandler(this._player) {
    _player.playbackEventStream.listen(_onPlaybackEvent);
    _player.sequenceStateStream.listen(_onSequenceState);
    _player.playingStream.listen((playing) {
      playbackState.add(playbackState.value.copyWith(playing: playing));
    });
  }

  void _onPlaybackEvent(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      processingState: _audioProcessingState,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      shuffleMode: _player.shuffleModeEnabled
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      repeatMode: _repeatMode,
    ));
  }

  void _onSequenceState(SequenceState? sequence) {
    if (sequence == null) return;
    final items = sequence.effectiveSequence;
    final queueItems = items
        .map((source) => source.tag is MediaItem
            ? source.tag as MediaItem
            : MediaItem(id: '', title: ''))
        .toList();
    queue.add(queueItems);
    final idx = sequence.currentIndex;
    if (idx != null && idx < items.length) {
      final tag = items[idx].tag;
      if (tag is MediaItem) {
        mediaItem.add(tag);
      }
    }
  }

  AudioProcessingState get _audioProcessingState {
    switch (_player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  AudioServiceRepeatMode get _repeatMode {
    switch (_player.loopMode) {
      case LoopMode.off:
        return AudioServiceRepeatMode.none;
      case LoopMode.one:
        return AudioServiceRepeatMode.one;
      case LoopMode.all:
        return AudioServiceRepeatMode.all;
    }
  }

  // ── Command handlers ──

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode mode) async {
    await _player.setShuffleModeEnabled(mode == AudioServiceShuffleMode.all);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode mode) async {
    switch (mode) {
      case AudioServiceRepeatMode.none:
        await _player.setLoopMode(LoopMode.off);
      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        await _player.setLoopMode(LoopMode.all);
    }
  }

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> onTaskRemoved() => _player.stop();

  /// Creates a [MediaItem] from song metadata for display in notifications.
  static MediaItem createMediaItem({
    required String id,
    required String title,
    required String artist,
    String? album,
    int? durationMs,
  }) {
    return MediaItem(
      id: id,
      title: title,
      artist: artist,
      album: album ?? 'Melodify',
      duration: durationMs != null ? Duration(milliseconds: durationMs) : null,
    );
  }
}
