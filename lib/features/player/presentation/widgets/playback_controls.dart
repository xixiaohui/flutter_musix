import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/playback_state_provider.dart';

/// Central playback controls: previous, play/pause, next with animated button.
class PlaybackControls extends ConsumerWidget {
  const PlaybackControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isPlaying = ref.watch(
      playbackStateProvider.select((s) => s.isPlaying),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.skip_previous_rounded),
          onPressed: () {},
        ),

        const SizedBox(width: 24),

        // Play / Pause
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
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
            onPressed: () {
              ref.read(playbackStateProvider.notifier).updatePlaying(!isPlaying);
            },
          ),
        ),

        const SizedBox(width: 24),

        // Next
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.skip_next_rounded),
          onPressed: () {},
        ),
      ],
    );
  }
}
