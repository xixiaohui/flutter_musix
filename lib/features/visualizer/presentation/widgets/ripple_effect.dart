import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/visualizer_provider.dart';

class RippleEffect extends ConsumerWidget {
  const RippleEffect({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(visualizerProvider);
    return CustomPaint(painter: _RipPainter(bands: s.frame.bands,
      beatIntensity: s.frame.beatIntensity, primaryColor: s.primaryColor,
      secondaryColor: s.secondaryColor, isBeat: s.frame.isBeat,
      amplitude: s.frame.amplitude, tick: s.tick), size: Size.infinite);
  }
}

class _RipPainter extends CustomPainter {
  final List<double> bands; final double beatIntensity; final Color primaryColor;
  final Color secondaryColor; final bool isBeat; final double amplitude; final int tick;
  final math.Random _r = math.Random(99);
  final List<_Rp> _ripples = [];

  _RipPainter({required this.bands, required this.beatIntensity, required this.primaryColor,
    required this.secondaryColor, required this.isBeat, required this.amplitude, required this.tick});

  @override
  void paint(Canvas canvas, Size size) {
    if (bands.isEmpty) return;
    final cx = size.width / 2, cy = size.height / 2;
    final maxR = math.sqrt(cx * cx + cy * cy);
    final avg = bands.reduce((a, b) => a + b) / bands.length;
    final frame = tick;

    if (isBeat && frame % 3 == 0) _ripples.add(_Rp(cx + (_r.nextDouble() - 0.5) * size.width * 0.3,
      cy + (_r.nextDouble() - 0.5) * size.height * 0.3, beatIntensity));
    if (frame % 12 == 0 && amplitude > 0.2) _ripples.add(_Rp(cx + (_r.nextDouble() - 0.5) * size.width * 0.4,
      cy + (_r.nextDouble() - 0.5) * size.height * 0.4, amplitude * 0.7));
    while (_ripples.length > 25) _ripples.removeAt(0);

    canvas.drawCircle(Offset(cx, cy), maxR, Paint()..shader = RadialGradient(
      colors: [primaryColor.withValues(alpha: 0.03 + avg * 0.05), Colors.transparent])
      .createShader(Rect.fromCircle(center: Offset(cx, cy), radius: maxR)));

    for (final r in List<_Rp>.from(_ripples)) {
      r.radius += 2.2 + avg * 3.5 + r.intensity * 4.5;
      r.life -= 0.005 * (1.0 + avg);
      if (r.life <= 0) { _ripples.remove(r); continue; }
      final a = r.life * 0.45; final sw = r.intensity * 7 + avg * 3;
      canvas.drawCircle(Offset(r.x, r.y), r.radius, Paint()
        ..style = PaintingStyle.stroke..strokeWidth = sw
        ..color = secondaryColor.withValues(alpha: a.clamp(0.0, 0.5))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, sw * 0.5));
      if (r.intensity > 0.4) canvas.drawCircle(Offset(r.x, r.y), r.radius * 0.85, Paint()
        ..style = PaintingStyle.stroke..strokeWidth = sw * 0.4
        ..color = primaryColor.withValues(alpha: a.clamp(0.0, 0.3)));
    }
  }
  @override
  bool shouldRepaint(covariant _RipPainter o) => tick != o.tick || bands != o.bands;
}
class _Rp { double x, y, radius = 0, intensity, life = 1.0; _Rp(this.x, this.y, this.intensity); }
