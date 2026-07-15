import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/empty_view.dart';
import '../providers/playback_state_provider.dart';

/// Shows the current play queue with drag-to-reorder support.
class QueuePage extends ConsumerWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(playbackControllerProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Queue', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          if (state.queue.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => controller.clearQueue(),
            ),
        ],
      ),
      body: state.queue.isEmpty
          ? const AppEmptyView(title: 'Queue is empty', subtitle: 'Add songs to the queue to see them here', icon: Icons.queue_music_outlined)
          : ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 128),
              itemCount: state.queue.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex--;
                controller.reorderQueue(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final song = state.queue[index];
                final isCurrent = index == state.currentIndex;

                return ListTile(
                  key: ValueKey('${song.url}_$index'),
                  leading: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isCurrent ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: Icon(
                      isCurrent ? Icons.equalizer : Icons.music_note,
                      color: isCurrent ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrent ? theme.colorScheme.primary : null,
                      fontWeight: isCurrent ? FontWeight.w600 : null,
                    ),
                  ),
                  subtitle: Text(song.author, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => controller.removeFromQueue(index),
                  ),
                  onTap: () => controller.skipToIndex(index),
                );
              },
            ),
    );
  }
}
