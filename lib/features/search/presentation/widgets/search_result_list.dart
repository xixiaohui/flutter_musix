import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';

class SearchResultList extends ConsumerWidget {
  const SearchResultList({super.key, required this.results});
  final List<MusicJsonEntry> results;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.read(playbackControllerProvider.notifier);

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final entry = results[index];
        return ListTile(
          leading: Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer]),
            ),
            child: const Icon(Icons.music_note, size: 24),
          ),
          title: Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(entry.author, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.more_horiz),
          onTap: () => controller.playList(results, startIndex: index),
        );
      },
    );
  }
}
