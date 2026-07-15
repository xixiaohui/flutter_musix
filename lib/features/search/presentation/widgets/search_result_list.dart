import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/datasources/remote/music_json_data_source.dart';

/// Displays search results as a list of songs.
class SearchResultList extends StatelessWidget {
  const SearchResultList({super.key, required this.results});
  final List<MusicJsonEntry> results;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final entry = results[index];
        return ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.tertiaryContainer,
                ],
              ),
            ),
            child: const Icon(Icons.music_note, size: 24),
          ),
          title: Text(
            entry.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            entry.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.more_horiz),
          onTap: () => context.push('/now-playing'),
        );
      },
    );
  }
}
