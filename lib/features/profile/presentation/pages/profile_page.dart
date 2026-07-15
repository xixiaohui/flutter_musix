import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../repositories/music_repository.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favs = ref.watch(favoriteSongsProvider);
    final history = ref.watch(playHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // Avatar
        Center(child: Column(children: [
          Container(width: 96, height: 96,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.tertiary])),
            child: const Icon(Icons.person, size: 48, color: Colors.white)),
          const SizedBox(height: 16),
          Text('Music Lover', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Feel Every Beat.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ])),
        const SizedBox(height: 32),

        // Stats — real data
        Consumer(builder: (context, ref, _) {
          final totalAsync = ref.watch(totalSongCountProvider);
          final totalSongs = totalAsync.valueOrNull ?? 0;
          return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _StatCard(icon: Icons.music_note, value: '$totalSongs', label: 'Songs', theme: theme),
            _StatCard(icon: Icons.headphones, value: '${history.length}', label: 'Plays', theme: theme),
            _StatCard(icon: Icons.favorite, value: '${favs.length}', label: 'Favorites', theme: theme),
          ]);
        }),
        const SizedBox(height: 32),

        // Quick Actions
        _QA(icon: Icons.favorite_border, title: 'Favorites', subtitle: '${favs.length} songs', onTap: () => context.push('/favorite')),
        _QA(icon: Icons.history, title: 'History', subtitle: '${history.length} entries', onTap: () => context.push('/history')),
        _QA(icon: Icons.download, title: 'Downloads', subtitle: '${ref.watch(downloadedSongsProvider).length} songs', onTap: () => context.push('/download')),
        _QA(icon: Icons.settings, title: 'Settings', onTap: () => context.push('/settings')),
      ]),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.value, required this.label, required this.theme});
  final IconData icon; final String value; final String label; final ThemeData theme;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: const EdgeInsets.all(16),
      child: Column(children: [
        Icon(icon, color: theme.colorScheme.primary, size: 28),
        const SizedBox(height: 8),
        Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ])),
  );
}

class _QA extends StatelessWidget {
  const _QA({required this.icon, required this.title, this.subtitle, this.onTap});
  final IconData icon; final String title; final String? subtitle; final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon), title: Text(title),
    subtitle: subtitle != null ? Text(subtitle!) : null,
    trailing: const Icon(Icons.chevron_right), onTap: onTap,
  );
}
