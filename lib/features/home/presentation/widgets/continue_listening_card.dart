import 'package:flutter/material.dart';

import '../../../../data/datasources/remote/music_json_data_source.dart';

class ContinueListeningCard extends StatelessWidget {
  const ContinueListeningCard({super.key, required this.entries, this.onPlay});
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
          child: Text('Continue Listening', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return GestureDetector(
                onTap: () => onPlay?.call(entry, entries, index),
                child: SizedBox(
                  width: 280,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                              colors: [theme.colorScheme.primaryContainer, theme.colorScheme.surfaceContainerHighest],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Spacer(),
                              Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: theme.colorScheme.primary),
                                child: Icon(Icons.play_arrow_rounded, color: theme.colorScheme.onPrimary),
                              ),
                              const SizedBox(height: 12),
                              Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                              Text(entry.author, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
