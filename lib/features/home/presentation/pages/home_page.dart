import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/error_view.dart';
import '../../../../common/widgets/skeleton_box.dart';
import '../providers/home_provider.dart';
import '../widgets/recently_played_section.dart';
import '../widgets/continue_listening_card.dart';
import '../widgets/recommended_section.dart';
import '../widgets/trending_section.dart';
import '../widgets/albums_section.dart';
import '../widgets/artists_section.dart';
import '../widgets/genres_section.dart';
import '../widgets/mood_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Good Music',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: homeAsync.when(
        loading: () => _buildSkeleton(),
        error: (error, _) => AppErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(homeProvider),
        ),
        data: (state) {
          if (state.isLoading) return _buildSkeleton();
          if (state.errorMessage != null) {
            return AppErrorView(
              message: state.errorMessage!,
              onRetry: () => ref.read(homeProvider.notifier).refresh(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(homeProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 128),
              children: [
                if (state.recentlyPlayed.isNotEmpty)
                  RecentlyPlayedSection(entries: state.recentlyPlayed),
                if (state.continueListening.isNotEmpty)
                  ContinueListeningCard(entries: state.continueListening),
                if (state.trending.isNotEmpty)
                  TrendingSection(entries: state.trending),
                if (state.recommended.isNotEmpty)
                  RecommendedSection(entries: state.recommended),
                if (state.albums.isNotEmpty)
                  AlbumsSection(entries: state.albums),
                if (state.artists.isNotEmpty)
                  ArtistsSection(entries: state.artists),
                if (state.genres.isNotEmpty)
                  GenresSection(genres: state.genres),
                if (state.moods.isNotEmpty)
                  MoodSection(moods: state.moods),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 128),
      children: [
        // Recently played skeleton
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: SkeletonBox(width: 150, height: 20),
        ),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, __) =>
                const SkeletonBox(width: 56, height: 56, borderRadius: 28),
          ),
        ),
        const SizedBox(height: 24),
        // Continue listening skeleton
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SkeletonBox(width: 180, height: 20),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const SkeletonBox(height: 160, borderRadius: 16),
        ),
        const SizedBox(height: 24),
        // Grid skeleton
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SkeletonBox(width: 120, height: 20),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(4, (_) {
              return const SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 140, borderRadius: 12),
                    SizedBox(height: 8),
                    SkeletonBox(width: 100, height: 14),
                    SizedBox(height: 4),
                    SkeletonBox(width: 60, height: 12),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
