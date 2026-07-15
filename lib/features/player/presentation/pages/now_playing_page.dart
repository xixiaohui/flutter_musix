import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/playback_state_provider.dart';
import '../widgets/album_art_rotating.dart';
import '../widgets/playback_controls.dart';
import '../widgets/seek_bar.dart';

/// Full-screen immersive now-playing experience.
class NowPlayingPage extends ConsumerWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final playback = ref.watch(playbackStateProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              'Playing from Musix',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Album Art
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: AlbumArtRotating(),
              ),

              const Spacer(flex: 1),

              // Song Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text(
                      playback.currentTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      playback.currentArtist,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Like / Favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      playback.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: playback.isFavorite
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      ref.read(playbackStateProvider.notifier).toggleFavorite();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Seek Bar
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SeekBar(),
              ),

              const SizedBox(height: 16),

              // Playback Controls
              const PlaybackControls(),

              const SizedBox(height: 16),

              // Secondary Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: playback.isShuffled
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        ref
                            .read(playbackStateProvider.notifier)
                            .toggleShuffle();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        playback.repeatIcon,
                        color: playback.isRepeating
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        ref
                            .read(playbackStateProvider.notifier)
                            .toggleRepeat();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.lyrics_outlined),
                      onPressed: () => context.push('/lyrics'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.queue_music_outlined),
                      onPressed: () => context.push('/queue'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.speed),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
