import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/player/presentation/providers/playback_state_provider.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(playbackControllerProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    // Hide if no song is playing or queued
    if (state.currentSong == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => context.push('/now-playing'),
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.25),
              blurRadius: 12, offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 48, height: 48, margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer],
                ),
              ),
              child: const Icon(Icons.music_note, size: 24),
            ),
            // Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.currentTitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                  Text(state.currentArtist, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            // Play/Pause
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey(state.isPlaying),
                ),
              ),
              onPressed: () => controller.togglePlayPause(),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded), iconSize: 28,
              onPressed: () => controller.seekToNext(),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
