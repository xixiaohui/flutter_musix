import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/dio_client.dart';
import '../../core/utils/album_art_helper.dart';
import '../../features/player/presentation/providers/playback_state_provider.dart';
import '../../services/ringtone_service.dart';

class MiniPlayer extends ConsumerStatefulWidget {
  const MiniPlayer({super.key});
  @override
  ConsumerState<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends ConsumerState<MiniPlayer> {
  void _dismiss() => ref.read(playbackControllerProvider.notifier).clearQueue();

  void _setRingtone(PlaybackState state) {
    final song = state.currentSong;
    if (song == null) return;
    final dio = ref.read(dioProvider);
    final svc = RingtoneService(dio);
    showDialog(context: context, barrierDismissible: false,
      builder: (_) => const AlertDialog(title: Text('Setting Ringtone'),
        content: Row(children: [CircularProgressIndicator(), SizedBox(width: 16), Text('Downloading...')])),
    );
    svc.setAsRingtone(url: song.url, title: song.title, artist: song.author).then((r) {
      Navigator.pop(context);
      showDialog(context: context, builder: (_) => AlertDialog(
        title: Icon(r.success ? Icons.check_circle : Icons.error, color: r.success ? Colors.green : Colors.red, size: 40),
        content: Text(r.message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final state = ref.watch(playbackControllerProvider);
    final ctrl = ref.read(playbackControllerProvider.notifier);
    if (state.currentSong == null) return const SizedBox.shrink();

    final coverUrl = AlbumArtHelper.songCover(state.currentTitle, state.currentArtist, w: 96, h: 96);

    return Dismissible(
      key: const Key('mini_player'),
      direction: DismissDirection.down,
      dismissThresholds: const {DismissDirection.down: 0.3},
      onDismissed: (_) => _dismiss(),
      child: GestureDetector(
        onTap: () => context.push('/now-playing'),
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
            color: t.colorScheme.surfaceContainerHighest.withValues(alpha: 0.95),
            boxShadow: [BoxShadow(color: t.colorScheme.shadow.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 2))],
          ),
          child: Row(children: [
            // Thumbnail
            Container(width: 48, height: 48, margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(borderRadius: BorderRadius.circular(10),
                child: Image.network(coverUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [t.colorScheme.primaryContainer, t.colorScheme.tertiaryContainer])),
                    child: const Icon(Icons.music_note, size: 24)),
                )),
            ),
            // Info
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(state.currentTitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: t.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
              Text(state.currentArtist, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: t.textTheme.labelSmall?.copyWith(color: t.colorScheme.onSurfaceVariant)),
            ])),
            // Favorite
            IconButton(visualDensity: VisualDensity.compact, iconSize: 20,
              icon: Icon(state.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: state.isFavorite ? t.colorScheme.error : t.colorScheme.onSurfaceVariant),
              onPressed: () => ctrl.toggleFavorite()),
            // Download
            IconButton(visualDensity: VisualDensity.compact, iconSize: 20,
              icon: Icon(state.isDownloaded ? Icons.download_done_rounded : Icons.download_rounded,
                color: state.isDownloaded ? t.colorScheme.primary : t.colorScheme.onSurfaceVariant),
              onPressed: () => ctrl.downloadCurrentSong()),
            // Ringtone
            IconButton(visualDensity: VisualDensity.compact, iconSize: 20,
              icon: const Icon(Icons.ring_volume),
              onPressed: () => _setRingtone(state)),
            // Play/Pause
            IconButton(visualDensity: VisualDensity.compact,
              icon: AnimatedSwitcher(duration: const Duration(milliseconds: 200),
                child: Icon(state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, key: ValueKey(state.isPlaying))),
              onPressed: () => ctrl.togglePlayPause()),
            // Close
            IconButton(visualDensity: VisualDensity.compact, icon: const Icon(Icons.close, size: 18),
              onPressed: _dismiss, tooltip: 'Stop'),
            const SizedBox(width: 2),
          ]),
        ),
      ),
    );
  }
}
