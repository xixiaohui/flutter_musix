import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary,
                  boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.4), blurRadius: 30)],
                ),
                child: Icon(Icons.music_note_rounded, size: 48, color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 24),
              Text('Melodify', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Feel Every Beat.', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 32),
              Text('Version 1.0.0', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('Built with Flutter & Dart', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 24),
              Text('Made with ❤️ for music lovers everywhere', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
