import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/empty_view.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../../repositories/music_repository.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.watch(musicRepositoryProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {})],
      ),
      body: FutureBuilder<List<MusicJsonEntry>>(
        future: repo.getOnlineMusic(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final entries = snapshot.data!.take(15).toList();
          if (entries.isEmpty) return const AppEmptyView(title: 'No listening history', subtitle: 'Start playing music');
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 128),
            itemCount: entries.length,
            itemBuilder: (_, i) {
              final e = entries[i];
              final fakeTime = DateTime.now().subtract(Duration(hours: i * 3 + i));
              return ListTile(
                leading: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer])),
                  child: const Icon(Icons.music_note, size: 24),
                ),
                title: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${e.author} • ${_fmtTime(fakeTime)}'),
                trailing: const Icon(Icons.more_horiz),
                onTap: () => controller.playList(entries, startIndex: i),
              );
            },
          );
        },
      ),
    );
  }

  String _fmtTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
