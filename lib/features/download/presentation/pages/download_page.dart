import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/cover_art.dart';
import '../../../../common/widgets/empty_view.dart';
import '../../../../core/utils/album_art_helper.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';

class DownloadPage extends ConsumerWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final downloads = ref.watch(downloadedSongsProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          if (downloads.isNotEmpty)
            IconButton(icon: const Icon(Icons.delete_sweep), onPressed: () {
              showDialog(context: context, builder: (ctx) => AlertDialog(
                title: const Text('Clear Downloads'),
                content: const Text('Remove all downloaded songs?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  TextButton(onPressed: () {
                    ref.read(downloadedSongsProvider.notifier).clearAll();
                    Navigator.pop(ctx);
                  }, child: const Text('Clear All')),
                ],
              ));
            }),
        ],
      ),
      body: downloads.isEmpty
          ? const AppEmptyView(title: 'No Downloads', subtitle: 'Tap download on Now Playing to save songs offline', icon: Icons.download_outlined)
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 128),
              itemCount: downloads.length,
              itemBuilder: (context, index) {
                final song = downloads[index];
                return Dismissible(
                  key: Key(song.url),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
                    color: theme.colorScheme.errorContainer,
                    child: Icon(Icons.delete, color: theme.colorScheme.onErrorContainer),
                  ),
                  onDismissed: (_) => ref.read(downloadedSongsProvider.notifier).removeSong(song),
                  child: ListTile(
                    leading: CoverArt(size: 48, borderRadius: 8,
                      fallbackSeed: AlbumArtHelper.songCover(song.title, song.author)),
                    title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('${song.author} • Downloaded', maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => ref.read(downloadedSongsProvider.notifier).removeSong(song)),
                    onTap: () => controller.playSong(song, allSongs: downloads),
                  ),
                );
              },
            ),
    );
  }
}
