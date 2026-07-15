import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/empty_view.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../../repositories/music_repository.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final musicData = ref.watch(musicRepositoryProvider);
    // For now, display sample history from music data
    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {})],
      ),
      body: FutureBuilder<List<MusicJsonEntry>>(
        future: musicData.getOnlineMusic(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final entries = snapshot.data!.take(15).toList();
          if (entries.isEmpty) return const AppEmptyView(title: 'No listening history', subtitle: 'Start playing music to see your history here');
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 128),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final fakeTime = DateTime.now().subtract(Duration(hours: index * 3 + index));
              return ListTile(
                leading: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer])),
                  child: const Icon(Icons.music_note, size: 24),
                ),
                title: Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${entry.author} • ${_formatTime(fakeTime)}'),
                trailing: const Icon(Icons.more_horiz),
                onTap: () => context.push('/now-playing'),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
