import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/playback_state_provider.dart';

/// A seekable progress bar with buffer display and time labels.
class SeekBar extends ConsumerWidget {
  const SeekBar({super.key});

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final position = ref.watch(
      playbackStateProvider.select((s) => s.position),
    );
    final duration = ref.watch(
      playbackStateProvider.select((s) => s.duration),
    );
    final progress = ref.watch(
      playbackStateProvider.select((s) => s.progress),
    );
    return Column(
      children: [
        SliderTheme(
          data: theme.sliderTheme.copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            thumbColor: theme.colorScheme.primary,
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final newPosition = Duration(
                milliseconds: (value * duration.inMilliseconds).round(),
              );
              ref
                  .read(playbackStateProvider.notifier)
                  .updatePosition(newPosition, duration);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: theme.textTheme.labelSmall,
              ),
              Text(
                '-${_formatDuration(duration - position)}',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
