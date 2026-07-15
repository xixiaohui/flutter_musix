import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../player/presentation/providers/playback_state_provider.dart';
import '../providers/visualizer_provider.dart';
import '../widgets/bar_spectrum.dart';
import '../widgets/circular_spectrum.dart';
import '../widgets/glow_effect.dart';
import '../widgets/particle_field.dart';
import '../widgets/ripple_effect.dart';
import '../widgets/waveform_display.dart';

/// Full-screen immersive visualizer with:
/// - Swipe down to dismiss back to NowPlaying
/// - Animated mode switcher at bottom
/// - Background synced to current playback
class VisualizerPage extends ConsumerStatefulWidget {
  const VisualizerPage({super.key});

  @override
  ConsumerState<VisualizerPage> createState() => _VisualizerPageState();
}

class _VisualizerPageState extends ConsumerState<VisualizerPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(visualizerProvider);
    final playback = ref.watch(playbackControllerProvider);
    final notifier = ref.read(visualizerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        // Swipe down to dismiss
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
            context.pop();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Deep atmospheric background
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.3,
                  colors: [
                    state.primaryColor.withValues(alpha: 0.1),
                    state.primaryColor.withValues(alpha: 0.03),
                    Colors.black,
                  ],
                ),
              ),
            ),

            // Visualization
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _buildVisualization(state),
            ),

            // ── Top overlay: song info + close ──
            Positioned(
              left: 0, right: 0, top: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      // Close → back to NowPlaying
                      IconButton(
                        icon: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70, size: 24),
                        ),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 12),
                      // Current song
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(playback.currentTitle,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(playback.currentArtist,
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      // Mode label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        child: Text(state.mode.name.toUpperCase(),
                          style: const TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 2)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Swipe hint ──
            Positioned(
              left: 0, right: 0, top: MediaQuery.of(context).padding.top + 60,
              child: Center(
                child: AnimatedOpacity(
                  opacity: 0.3, duration: const Duration(seconds: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withValues(alpha: 0.5), size: 16),
                      Text('Swipe down', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom mode switcher ──
            Positioned(
              left: 0, right: 0, bottom: 32,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: VisualizerMode.values.map((mode) {
                        final selected = state.mode == mode;
                        return GestureDetector(
                          onTap: () => notifier.setMode(mode),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: selected ? state.primaryColor.withValues(alpha: 0.45) : Colors.transparent,
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(_modeIcon(mode), size: 16, color: selected ? Colors.white : Colors.white38),
                              if (selected) const SizedBox(width: 6),
                              if (selected) Text(mode.name.toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                            ]),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualization(VisualizerState state) {
    final key = ValueKey(state.mode);
    switch (state.mode) {
      case VisualizerMode.bars:      return BarSpectrum(key: key);
      case VisualizerMode.circular:  return CircularSpectrum(key: key);
      case VisualizerMode.waveform:  return WaveformDisplay(key: key);
      case VisualizerMode.particles: return ParticleField(key: key);
      case VisualizerMode.ripple:    return RippleEffect(key: key);
      case VisualizerMode.glow:      return GlowEffect(key: key);
    }
  }

  IconData _modeIcon(VisualizerMode m) {
    switch (m) {
      case VisualizerMode.bars:      return Icons.bar_chart_rounded;
      case VisualizerMode.circular:  return Icons.donut_large;
      case VisualizerMode.waveform:  return Icons.graphic_eq;
      case VisualizerMode.particles: return Icons.blur_on;
      case VisualizerMode.ripple:    return Icons.waves;
      case VisualizerMode.glow:      return Icons.wb_sunny;
    }
  }
}
