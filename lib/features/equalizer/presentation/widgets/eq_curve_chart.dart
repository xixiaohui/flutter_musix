import 'package:flutter/material.dart';

/// Renders an equalizer frequency response curve using CustomPainter.
class EqCurveChart extends StatelessWidget {
  const EqCurveChart({super.key, required this.gains});
  final List<double> gains;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: CustomPaint(
          painter: _EqCurvePainter(gains: gains, color: theme.colorScheme.primary),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _EqCurvePainter extends CustomPainter {
  final List<double> gains;
  final Color color;

  _EqCurvePainter({required this.gains, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (gains.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final w = size.width;
    final h = size.height;
    final stepX = w / (gains.length - 1);
    final midY = h / 2;
    final scaleY = h / 24; // -12 to +12 dB

    // Grid lines
    for (var i = -12; i <= 12; i += 6) {
      final y = midY - i * scaleY;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Draw filled curve
    final path = Path();
    path.moveTo(0, h);
    for (var i = 0; i < gains.length; i++) {
      final x = i * stepX;
      final y = midY - gains[i] * scaleY;
      path.lineTo(x, y);
    }
    path.lineTo(w, h);
    path.close();
    canvas.drawPath(path, paint);

    // Draw curve line
    final linePath = Path();
    for (var i = 0; i < gains.length; i++) {
      final x = i * stepX;
      final y = midY - gains[i] * scaleY;
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }
    }
    canvas.drawPath(linePath, linePaint);

    // Draw points
    final pointPaint = Paint()..color = color..style = PaintingStyle.fill;
    for (var i = 0; i < gains.length; i++) {
      final x = i * stepX;
      final y = midY - gains[i] * scaleY;
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant _EqCurvePainter oldDelegate) => gains != oldDelegate.gains;
}
