import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../services/ringtone_service.dart';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => context.pop(),
        ),
        title: Text('Playing from Melodify',
          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (action) {
              if (action == 'ringtone') _setRingtone(context, ref, state);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'ringtone',
                child: ListTile(leading: Icon(Icons.ring_volume), title: Text('Set as Ringtone'), contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'share',
                child: ListTile(leading: Icon(Icons.share), title: Text('Share'), contentPadding: EdgeInsets.zero)),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
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
                child: Column(children: [
                  Text(state.currentTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(state.currentArtist,
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),

              if (state.errorMessage != null)
                Padding(padding: const EdgeInsets.all(8),
                  child: Text(state.errorMessage!, style: TextStyle(color: theme.colorScheme.error))),

              const SizedBox(height: 16),

              // Download + Favorite
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                // Download
                IconButton(
                  icon: Icon(
                    state.isDownloaded ? Icons.download_done_rounded
                        : state.downloadProgress > 0 ? Icons.downloading_rounded
                        : Icons.download_rounded,
                    color: state.isDownloaded ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => controller.downloadCurrentSong(),
                ),
                if (state.downloadProgress > 0 && state.downloadProgress < 1.0)
                  SizedBox(width: 24, height: 24,
                    child: CircularProgressIndicator(value: state.downloadProgress, strokeWidth: 2.5,
                      color: theme.colorScheme.primary)),
                const SizedBox(width: 8),
                // Favorite
                IconButton(
                  icon: Icon(state.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: state.isFavorite ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant),
                  onPressed: () => controller.toggleFavorite(),
                ),
              ]),

              const SizedBox(height: 8),

              // Seek Bar
              const Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: SeekBar()),

              const SizedBox(height: 16),

              // Playback Controls
              const PlaybackControls(),

              const SizedBox(height: 20),

              // Secondary Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    _ctrl(context,Icons.shuffle, state.isShuffled, () => controller.toggleShuffle()),
                    _ctrl(context,state.repeatIcon, state.isRepeating, () => controller.toggleRepeat()),
                    _ctrl(context,Icons.lyrics_outlined, false, () => context.push('/lyrics')),
                    _ctrl(context,Icons.queue_music_outlined, false, () => context.push('/queue')),
                    _ctrl(context,Icons.equalizer, false, () => context.push('/equalizer')),
                    _ctrl(context,Icons.graphic_eq, false, () => context.push('/visualizer')),
                    _ctrl(context,Icons.speed, false, () => _showSpeedDialog(context, controller, state.speed)),
                  ],
                ),
              ),
            ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ctrl(BuildContext ctx, IconData icon, bool active, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon,
        color: active ? Theme.of(ctx).colorScheme.primary : Theme.of(ctx).colorScheme.onSurfaceVariant),
      onPressed: onTap,
    );
  }

  void _setRingtone(BuildContext context, WidgetRef ref, PlaybackState state) {
    final song = state.currentSong;
    if (song == null) return;
    final dio = ref.read(dioProvider);
    final service = RingtoneService(dio);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        title: Text('Setting Ringtone'),
        content: Row(children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text('Downloading and setting...'),
        ]),
      ),
    );
    service.setAsRingtone(url: song.url, title: song.title, artist: song.author).then((result) {
      Navigator.pop(context); // close loading
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Icon(result.success ? Icons.check_circle : Icons.error,
            color: result.success ? Colors.green : Colors.red, size: 48),
          content: Text(result.message),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
    });
  }

  void _showSpeedDialog(BuildContext context, PlaybackController controller, double current) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Playback Speed'),
        content: StatefulBuilder(
          builder: (ctx, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${current.toStringAsFixed(2)}x', style: Theme.of(context).textTheme.headlineMedium),
              Slider(value: current, min: 0.5, max: 2.0, divisions: 6,
                label: '${current.toStringAsFixed(2)}x',
                onChanged: (v) { setDialogState(() => current = v); controller.setSpeed(v); }),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () { controller.setSpeed(1.0); Navigator.pop(ctx); }, child: const Text('Reset')),
        ],
      ),
    );
  }
}
