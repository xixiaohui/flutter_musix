import 'package:flutter/material.dart';

/// A reusable album/song cover art widget with Hero support.
///
/// Supports placeholder, error fallback, and Hero animation tag.
class CoverArt extends StatelessWidget {
  const CoverArt({
    super.key,
    this.url,
    this.size = 48,
    this.borderRadius = 8,
    this.heroTag,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final double size;
  final double borderRadius;
  final String? heroTag;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final image = _buildImage();

    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        child: Material(
          color: Colors.transparent,
          child: image,
        ),
      );
    }

    return image;
  }

  Widget _buildImage() {
    if (url == null || url!.isEmpty) {
      return _buildPlaceholder();
    }

    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: url!.startsWith('http')
            ? Image.network(
                url!,
                fit: fit,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return _buildPlaceholder();
                },
              )
            : Image.asset(
                url!,
                fit: fit,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.grey.withValues(alpha: 0.2),
      ),
      child: const Icon(Icons.music_note, color: Colors.grey),
    );
  }
}
