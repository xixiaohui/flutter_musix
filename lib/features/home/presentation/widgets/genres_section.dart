import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenresSection extends StatelessWidget {
  const GenresSection({super.key, required this.genres});
  final List<String> genres;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text('Genres', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: genres.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final colors = [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.secondaryContainer,
                theme.colorScheme.tertiaryContainer,
                theme.colorScheme.errorContainer,
                theme.colorScheme.primaryContainer,
                theme.colorScheme.secondaryContainer,
              ];
              return GestureDetector(
                onTap: () => context.go('/search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colors[index % colors.length],
                  ),
                  child: Text(genres[index],
                    style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
