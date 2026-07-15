import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/cover_art.dart';
import '../../../../common/widgets/empty_view.dart';
import '../../../../core/utils/album_art_helper.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favorites = ref.watch(favoriteSongsProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Favorites', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
      body: favorites.isEmpty
          ? const AppEmptyView(title: 'No favorites yet', subtitle: 'Tap the heart icon while playing to save songs')
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 128),
              itemCount: favorites.length,
              itemBuilder: (_, i) {
                final s = favorites[i];
                return ListTile(
                  leading: CoverArt(size: 48, borderRadius: 8,
                    fallbackSeed: AlbumArtHelper.songCover(s.title, s.author)),
                  title: Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(s.author, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: theme.colorScheme.error),
                    onPressed: () => ref.read(favoriteSongsProvider.notifier).removeSong(s),
                  ),
                  onTap: () => controller.playSong(s, allSongs: favorites),
                );
              },
            ),
    );
  }
}
