import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/playback_state_provider.dart';

class PlaybackControls extends ConsumerWidget {
  const PlaybackControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isPlaying = ref.watch(playbackControllerProvider).isPlaying;
    final controller = ref.read(playbackControllerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.skip_previous_rounded),
          onPressed: () => controller.seekToPrevious(),
        ),
        const SizedBox(width: 24),
        // Animated Play/Pause
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 20, spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            iconSize: 40,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                key: ValueKey(isPlaying),
              ),
            ),
            color: theme.colorScheme.onPrimary,
            onPressed: () => controller.togglePlayPause(),
          ),
        ),
        const SizedBox(width: 24),
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.skip_next_rounded),
          onPressed: () => controller.seekToNext(),
        ),
      ],
    );
  }
}
