import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/equalizer_provider.dart';
import '../widgets/eq_curve_chart.dart';

class EqualizerPage extends ConsumerWidget {
  const EqualizerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(equalizerProvider);
    final n = ref.read(equalizerProvider.notifier);
    final t = Theme.of(context);
    final labels = ['31', '63', '125', '250', '500', '1K', '2K', '4K', '8K', '16K'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Equalizer', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          if (s.selectedPreset != EqPreset.normal)
            TextButton.icon(onPressed: () => n.reset(), icon: const Icon(Icons.restore, size: 18), label: const Text('Reset')),
        ],
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), children: [
        // ── Curve Chart ──
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(s.selectedPreset.name.toUpperCase(), style: t.textTheme.titleSmall?.copyWith(letterSpacing: 1, color: t.colorScheme.primary)),
                Text('10-Band', style: t.textTheme.labelSmall?.copyWith(color: t.colorScheme.onSurfaceVariant)),
              ]),
              const SizedBox(height: 12),
              SizedBox(height: 160, child: EqCurveChart(gains: s.gains)),
            ]),
          ),
        ),
        const SizedBox(height: 16),

        // ── 10-Band Sliders ──
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(10, (i) => Expanded(
                  child: Column(children: [
                    Text(s.gains[i].toStringAsFixed(1), style: t.textTheme.labelSmall?.copyWith(
                      color: s.gains[i].abs() > 6 ? t.colorScheme.primary : t.colorScheme.onSurfaceVariant,
                      fontWeight: s.gains[i].abs() > 6 ? FontWeight.w600 : null)),
                    SizedBox(height: 160,
                      child: RotatedBox(quarterTurns: 3,
                        child: SliderTheme(data: SliderTheme.of(context).copyWith(
                          trackHeight: 3, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6)),
                          child: Slider(value: s.gains[i], min: -12, max: 12, divisions: 48,
                            activeColor: t.colorScheme.primary,
                            inactiveColor: t.colorScheme.surfaceContainerHighest,
                            onChanged: (v) => n.setBand(i, v)),
                        ),
                      ),
                    ),
                    Text(labels[i], style: t.textTheme.labelSmall),
                  ]),
                )),
              ),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('+12dB', style: t.textTheme.labelSmall), Text('0dB', style: t.textTheme.labelSmall), Text('-12dB', style: t.textTheme.labelSmall),
              ]),
            ]),
          ),
        ),
        const SizedBox(height: 16),

        // ── Presets ──
        Text('Presets', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8,
          children: EqPreset.values.map((p) => ActionChip(
            avatar: Icon(_presetIcon(p), size: 16, color: s.selectedPreset == p ? t.colorScheme.onPrimaryContainer : null),
            label: Text(_presetLabel(p)),
            backgroundColor: s.selectedPreset == p ? t.colorScheme.primaryContainer : null,
            onPressed: () => n.selectPreset(p),
          )).toList(),
        ),
        const SizedBox(height: 20),

        // ── Bass Boost ──
        Card(
          child: Column(children: [
            SwitchListTile(
              title: const Text('Bass Boost', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(s.bassBoost > 0 ? '+${s.bassBoost}dB' : 'Off'),
              secondary: const Icon(Icons.speaker),
              value: s.bassBoost > 0,
              onChanged: (v) => n.setBassBoost(v ? 6 : 0),
            ),
            if (s.bassBoost > 0)
              Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(children: [
                  const Text('3'), Expanded(child: Slider(value: s.bassBoost.toDouble(), min: 3, max: 12, divisions: 3,
                    label: '+${s.bassBoost}dB', onChanged: (v) => n.setBassBoost(v.round()))), const Text('12'),
                ])),
          ]),
        ),
        const SizedBox(height: 8),

        // ── Balance ──
        Card(
          child: ListTile(
            leading: const Icon(Icons.tune),
            title: const Text('Balance', style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(s.balance == 0 ? 'Center' : s.balance < 0 ? '${(-s.balance * 100).round()}% Left' : '${(s.balance * 100).round()}% Right'),
            trailing: SizedBox(width: 150,
              child: Slider(value: s.balance, min: -1, max: 1, divisions: 20, onChanged: (v) => n.setBalance(v))),
          ),
        ),
      ]),
    );
  }

  IconData _presetIcon(EqPreset p) {
    switch (p) {
      case EqPreset.normal: return Icons.linear_scale;
      case EqPreset.rock: return Icons.rocket_launch;
      case EqPreset.pop: return Icons.music_note;
      case EqPreset.jazz: return Icons.nightlife;
      case EqPreset.classical: return Icons.piano;
      case EqPreset.hipHop: return Icons.headphones;
      case EqPreset.electronic: return Icons.bolt;
      case EqPreset.bassBoost: return Icons.speaker;
      case EqPreset.vocal: return Icons.mic;
      case EqPreset.custom: return Icons.tune;
    }
  }

  String _presetLabel(EqPreset p) {
    switch (p) {
      case EqPreset.normal: return 'Normal';
      case EqPreset.rock: return 'Rock';
      case EqPreset.pop: return 'Pop';
      case EqPreset.jazz: return 'Jazz';
      case EqPreset.classical: return 'Classical';
      case EqPreset.hipHop: return 'Hip-Hop';
      case EqPreset.electronic: return 'Electronic';
      case EqPreset.bassBoost: return 'Bass Boost';
      case EqPreset.vocal: return 'Vocal';
      case EqPreset.custom: return 'Custom';
    }
  }
}
