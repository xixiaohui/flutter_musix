import 'package:flutter/material.dart';

/// A bottom sheet for setting a sleep timer.
class SleepTimerSheet extends StatelessWidget {
  const SleepTimerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final presets = [15, 30, 45, 60, 90];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: theme.colorScheme.outlineVariant),
            ),
          ),
          const SizedBox(height: 24),
          Text('Sleep Timer', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Stop playback after:', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: presets.map((mins) {
              return ChoiceChip(
                label: Text('$mins min'),
                selected: false,
                onSelected: (_) => Navigator.pop(context),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Stop after current song'),
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
