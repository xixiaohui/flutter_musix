import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/playback_state_provider.dart';

class SeekBar extends ConsumerStatefulWidget {
  const SeekBar({super.key});
  @override
  ConsumerState<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends ConsumerState<SeekBar> {
  double _dragValue = 0;

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(playbackControllerProvider);
    final controller = ref.read(playbackControllerProvider.notifier);
    final displayValue = _dragValue > 0 ? _dragValue : state.progress.clamp(0.0, 1.0);

    return Column(children: [
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
          value: displayValue,
          onChanged: (v) => setState(() => _dragValue = v),
          onChangeEnd: (v) {
            final pos = Duration(milliseconds: (v * state.duration.inMilliseconds).round());
            controller.seek(pos);
            setState(() => _dragValue = 0);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_fmt(_dragValue > 0
              ? Duration(milliseconds: (_dragValue * state.duration.inMilliseconds).round())
              : state.position), style: theme.textTheme.labelSmall),
          Text(state.duration.inMilliseconds > 0
              ? '-${_fmt(state.duration - (_dragValue > 0
                  ? Duration(milliseconds: (_dragValue * state.duration.inMilliseconds).round())
                  : state.position))}'
              : '--:--', style: theme.textTheme.labelSmall),
        ]),
      ),
    ]);
  }
}
