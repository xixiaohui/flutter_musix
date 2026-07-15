import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/playback_state_provider.dart';
import '../widgets/album_art_rotating.dart';
import '../widgets/playback_controls.dart';
import '../widgets/seek_bar.dart';

class NowPlayingPage extends ConsumerWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(playbackControllerProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Playing from Melodify',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
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
                      state.currentTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.currentArtist,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Error display
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(state.errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error)),
                ),

              const SizedBox(height: 16),

              // Like
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      state.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: state.isFavorite
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => controller.toggleFavorite(),
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
                      icon: Icon(Icons.shuffle, color: state.isShuffled ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
                      onPressed: () => controller.toggleShuffle(),
                    ),
                    IconButton(
                      icon: Icon(state.repeatIcon, color: state.isRepeating ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
                      onPressed: () => controller.toggleRepeat(),
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
                      onPressed: () => _showSpeedDialog(context, controller, state.speed),
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

  void _showSpeedDialog(BuildContext context, PlaybackController controller, double current) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Playback Speed'),
        content: StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${current.toStringAsFixed(2)}x',
                  style: Theme.of(context).textTheme.headlineMedium),
                Slider(
                  value: current,
                  min: 0.5, max: 2.0,
                  divisions: 6,
                  label: '${current.toStringAsFixed(2)}x',
                  onChanged: (v) {
                    setDialogState(() => current = v);
                    controller.setSpeed(v);
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.setSpeed(1.0);
              Navigator.pop(ctx);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
