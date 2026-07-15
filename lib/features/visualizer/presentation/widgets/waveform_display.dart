import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/visualizer_provider.dart';

class WaveformDisplay extends ConsumerWidget {
  const WaveformDisplay({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(visualizerProvider);
    return ClipRRect(borderRadius: BorderRadius.circular(24),
      child: CustomPaint(painter: _WavePainter(wf: s.frame.waveform,
        beatIntensity: s.frame.beatIntensity, primaryColor: s.primaryColor,
        secondaryColor: s.secondaryColor, isBeat: s.frame.isBeat, tick: s.tick), size: Size.infinite));
  }
}

class _WavePainter extends CustomPainter {
  final List<double> wf; final double beatIntensity; final Color primaryColor;
  final Color secondaryColor; final bool isBeat; final int tick;
  _WavePainter({required this.wf, required this.beatIntensity, required this.primaryColor,
    required this.secondaryColor, required this.isBeat, required this.tick});

  @override
  void paint(Canvas canvas, Size size) {
    if (wf.isEmpty) return;
    final mid = size.height / 2, sx = size.width / (wf.length - 1);
    final amp = size.height * 0.45 * (1.0 + beatIntensity * 0.2);
    final p = Path(); p.moveTo(0, mid);
    for (var i = 0; i < wf.length; i++) p.lineTo(i * sx, mid + wf[i] * amp);
    p.lineTo(size.width, mid); p.close();
    canvas.drawPath(p, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [primaryColor.withValues(alpha: 0.5), primaryColor.withValues(alpha: 0.05)])
      .createShader(Rect.fromLTWH(0, mid - amp, size.width, amp * 2))..style = PaintingStyle.fill);
    final lp = Path();
    for (var i = 0; i < wf.length; i++) {
      if (i == 0) lp.moveTo(i * sx, mid + wf[i] * amp);
      else lp.lineTo(i * sx, mid + wf[i] * amp);
    }
    canvas.drawPath(lp, Paint()..shader = LinearGradient(colors: [secondaryColor, primaryColor])
      .createShader(Rect.fromLTWH(0, 0, size.width, size.height))..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 + beatIntensity * 1.5..strokeCap = StrokeCap.round);
    canvas.drawPath(lp, Paint()..color = secondaryColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke..strokeWidth = 8.0..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
  }
  @override
  bool shouldRepaint(covariant _WavePainter o) => tick != o.tick || wf != o.wf;
}
