import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/visualizer_provider.dart';

class BarSpectrum extends ConsumerWidget {
  const BarSpectrum({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(visualizerProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: CustomPaint(
        painter: _BarPainter(bands: s.frame.bands, beatIntensity: s.frame.beatIntensity,
          primaryColor: s.primaryColor, secondaryColor: s.secondaryColor,
          isBeat: s.frame.isBeat, tick: s.tick),
        size: Size.infinite,
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  final List<double> bands; final double beatIntensity; final Color primaryColor;
  final Color secondaryColor; final bool isBeat; final int tick;
  _BarPainter({required this.bands, required this.beatIntensity, required this.primaryColor,
    required this.secondaryColor, required this.isBeat, required this.tick});

  @override
  void paint(Canvas canvas, Size size) {
    if (bands.isEmpty) return;
    final n = bands.length;
    final bw = size.width / n * 0.7, gap = size.width / n * 0.3;
    final maxH = size.height * 0.85, baseY = size.height;
    if (isBeat) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()
        ..shader = RadialGradient(colors: [primaryColor.withValues(alpha: 0.08 * beatIntensity), Colors.transparent])
            .createShader(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width * 0.7)));
    }
    for (var i = 0; i < n; i++) {
      final x = i * (bw + gap) + gap / 2;
      final h = bands[i].clamp(0.0, 1.0) * maxH * (1.0 + beatIntensity * 0.15);
      final y = baseY - h, r = bw * 0.4;
      canvas.drawRRect(RRect.fromLTRBR(x, y, x + bw, baseY, Radius.circular(r)),
        Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [HSLColor.fromColor(secondaryColor).withLightness((0.5 + bands[i] * 0.3).clamp(0.3, 0.8)).toColor(),
            primaryColor.withValues(alpha: 0.4)]).createShader(Rect.fromLTWH(x, y, bw, h))
          ..style = PaintingStyle.fill);
      if (bands[i] > 0.6) canvas.drawCircle(Offset(x + bw / 2, y), bw * 1.5, Paint()
        ..shader = RadialGradient(colors: [secondaryColor.withValues(alpha: 0.3 * bands[i]), Colors.transparent])
            .createShader(Rect.fromCircle(center: Offset(x + bw / 2, y), radius: bw * 1.5)));
    }
  }
  @override
  bool shouldRepaint(covariant _BarPainter o) => tick != o.tick || bands != o.bands;
}
