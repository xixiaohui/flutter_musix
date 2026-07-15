import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/visualizer_provider.dart';

class ParticleField extends ConsumerWidget {
  const ParticleField({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(visualizerProvider);
    return CustomPaint(painter: _PartPainter(bands: s.frame.bands,
      beatIntensity: s.frame.beatIntensity, primaryColor: s.primaryColor,
      secondaryColor: s.secondaryColor, isBeat: s.frame.isBeat, tick: s.tick), size: Size.infinite);
  }
}

class _PartPainter extends CustomPainter {
  final List<double> bands; final double beatIntensity; final Color primaryColor;
  final Color secondaryColor; final bool isBeat; final int tick;
  final math.Random _r = math.Random(42);
  final List<_P> _ps = [];

  _PartPainter({required this.bands, required this.beatIntensity, required this.primaryColor,
    required this.secondaryColor, required this.isBeat, required this.tick}) {
    if (_ps.isEmpty) for (var i = 0; i < 100; i++) _ps.add(_P(500 + _r.nextDouble() * 500, 300 + _r.nextDouble() * 300));
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (bands.isEmpty) return;
    final avg = bands.reduce((a, b) => a + b) / bands.length;
    final cx = size.width / 2, cy = size.height / 2;
    for (final p in _ps) {
      final dx = cx - p.x, dy = cy - p.y, dist = math.sqrt(dx * dx + dy * dy) + 0.1;
      final f = avg * 0.04 + beatIntensity * 0.06;
      p.vx += dx / dist * f; p.vy += dy / dist * f;
      p.vx += (_r.nextDouble() - 0.5) * avg * 0.3; p.vy += (_r.nextDouble() - 0.5) * avg * 0.3;
      p.vx *= 0.96; p.vy *= 0.96;
      p.x += p.vx; p.y += p.vy;
      if (p.x < -30) p.x = size.width + 30; if (p.x > size.width + 30) p.x = -30;
      if (p.y < -30) p.y = size.height + 30; if (p.y > size.height + 30) p.y = -30;
      p.life += isBeat ? 0.1 : 0.01; if (p.life > 2.0) p.life = 0;
      final lf = (math.sin(p.life * math.pi) + 1) / 2;
      final r = p.r * (1.0 + beatIntensity * 2.5) * (0.4 + lf * 0.6);
      final a = (0.15 + lf * 0.5 + avg * 0.35).clamp(0.1, 0.85);
      final c = Color.lerp(primaryColor, secondaryColor, (lf + avg) / 2)!;
      canvas.drawCircle(Offset(p.x, p.y), r, Paint()
        ..color = c.withValues(alpha: a)..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
      // Connections
      for (final o in _ps) {
        if (o == p) continue;
        final dd = math.sqrt((p.x - o.x) * (p.x - o.x) + (p.y - o.y) * (p.y - o.y));
        if (dd < 70 && avg > 0.25) canvas.drawLine(Offset(p.x, p.y), Offset(o.x, o.y),
          Paint()..color = secondaryColor.withValues(alpha: (1 - dd / 70) * avg * 0.25)
            ..style = PaintingStyle.stroke..strokeWidth = 0.6);
      }
    }
  }
  @override
  bool shouldRepaint(covariant _PartPainter o) => tick != o.tick || bands != o.bands;
}

class _P { double x, y, vx = 0, vy = 0; double r, life;
  _P(this.x, this.y) : r = 1.5 + math.Random().nextDouble() * 3.5, life = math.Random().nextDouble(); }
