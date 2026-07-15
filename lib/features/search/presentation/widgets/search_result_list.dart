import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/cover_art.dart';
import '../../../../core/utils/album_art_helper.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';

class SearchResultList extends ConsumerWidget {
  const SearchResultList({super.key, required this.results});
  final List<MusicJsonEntry> results;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(playbackControllerProvider.notifier);

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final entry = results[index];
        return ListTile(
          leading: CoverArt(
            size: 48, borderRadius: 8,
            fallbackSeed: AlbumArtHelper.songCover(entry.title, entry.author),
          ),
          title: Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(entry.author, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.more_horiz),
          onTap: () => controller.playSong(results[index], allSongs: results),
        );
      },
    );
  }
}
