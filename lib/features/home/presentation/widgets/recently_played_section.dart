import 'package:flutter/material.dart';

import '../../../../data/datasources/remote/music_json_data_source.dart';

class RecentlyPlayedSection extends StatelessWidget {
  const RecentlyPlayedSection({super.key, required this.entries, this.onPlay});
  final List<MusicJsonEntry> entries;
  final void Function(MusicJsonEntry song, List<MusicJsonEntry> all, int index)? onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text('Recently Played', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return GestureDetector(
                onTap: () => onPlay?.call(entry, entries, index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer]),
                      ),
                      child: const Icon(Icons.music_note, size: 24),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(width: 64,
                      child: Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
