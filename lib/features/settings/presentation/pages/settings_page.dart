import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/theme/theme.dart';

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
        children: [
          // ── Appearance ──
          _SectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            subtitle: Text(themeMode.name),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('Auto')),
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ],
              selected: {themeMode},
              onSelectionChanged: (mode) {
                ref.read(themeModeProvider.notifier).state = mode.first;
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.colorize),
            title: const Text('Dynamic Color'),
            trailing: Switch(
              value: true,
              onChanged: (_) {},
            ),
          ),
          const Divider(),

          // ── Playback ──
          _SectionHeader(title: 'Playback'),
          ListTile(
            leading: const Icon(Icons.bluetooth_audio),
            title: const Text('Gapless Playback'),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          ListTile(
            leading: const Icon(Icons.speed),
            title: const Text('Default Playback Speed'),
            trailing: const Text('1.0x'),
          ),
          const Divider(),

          // ── Audio Quality ──
          _SectionHeader(title: 'Audio'),
          ListTile(
            leading: const Icon(Icons.equalizer),
            title: const Text('Equalizer'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          // ── Storage ──
          _SectionHeader(title: 'Storage'),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Clear Cache'),
            subtitle: const Text('12.5 MB'),
            onTap: () {},
          ),
          const Divider(),

          // ── Sleep Timer ──
          _SectionHeader(title: 'Sleep'),
          ListTile(
            leading: const Icon(Icons.bedtime),
            title: const Text('Sleep Timer'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          // ── About ──
          _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Musix'),
            subtitle: const Text('Version 1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.primary, fontWeight: FontWeight.w600,
      )),
    );
  }
}
