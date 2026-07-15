import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/player/presentation/providers/playback_state_provider.dart';

/// A persistent mini player displayed above the bottom navigation bar.
///
/// Shows current song info and basic playback controls.
/// Tapping expands to the full Now Playing page.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final playback = ref.watch(playbackStateProvider);
    final isPlaying = playback.isPlaying;

    return GestureDetector(
      onTap: () => context.push('/now-playing'),
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              // Album art thumbnail
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.tertiaryContainer,
                    ],
                  ),
                ),
                child: const Icon(Icons.music_note, size: 24),
              ),

              // Song info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playback.currentTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      playback.currentArtist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Play / Pause
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    key: ValueKey(isPlaying),
                  ),
                ),
                onPressed: () {
                  ref
                      .read(playbackStateProvider.notifier)
                      .updatePlaying(!isPlaying);
                },
              ),

              // Next
              IconButton(
                icon: const Icon(Icons.skip_next_rounded),
                iconSize: 28,
                onPressed: () {},
              ),

              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
