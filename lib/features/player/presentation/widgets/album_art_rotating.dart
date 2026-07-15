import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/playback_state_provider.dart';

class AlbumArtRotating extends ConsumerStatefulWidget {
  const AlbumArtRotating({super.key});

  @override
  ConsumerState<AlbumArtRotating> createState() => _AlbumArtRotatingState();
}

class _AlbumArtRotatingState extends ConsumerState<AlbumArtRotating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPlaying = ref.watch(playbackControllerProvider).isPlaying;

    if (isPlaying) {
      if (!_anim.isAnimating) _anim.repeat();
    } else {
      _anim.stop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) => Transform.rotate(
          angle: _anim.value * 3.14159 * 2,
          child: child,
        ),
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
                blurRadius: 60, spreadRadius: 8,
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
                child: Icon(Icons.music_note_rounded, size: 80,
                  color: theme.colorScheme.onPrimaryContainer),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
