import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/visualizer_provider.dart';

/// Compact 3-bar mini visualizer for the NowPlaying page footer area.
/// Simple, elegant, non-intrusive.
class MiniVisualizer extends ConsumerWidget {
  const MiniVisualizer({super.key, this.barCount = 32, this.height = 40});

  final int barCount;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(visualizerProvider);
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _MiniVisPainter(
          bands: state.frame.bands.take(barCount).toList(),
          beatIntensity: state.frame.beatIntensity,
          primaryColor: state.primaryColor,
          isBeat: state.frame.isBeat,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _MiniVisPainter extends CustomPainter {
  final List<double> bands;
  final double beatIntensity;
  final Color primaryColor;
  final bool isBeat;

  _MiniVisPainter({
    required this.bands,
    required this.beatIntensity,
    required this.primaryColor,
    required this.isBeat,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (bands.isEmpty) return;

    final count = bands.length;
    final barW = (size.width / count) * 0.6;
    final gap = (size.width / count) * 0.4;
    final baseY = size.height;
    final pulse = 1.0 + beatIntensity * 0.3;

    for (var i = 0; i < count; i++) {
      final x = i * (barW + gap) + gap / 2;
      final h = bands[i].clamp(0.0, 1.0) * size.height * 0.85 * pulse;
      final y = baseY - h;

      final rect = RRect.fromLTRBR(x, y, x + barW, baseY, const Radius.circular(1.5));
      final alpha = 0.15 + bands[i] * 0.45 + (isBeat ? 0.2 : 0);
      final paint = Paint()..color = primaryColor.withValues(alpha: alpha)..style = PaintingStyle.fill;

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniVisPainter old) =>
      bands != old.bands || beatIntensity != old.beatIntensity || isBeat != old.isBeat;
}
