import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/equalizer_provider.dart';
import '../widgets/eq_curve_chart.dart';

/// 10-band equalizer with presets, bass boost, and custom controls.
class EqualizerPage extends ConsumerWidget {
  const EqualizerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(equalizerProvider);

    final bands = [
      '31', '63', '125', '250', '500', '1k', '2k', '4k', '8k', '16k'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Equalizer', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(equalizerProvider.notifier).reset()),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // EQ Curve Chart
          SizedBox(
            height: 180,
            child: EqCurveChart(gains: state.gains),
          ),
          const SizedBox(height: 24),

          // Band Sliders
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(10, (index) {
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      '${state.gains[index].toStringAsFixed(1)}',
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 160,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Slider(
                          value: state.gains[index],
                          min: -12,
                          max: 12,
                          onChanged: (v) => ref.read(equalizerProvider.notifier).setBand(index, v),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(bands[index], style: theme.textTheme.labelSmall),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Presets
          Text('Presets', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: EqPreset.values.map((preset) {
              return ChoiceChip(
                label: Text(preset.name),
                selected: state.selectedPreset == preset,
                onSelected: (_) => ref.read(equalizerProvider.notifier).selectPreset(preset),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Bass Boost
          SwitchListTile(
            title: const Text('Bass Boost'),
            value: state.bassBoost > 0,
            onChanged: (v) => ref.read(equalizerProvider.notifier).setBassBoost(v ? 6 : 0),
          ),
          if (state.bassBoost > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Slider(
                value: state.bassBoost.toDouble(),
                min: 3, max: 12,
                divisions: 3,
                label: '+${state.bassBoost}dB',
                onChanged: (v) => ref.read(equalizerProvider.notifier).setBassBoost(v.round()),
              ),
            ),

          // Balance
          ListTile(
            title: const Text('Balance'),
            trailing: SizedBox(
              width: 160,
              child: Slider(
                value: state.balance,
                min: -1, max: 1,
                onChanged: (v) => ref.read(equalizerProvider.notifier).setBalance(v),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
