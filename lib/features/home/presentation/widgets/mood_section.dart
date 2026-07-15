import 'package:flutter/material.dart';

class MoodSection extends StatelessWidget {
  const MoodSection({super.key, required this.moods});
  final List<String> moods;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icons = {
      'Chill': Icons.self_improvement,
      'Workout': Icons.fitness_center,
      'Focus': Icons.center_focus_strong,
      'Party': Icons.celebration,
      'Relax': Icons.spa,
      'Sleep': Icons.bedtime,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Mood',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: moods.map((mood) {
              return SizedBox(
                width: 100,
                child: Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            icons[mood] ?? Icons.mood,
                            size: 32,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mood,
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
