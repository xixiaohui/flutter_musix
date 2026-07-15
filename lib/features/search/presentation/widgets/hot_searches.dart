import 'package:flutter/material.dart';

/// Displays trending/hot search terms.
class HotSearches extends StatelessWidget {
  const HotSearches({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hotTerms = [
      'Radhe Krishna Flute',
      'iPhone Ringtone',
      'Baby Cry',
      'Whistle',
      'Doorbell',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Trending Searches',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: hotTerms.map((term) {
            return ActionChip(
              label: Text(term),
              avatar: const Icon(Icons.trending_up, size: 16),
              onPressed: () {},
            );
          }).toList(),
        ),
      ],
    );
  }
}
