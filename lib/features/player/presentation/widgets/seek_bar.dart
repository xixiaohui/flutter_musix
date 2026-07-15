import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/playback_state_provider.dart';

class SeekBar extends ConsumerWidget {
  const SeekBar({super.key});

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(playbackControllerProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

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
            value: state.progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final pos = Duration(
                milliseconds: (value * state.duration.inMilliseconds).round(),
              );
              controller.seek(pos);
            },
            onChangeEnd: (value) {
              final pos = Duration(
                milliseconds: (value * state.duration.inMilliseconds).round(),
              );
              controller.seek(pos);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_fmt(state.position), style: theme.textTheme.labelSmall),
              Text(state.duration.inMilliseconds > 0
                  ? '-${_fmt(state.duration - state.position)}'
                  : '--:--', style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ],
    );
  }
}
