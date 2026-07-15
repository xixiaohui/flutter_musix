import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/theme/theme.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          // ═══ Appearance ═══
          _sectionHeader('Appearance', theme),
          // Theme — vertical radio layout for clear text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Card(
              margin: EdgeInsets.zero,
              child: RadioGroup<ThemeMode>(
                groupValue: themeMode,
                onChanged: (v) => ref.read(themeModeProvider.notifier).state = v ?? ThemeMode.system,
                child: const Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: Text('Follow system', style: TextStyle(fontSize: 14)),
                      subtitle: Text('Automatically switch between light and dark'),
                      value: ThemeMode.system,
                      dense: true, visualDensity: VisualDensity.compact,
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text('Light', style: TextStyle(fontSize: 14)),
                      subtitle: Text('Always use light appearance'),
                      value: ThemeMode.light,
                      dense: true, visualDensity: VisualDensity.compact,
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text('Dark', style: TextStyle(fontSize: 14)),
                      subtitle: Text('Always use dark appearance'),
                      value: ThemeMode.dark,
                      dense: true, visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _switchTile(
            icon: Icons.colorize, title: 'Dynamic Color',
            subtitle: 'Use system wallpaper colors',
            value: true, onChanged: (_) {},
          ),
          _switchTile(
            icon: Icons.album, title: 'Album Color Sync',
            subtitle: 'Match player colors to album art',
            value: true, onChanged: (_) {},
          ),
          const Divider(indent: 56, endIndent: 16),

          // ═══ Playback ═══
          _sectionHeader('Playback', theme),
          _switchTile(
            icon: Icons.blur_linear, title: 'Gapless Playback',
            subtitle: 'Seamless transitions between songs',
            value: true, onChanged: (_) {},
          ),
          _switchTile(
            icon: Icons.transit_enterexit, title: 'Crossfade',
            subtitle: 'Smooth fade between tracks',
            value: false, onChanged: (_) {},
          ),
          _tile(
            icon: Icons.speed, title: 'Default Playback Speed',
            subtitle: 'Normal (1.0x)',
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {},
          ),
          _switchTile(
            icon: Icons.replay, title: 'Resume on Start',
            subtitle: 'Continue playing where you left off',
            value: true, onChanged: (_) {},
          ),
          const Divider(indent: 56, endIndent: 16),

          // ═══ Audio ═══
          _sectionHeader('Audio', theme),
          _tile(
            icon: Icons.equalizer, title: 'Equalizer',
            subtitle: '10-band EQ, presets, bass boost',
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () => context.push('/equalizer'),
          ),
          _tile(
            icon: Icons.high_quality, title: 'Streaming Quality',
            subtitle: 'Auto (adapts to network)',
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {},
          ),
          const Divider(indent: 56, endIndent: 16),

          // ═══ Library ═══
          _sectionHeader('Library', theme),
          Consumer(builder: (context, ref, _) {
            final favs = ref.watch(favoriteSongsProvider);
            return _tile(
              icon: Icons.favorite_outline, title: 'Favorites',
              subtitle: '${favs.length} songs',
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => context.push('/favorite'),
            );
          }),
          Consumer(builder: (context, ref, _) {
            final history = ref.watch(playHistoryProvider);
            return _tile(
              icon: Icons.history, title: 'Play History',
              subtitle: '${history.length} entries',
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => context.push('/history'),
            );
          }),
          const Divider(indent: 56, endIndent: 16),

          // ═══ Downloads ═══
          _sectionHeader('Downloads', theme),
          _tile(
            icon: Icons.folder_outlined, title: 'Download Location',
            subtitle: 'Internal Storage / Melodify',
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {},
          ),
          Consumer(builder: (context, ref, _) {
            final downloads = ref.watch(downloadedSongsProvider);
            return _tile(
              icon: Icons.storage, title: 'Downloads',
              subtitle: '${downloads.length} songs downloaded',
              trailing: downloads.isNotEmpty
                  ? TextButton.icon(
                      onPressed: () => ref.read(downloadedSongsProvider.notifier).clearAll(),
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Clear', style: TextStyle(fontSize: 12)),
                    )
                  : null,
            );
          }),
          _tile(
            icon: Icons.cached, title: 'Clear Cache',
            subtitle: 'Free up storage space',
            trailing: TextButton(
              onPressed: () {},
              child: const Text('12.5 MB', style: TextStyle(fontSize: 12)),
            ),
          ),
          const Divider(indent: 56, endIndent: 16),

          // ═══ Sleep ═══
          _sectionHeader('Sleep', theme),
          _tile(
            icon: Icons.bedtime, title: 'Sleep Timer',
            subtitle: 'Stop playback after a set time',
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {},
          ),
          const Divider(indent: 56, endIndent: 16),

          // ═══ About ═══
          _sectionHeader('About', theme),
          _tile(
            icon: Icons.info_outline, title: 'About Melodify',
            subtitle: 'Version 1.0.0 (Build 1)',
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () => context.push('/about'),
          ),
          _tile(
            icon: Icons.description_outlined, title: 'Open Source Licenses',
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Melodify',
              applicationVersion: '1.0.0',
            ),
          ),
          const SizedBox(height: 16),
          // Footer
          Center(
            child: Text('Made with ❤️  •  Feel Every Beat.',
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Reusable Widgets ──

  Widget _sectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 4),
      child: Text(title, style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.primary, fontWeight: FontWeight.w700, letterSpacing: 0.5,
      )),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch.adaptive(value: value, onChanged: onChanged),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity.compact,
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system: return 'Follow system';
      case ThemeMode.light: return 'Light';
      case ThemeMode.dark: return 'Dark';
    }
  }
}
