import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/empty_view.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../../repositories/music_repository.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.watch(musicRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: FutureBuilder<List<MusicJsonEntry>>(
        future: repo.getOnlineMusic(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final favorites = snapshot.data!.take(8).toList();
          if (favorites.isEmpty) return const AppEmptyView(title: 'No favorites yet', subtitle: 'Tap the heart icon to save your favorites');
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 128),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final song = favorites[index];
              return ListTile(
                leading: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer])),
                  child: const Icon(Icons.music_note, size: 24),
                ),
                title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(song.author, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: IconButton(
                  icon: Icon(Icons.favorite, color: theme.colorScheme.error),
                  onPressed: () {},
                ),
                onTap: () => context.push('/now-playing'),
              );
            },
          );
        },
      ),
    );
  }
}
