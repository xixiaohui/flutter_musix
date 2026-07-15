import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar + Name
          Center(
            child: Column(
              children: [
                Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                    ),
                  ),
                  child: const Icon(Icons.person, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text('Music Lover', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Feel Every Beat.', style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                )),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCard(icon: Icons.music_note, value: '48', label: 'Songs', theme: theme),
              _StatCard(icon: Icons.headphones, value: '127', label: 'Plays', theme: theme),
              _StatCard(icon: Icons.favorite, value: '12', label: 'Favorites', theme: theme),
            ],
          ),
          const SizedBox(height: 32),

          // Quick Actions
          _QuickAction(icon: Icons.favorite_border, title: 'Favorites', onTap: () => context.push('/favorite')),
          _QuickAction(icon: Icons.history, title: 'History', onTap: () => context.push('/history')),
          _QuickAction(icon: Icons.download, title: 'Downloads', onTap: () => context.push('/download')),
          _QuickAction(icon: Icons.settings, title: 'Settings', onTap: () => context.push('/settings')),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.value, required this.label, required this.theme});
  final IconData icon; final String value; final String label; final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.title, this.onTap});
  final IconData icon; final String title; final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right), onTap: onTap);
  }
}
