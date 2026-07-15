import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/error_view.dart';
import '../../../../common/widgets/loading_view.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../providers/library_provider.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(libraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => context.go('/search')),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: LibraryTab.values.map((tab) {
                final isSelected = state.selectedTab == tab;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Center(child: Text(tab.name.toUpperCase())),
                      selected: isSelected,
                      onSelected: (_) =>
                          ref.read(libraryProvider.notifier).selectTab(tab),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Content
          Expanded(
            child: state.isLoading
                ? const AppLoadingView()
                : state.errorMessage != null
                    ? AppErrorView(
                        message: state.errorMessage!,
                        onRetry: () => ref.invalidate(libraryProvider),
                      )
                    : _buildTabContent(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, LibraryState state) {
    final theme = Theme.of(context);

    switch (state.selectedTab) {
      case LibraryTab.songs:
        return _buildSongList(context, theme, state.songs);
      case LibraryTab.albums:
        return _buildAlbumGrid(context, theme, state.albums);
      case LibraryTab.artists:
        return _buildArtistList(context, theme, state.artists);
    }
  }

  Widget _buildSongList(BuildContext context, ThemeData theme, List<MusicJsonEntry> songs) {
    if (songs.isEmpty) {
      return const Center(child: Text('No songs found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 128),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
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
          trailing: const Icon(Icons.more_horiz),
          onTap: () => context.push('/now-playing'),
        );
      },
    );
  }

  Widget _buildAlbumGrid(BuildContext context, ThemeData theme, List<MusicJsonEntry> albums) {
    return GridView.builder(
      padding: const EdgeInsets.all(16).copyWith(bottom: 128),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return GestureDetector(
          onTap: () => context.push('/now-playing'),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: LinearGradient(
                        colors: [theme.colorScheme.secondaryContainer, theme.colorScheme.primaryContainer],
                      ),
                    ),
                    child: const Center(child: Icon(Icons.album, size: 48)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(album.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                      Text(album.author, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArtistList(BuildContext context, ThemeData theme, List<MusicJsonEntry> artists) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 128),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(artist.author.isNotEmpty ? artist.author[0].toUpperCase() : '?',
              style: TextStyle(color: theme.colorScheme.onPrimaryContainer)),
          ),
          title: Text(artist.author),
          subtitle: Text('${artist.title} • More'),
          onTap: () => context.push('/now-playing'),
        );
      },
    );
  }
}
