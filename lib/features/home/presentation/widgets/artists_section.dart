import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/album_art_helper.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';

class ArtistsSection extends ConsumerWidget {
  const ArtistsSection({super.key, required this.entries});
  final List<MusicJsonEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.read(playbackControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text('Artists', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final imgUrl = AlbumArtHelper.artistImage(entry.author, w: 128, h: 128);
              return GestureDetector(
                onTap: () => controller.playSong(entry, allSongs: entries),
                child: Column(children: [
                  ClipOval(
                    child: Image.network(imgUrl, width: 64, height: 64, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [theme.colorScheme.tertiaryContainer, theme.colorScheme.primaryContainer])),
                        child: Center(child: Text(entry.author.isNotEmpty ? entry.author[0].toUpperCase() : '?',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(width: 72,
                    child: Text(entry.author, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall)),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }
}
