import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_provider.dart';

/// Shows recent search history with clear option.
class SearchHistoryWidget extends ConsumerWidget {
  const SearchHistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final history = ref.watch(searchProvider.select((s) => s.history));

    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => ref.read(searchProvider.notifier).clearHistory(),
                child: const Text('Clear All'),
              ),
            ],
          ),
        ),
        ...history.map((term) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(term),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () =>
                    ref.read(searchProvider.notifier).removeFromHistory(term),
              ),
              onTap: () {},
            )),
      ],
    );
  }
}
