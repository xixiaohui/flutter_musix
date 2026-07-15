import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Manages the just_audio AudioPlayer instance.
///
/// Provides a centralized audio player with queue management,
/// playback control, and status streams.
class AudioPlayerManager {
  final AudioPlayer _player = AudioPlayer();

  // ── Streams ──
  Stream<Duration> get positionStream =>
      _player.createPositionStream(
        steps: 200, // milliseconds
      );

  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<SequenceState?> get sequenceStateStream =>
      _player.sequenceStateStream;
  Stream<bool> get playingStream =>
      _player.playingStream.map((playing) => playing);

  // ── Current State ──
  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  bool get isPlaying => _player.playing;
  bool get isBuffering => _player.processingState == ProcessingState.buffering;

  // ── Playback Control ──

  /// Plays from a URL or local file path.
  Future<void> playFromUrl(String url) async {
    await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    await _player.play();
  }

  /// Sets up a playlist of URLs and starts playing from [startIndex].
  Future<void> setPlaylist(List<String> urls, {int startIndex = 0}) async {
    final sources = urls.map((url) => AudioSource.uri(Uri.parse(url))).toList();
    await _player.setAudioSource(
      ConcatenatingAudioSource(
        children: sources,
        useLazyPreparation: true,
      ),
      initialIndex: startIndex,
    );
    await _player.play();
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> seekToNext() => _player.seekToNext();
  Future<void> seekToPrevious() => _player.seekToPrevious();

  /// Moves to a specific index in the queue.
  Future<void> skipToIndex(int index) =>
      _player.seek(Duration.zero, index: index);

  // ── Playback Mode ──
  Future<void> setShuffleMode(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
  }

  LoopMode get loopMode => _player.loopMode;

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  // ── Queue ──
  List<AudioSource>? get queue => _player.sequence;
  int? get currentIndex => _player.currentIndex;

  /// Adds a URL to the end of the queue.
  Future<void> addToQueue(String url) async {
    final source = _player.audioSource;
    if (source is ConcatenatingAudioSource) {
      await source.add(AudioSource.uri(Uri.parse(url)));
    }
  }

  /// Removes an item from the queue by index.
  Future<void> removeFromQueue(int index) async {
    final source = _player.audioSource;
    if (source is ConcatenatingAudioSource) {
      await source.removeAt(index);
    }
  }

  /// Clears the queue and stops playback.
  Future<void> clearQueue() async {
    await _player.stop();
    await _player.setAudioSource(ConcatenatingAudioSource(children: []));
  }

  Future<void> dispose() => _player.dispose();
}

// ── Provider ──
final audioPlayerManagerProvider = Provider<AudioPlayerManager>((ref) {
  final manager = AudioPlayerManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});
