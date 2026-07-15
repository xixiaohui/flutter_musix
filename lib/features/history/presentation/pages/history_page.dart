import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/cover_art.dart';
import '../../../../common/widgets/empty_view.dart';
import '../../../../core/utils/album_art_helper.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final history = ref.watch(playHistoryProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => ref.read(playHistoryProvider.notifier).clearAll(),
            ),
        ],
      ),
      body: history.isEmpty
          ? const AppEmptyView(title: 'No listening history', subtitle: 'Start playing music to build your history')
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 128),
              itemCount: history.length,
              itemBuilder: (_, i) {
                final entry = history[i];
                final s = entry.song;
                return ListTile(
                  leading: CoverArt(size: 48, borderRadius: 8,
                    fallbackSeed: AlbumArtHelper.songCover(s.title, s.author)),
                  title: Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${s.author} • ${_fmtTime(entry.playedAt)}'),
                  trailing: const Icon(Icons.more_horiz),
                  onTap: () => controller.playSong(s, allSongs: history.map((e) => e.song).toList()),
                );
              },
            ),
    );
  }

  String _fmtTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.month}/${time.day}/${time.year}';
  }
}
