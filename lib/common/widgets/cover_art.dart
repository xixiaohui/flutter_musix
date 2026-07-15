import 'package:flutter/material.dart';

import '../../core/utils/album_art_helper.dart';

/// A reusable album/song cover art widget with Hero support.
///
/// Falls back to picsum.photos for placeholder images instead of grey boxes.
class CoverArt extends StatelessWidget {
  const CoverArt({
    super.key,
    this.url,
    this.size = 48,
    this.borderRadius = 8,
    this.heroTag,
    this.fit = BoxFit.cover,
    this.fallbackSeed,
  });

  final String? url;
  final double size;
  final double borderRadius;
  final String? heroTag;
  final BoxFit fit;
  /// Seed for picsum fallback — generates a unique stable image.
  final String? fallbackSeed;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (url != null && url!.isNotEmpty)
        ? url!
        : fallbackSeed != null
            ? AlbumArtHelper.generic(fallbackSeed!, w: size.round(), h: size.round())
            : null;

    final image = SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: fit,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return _buildPlaceholder();
                },
                cacheWidth: size.round(),
                cacheHeight: size.round(),
              )
            : _buildPlaceholder(),
      ),
    );

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: Material(color: Colors.transparent, child: image));
    }
    return image;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D3A), Color(0xFF1C1C26)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(Icons.music_note, color: Color(0xFF555566), size: 24),
    );
  }
}
