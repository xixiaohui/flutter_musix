import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/empty_view.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../../repositories/music_repository.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.watch(musicRepositoryProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Favorites', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
      body: FutureBuilder<List<MusicJsonEntry>>(
        future: repo.getOnlineMusic(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final favs = snapshot.data!.take(8).toList();
          if (favs.isEmpty) return const AppEmptyView(title: 'No favorites yet', subtitle: 'Tap heart to save');
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 128),
            itemCount: favs.length,
            itemBuilder: (_, i) {
              final s = favs[i];
              return ListTile(
                leading: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer])),
                  child: const Icon(Icons.music_note, size: 24),
                ),
                title: Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(s.author, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: IconButton(icon: Icon(Icons.favorite, color: theme.colorScheme.error), onPressed: () {}),
                onTap: () => controller.playList(favs, startIndex: i),
              );
            },
          );
        },
      ),
    );
  }
}
