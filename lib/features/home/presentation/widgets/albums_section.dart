import 'package:flutter/material.dart';

import '../../../../core/utils/album_art_helper.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';

class AlbumsSection extends StatelessWidget {
  const AlbumsSection({super.key, required this.entries, this.onPlay});
  final List<MusicJsonEntry> entries;
  final void Function(MusicJsonEntry song)? onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Albums', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            TextButton(onPressed: () {}, child: const Text('See All')),
          ]),
        ),
        SizedBox(height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return GestureDetector(
                onTap: () => onPlay?.call(entry),
                child: SizedBox(width: 130,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        AlbumArtHelper.albumCover(entry.title, w: 260, h: 260),
                        width: 130, height: 130, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 130,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(colors: [theme.colorScheme.secondaryContainer, theme.colorScheme.primaryContainer])),
                          child: const Center(child: Icon(Icons.album, size: 40)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelLarge),
                    Text(entry.author, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
