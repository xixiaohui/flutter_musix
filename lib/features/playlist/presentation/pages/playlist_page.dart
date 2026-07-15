import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/empty_view.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../providers/playlist_provider.dart';

/// Shows all playlists or a single playlist's songs.
class PlaylistPage extends ConsumerWidget {
  const PlaylistPage({super.key, this.playlistId});
  final String? playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(playlistProvider);

    // If a specific playlist ID is given, show its details
    if (playlistId != null) {
      final playlist = state.playlists.where((p) => p.id == playlistId).firstOrNull;
      if (playlist == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Playlist')),
          body: const AppEmptyView(title: 'Playlist not found'),
        );
      }
      return _PlaylistDetailView(playlist: playlist);
    }

    // Show all playlists
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlists', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateDialog(context, ref),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.playlists.isEmpty
              ? const AppEmptyView(
                  title: 'No Playlists',
                  subtitle: 'Create your first playlist',
                  actionLabel: 'Create Playlist',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.playlists.length,
                  itemBuilder: (context, index) {
                    final pl = state.playlists[index];
                    return Card(
                      child: ListTile(
                        leading: Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer],
                            ),
                          ),
                          child: const Icon(Icons.queue_music, size: 28),
                        ),
                        title: Text(pl.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${pl.songs.length} songs${pl.description != null ? ' • ${pl.description}' : ''}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => ref.read(playlistProvider.notifier).deletePlaylist(pl.id),
                        ),
                        onTap: () => context.push('/playlist/${pl.id}'),
                      ),
                    );
                  },
                ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Playlist'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Playlist name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(playlistProvider.notifier).createPlaylist(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _PlaylistDetailView extends StatelessWidget {
  const _PlaylistDetailView({required this.playlist});
  final PlaylistModel playlist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(playlist.name)),
      body: playlist.songs.isEmpty
          ? const AppEmptyView(title: 'No songs in this playlist')
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 128),
              itemCount: playlist.songs.length,
              itemBuilder: (context, index) {
                final song = playlist.songs[index];
                return ListTile(
                  leading: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer],
                      ),
                    ),
                    child: const Icon(Icons.music_note, size: 24),
                  ),
                  title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(song.author, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.drag_handle),
                  onTap: () => context.push('/now-playing'),
                );
              },
            ),
    );
  }
}
