import 'package:flutter/material.dart';

import '../../../../common/widgets/empty_view.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: const AppEmptyView(
        title: 'No Downloads',
        subtitle: 'Downloaded songs will appear here',
        icon: Icons.download_outlined,
      ),
    );
  }
}
