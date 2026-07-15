import 'dart:ui';
import 'package:flutter/material.dart';

/// A glassmorphic container with backdrop blur.
///
/// Used for Mini Player, Now Playing background, Lyrics background, etc.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.blurSigma = 20,
    this.opacity = 0.2,
    this.borderOpacity = 0.1,
    this.padding,
    this.margin,
    this.gradient,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blurSigma;
  final double opacity;
  final double borderOpacity;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient,
        border: Border.all(
          color: Colors.white.withValues(alpha: borderOpacity),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: opacity),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
