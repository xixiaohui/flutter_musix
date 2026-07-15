import 'package:flutter/material.dart';

import '../../../../data/datasources/remote/music_json_data_source.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key, required this.entries, this.onPlay});
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
          child: Text('Trending Now', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        ...entries.take(5).toList().asMap().entries.map((e) {
          final idx = e.key; final entry = e.value;
          return ListTile(
            leading: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer]),
              ),
              child: const Icon(Icons.music_note, size: 24),
            ),
            title: Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(entry.author, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.more_horiz),
            onTap: () => onPlay?.call(entry, entries, idx),
          );
        }),
      ],
    );
  }
}
