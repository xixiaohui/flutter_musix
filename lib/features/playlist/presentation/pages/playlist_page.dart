import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/empty_view.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';
import '../providers/playlist_provider.dart';

class PlaylistPage extends ConsumerWidget {
  const PlaylistPage({super.key, this.playlistId});
  final String? playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(playlistProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    if (playlistId != null) {
      final pl = state.playlists.where((p) => p.id == playlistId).firstOrNull;
      if (pl == null) {
        return Scaffold(appBar: AppBar(title: const Text('Playlist')),
          body: const AppEmptyView(title: 'Playlist not found'));
      }
      return Scaffold(
        appBar: AppBar(title: Text(pl.name)),
        body: pl.songs.isEmpty
            ? const AppEmptyView(title: 'No songs')
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 128),
                itemCount: pl.songs.length,
                itemBuilder: (_, i) {
                  final s = pl.songs[i];
                  return ListTile(
                    leading: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer])),
                      child: const Icon(Icons.music_note, size: 24),
                    ),
                    title: Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(s.author, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: const Icon(Icons.drag_handle),
                    onTap: () => controller.playList(pl.songs, startIndex: i),
                  );
                },
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Playlists', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => _showCreateDialog(context, ref))],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.playlists.isEmpty
              ? const AppEmptyView(title: 'No Playlists', subtitle: 'Create your first playlist', actionLabel: 'Create Playlist')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.playlists.length,
                  itemBuilder: (_, i) {
                    final pl = state.playlists[i];
                    return Card(
                      child: ListTile(
                        leading: Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer])),
                          child: const Icon(Icons.queue_music, size: 28),
                        ),
                        title: Text(pl.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${pl.songs.length} songs'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => ref.read(playlistProvider.notifier).deletePlaylist(pl.id),
                        ),
                        onTap: () {
                          if (pl.songs.isNotEmpty) {
                            controller.playList(pl.songs);
                          }
                          context.push('/playlist/${pl.id}');
                        },
                      ),
                    );
                  },
                ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Playlist'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Playlist name'), autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            if (ctrl.text.trim().isNotEmpty) {
              ref.read(playlistProvider.notifier).createPlaylist(ctrl.text.trim());
              Navigator.pop(ctx);
            }
          }, child: const Text('Create')),
        ],
      ),
    );
  }
}
