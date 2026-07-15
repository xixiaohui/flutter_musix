import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/album_art_helper.dart';
import '../providers/playback_state_provider.dart';

/// A rotating album art that spins during playback.
/// Uses picsum fallback based on current song for unique visuals.
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
    _anim = AnimationController(duration: const Duration(seconds: 20), vsync: this);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(playbackControllerProvider);
    final isPlaying = state.isPlaying;

    if (isPlaying) {
      if (!_anim.isAnimating) _anim.repeat();
    } else {
      _anim.stop();
    }

    final coverUrl = state.currentSong != null
        ? AlbumArtHelper.songCover(state.currentSong!.title, state.currentSong!.author, w: 400, h: 400)
        : null;

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
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.35),
                blurRadius: 80, spreadRadius: 12,
              ),
            ],
          ),
          child: ClipOval(
            child: coverUrl != null
                ? Image.network(coverUrl, fit: BoxFit.cover,
                    cacheWidth: 400, cacheHeight: 400,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          theme.colorScheme.primaryContainer,
                          theme.colorScheme.tertiaryContainer,
                        ]),
                      ),
                      child: Icon(Icons.music_note_rounded, size: 80,
                        color: theme.colorScheme.onPrimaryContainer),
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                            theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                          ]),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                : null,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        theme.colorScheme.primaryContainer,
                        theme.colorScheme.tertiaryContainer,
                      ]),
                    ),
                    child: Icon(Icons.music_note_rounded, size: 80,
                      color: theme.colorScheme.onPrimaryContainer),
                  ),
          ),
        ),
      ),
    );
  }
}
