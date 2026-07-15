import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/visualizer_provider.dart';

class CircularSpectrum extends ConsumerWidget {
  const CircularSpectrum({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(visualizerProvider);
    return CustomPaint(painter: _CircPainter(bands: s.frame.bands,
      beatIntensity: s.frame.beatIntensity, primaryColor: s.primaryColor,
      secondaryColor: s.secondaryColor, isBeat: s.frame.isBeat, tick: s.tick), size: Size.infinite);
  }
}

class _CircPainter extends CustomPainter {
  final List<double> bands; final double beatIntensity; final Color primaryColor;
  final Color secondaryColor; final bool isBeat; final int tick;
  _CircPainter({required this.bands, required this.beatIntensity, required this.primaryColor,
    required this.secondaryColor, required this.isBeat, required this.tick});

  @override
  void paint(Canvas canvas, Size size) {
    if (bands.isEmpty) return;
    final cx = size.width / 2, cy = size.height / 2;
    final maxR = math.min(cx, cy) * 0.8, minR = maxR * 0.25;
    final n = bands.length;
    canvas.drawCircle(Offset(cx, cy), maxR, Paint()..shader = RadialGradient(
      colors: [primaryColor.withValues(alpha: 0.15 + beatIntensity * 0.1), Colors.transparent])
      .createShader(Rect.fromCircle(center: Offset(cx, cy), radius: maxR)));
    if (beatIntensity > 0.3) canvas.drawCircle(Offset(cx, cy), maxR * (1.0 + beatIntensity * 0.15),
      Paint()..style = PaintingStyle.stroke..strokeWidth = 2.0 * beatIntensity
        ..color = secondaryColor.withValues(alpha: beatIntensity * 0.5));
    for (var i = 0; i < n; i++) {
      final a = (i / n) * 2 * math.pi - math.pi / 2;
      final h = bands[i].clamp(0.0, 1.0);
      final len = (maxR - minR) * h * (1.0 + beatIntensity * 0.12);
      final ix = cx + math.cos(a) * minR, iy = cy + math.sin(a) * minR;
      final ox = cx + math.cos(a) * (minR + len), oy = cy + math.sin(a) * (minR + len);
      canvas.drawLine(Offset(ix, iy), Offset(ox, oy), Paint()
        ..shader = LinearGradient(colors: [primaryColor.withValues(alpha: 0.3 + h * 0.5),
          HSLColor.fromColor(secondaryColor).withLightness((0.4 + h * 0.4).clamp(0.3, 0.8)).toColor()])
          .createShader(Rect.fromPoints(Offset(ix, iy), Offset(ox, oy)))
        ..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);
      if (h > 0.7) canvas.drawCircle(Offset(ox, oy), 3.0 * h,
        Paint()..color = secondaryColor.withValues(alpha: h)..style = PaintingStyle.fill);
    }
  }
  @override
  bool shouldRepaint(covariant _CircPainter o) => tick != o.tick || bands != o.bands;
}
