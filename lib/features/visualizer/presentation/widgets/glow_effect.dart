import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/visualizer_provider.dart';

class GlowEffect extends ConsumerWidget {
  const GlowEffect({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(visualizerProvider);
    return CustomPaint(painter: _GPainter(bands: s.frame.bands,
      beatIntensity: s.frame.beatIntensity, primaryColor: s.primaryColor,
      secondaryColor: s.secondaryColor, isBeat: s.frame.isBeat,
      amplitude: s.frame.amplitude, tick: s.tick), size: Size.infinite);
  }
}

class _GPainter extends CustomPainter {
  final List<double> bands; final double beatIntensity; final Color primaryColor;
  final Color secondaryColor; final bool isBeat; final double amplitude; final int tick;

  _GPainter({required this.bands, required this.beatIntensity, required this.primaryColor,
    required this.secondaryColor, required this.isBeat, required this.amplitude, required this.tick});

  @override
  void paint(Canvas canvas, Size size) {
    if (bands.isEmpty) return;
    final cx = size.width / 2, cy = size.height / 2;
    final avg = bands.reduce((a, b) => a + b) / bands.length;
    final energy = (avg + beatIntensity) / 2;
    final phase = tick * 0.025;

    canvas.drawCircle(Offset(cx, cy), size.width, Paint()..shader = RadialGradient(
      colors: [primaryColor.withValues(alpha: 0.06 + energy * 0.12), Colors.transparent])
      .createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.8)));
    canvas.drawCircle(Offset(cx, cy), size.width * 0.3 * (1.0 + beatIntensity * 0.5), Paint()
      ..shader = RadialGradient(colors: [secondaryColor.withValues(alpha: 0.12 + beatIntensity * 0.1),
        primaryColor.withValues(alpha: 0.06), Colors.transparent], stops: const [0.0, 0.4, 1.0])
        .createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.3)));

    for (var i = 0; i < 3; i++) {
      final angle = phase * (i + 1) * 0.7 + i * 2.1;
      final or = size.width * 0.25 * (1.0 + avg * 0.5);
      final sx = cx + math.cos(angle) * or, sy = cy + math.sin(angle) * or;
      final sz = 60 + amplitude * 50 + beatIntensity * 30;
      canvas.drawCircle(Offset(sx, sy), sz * 1.5, Paint()..shader = RadialGradient(
        colors: [secondaryColor.withValues(alpha: 0.15), Colors.transparent])
        .createShader(Rect.fromCircle(center: Offset(sx, sy), radius: sz * 1.5)));
      canvas.drawCircle(Offset(sx, sy), sz * 0.2,
        Paint()..color = secondaryColor.withValues(alpha: 0.3 + energy * 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    }
    if (isBeat) {
      final fs = size.width * 0.6 * beatIntensity;
      canvas.drawCircle(Offset(cx, cy), fs, Paint()..shader = RadialGradient(
        colors: [Colors.white.withValues(alpha: 0.08 * beatIntensity), Colors.transparent])
        .createShader(Rect.fromCircle(center: Offset(cx, cy), radius: fs)));
    }
  }
  @override
  bool shouldRepaint(covariant _GPainter o) => tick != o.tick || bands != o.bands;
}
