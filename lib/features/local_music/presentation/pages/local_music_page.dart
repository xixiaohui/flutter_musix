import 'package:flutter/material.dart';

import '../../../../common/widgets/empty_view.dart';

class LocalMusicPage extends StatelessWidget {
  const LocalMusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Local Music', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () {})],
      ),
      body: const AppEmptyView(
        title: 'No Local Music',
        subtitle: 'Scan your device for music files',
        actionLabel: 'Scan Now',
        icon: Icons.folder_outlined,
      ),
    );
  }
}
