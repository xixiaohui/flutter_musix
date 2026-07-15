import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/error_view.dart';
import '../../../../common/widgets/loading_view.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';
import '../providers/library_provider.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(libraryProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Library', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () => context.go('/search'))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: LibraryTab.values.map((tab) {
                final selected = state.selectedTab == tab;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Center(child: Text(tab.name.toUpperCase())),
                      selected: selected,
                      onSelected: (_) => ref.read(libraryProvider.notifier).selectTab(tab),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: state.isLoading
                ? const AppLoadingView()
                : state.errorMessage != null
                    ? AppErrorView(message: state.errorMessage!, onRetry: () => ref.invalidate(libraryProvider))
                    : _buildTab(state, controller, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(LibraryState state, PlaybackController controller, ThemeData theme) {
    switch (state.selectedTab) {
      case LibraryTab.songs:
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 128),
          itemCount: state.songs.length,
          itemBuilder: (_, i) {
            final s = state.songs[i];
            return ListTile(
              leading: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer])),
                child: const Icon(Icons.music_note, size: 24),
              ),
              title: Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(s.author, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.more_horiz),
              onTap: () => controller.playList(state.songs, startIndex: i),
            );
          },
        );
      case LibraryTab.albums:
        return GridView.builder(
          padding: const EdgeInsets.all(16).copyWith(bottom: 128),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: state.albums.length,
          itemBuilder: (_, i) {
            final a = state.albums[i];
            return GestureDetector(
              onTap: () => controller.playList(state.albums, startIndex: i),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container(
                      decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        gradient: LinearGradient(colors: [theme.colorScheme.secondaryContainer, theme.colorScheme.primaryContainer])),
                      child: const Center(child: Icon(Icons.album, size: 48)),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(a.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                        Text(a.author, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelSmall),
                      ]),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      case LibraryTab.artists:
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 128),
          itemCount: state.artists.length,
          itemBuilder: (_, i) {
            final a = state.artists[i];
            return ListTile(
              leading: CircleAvatar(backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(a.author.isNotEmpty ? a.author[0].toUpperCase() : '?',
                  style: TextStyle(color: theme.colorScheme.onPrimaryContainer))),
              title: Text(a.author),
              subtitle: Text(a.title),
              onTap: () => controller.playList(state.artists, startIndex: i),
            );
          },
        );
    }
  }
}
