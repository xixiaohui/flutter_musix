import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/playback_state_provider.dart';

/// A rotating album art that spins during playback.
class AlbumArtRotating extends ConsumerStatefulWidget {
  const AlbumArtRotating({super.key});

  @override
  ConsumerState<AlbumArtRotating> createState() => _AlbumArtRotatingState();
}

class _AlbumArtRotatingState extends ConsumerState<AlbumArtRotating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final playing = ref.watch(
      playbackStateProvider.select((s) => s.isPlaying),
    );

    // Control rotation based on playback state
    if (playing) {
      _controller.repeat();
    } else {
      _controller.stop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 3.14159 * 2,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.tertiaryContainer,
                theme.colorScheme.secondaryContainer,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 60,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Icon(
                  Icons.music_note_rounded,
                  size: 80,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
