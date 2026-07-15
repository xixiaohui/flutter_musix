/// Generates consistent random album art URLs from picsum.photos.
///
/// Each seed produces a unique but stable image — same seed = same image.
class AlbumArtHelper {
  const AlbumArtHelper._();

  /// Base URL for picsum photos.
  static const _base = 'https://picsum.photos';

  /// Get an album art URL for a song.
  /// Uses the song title + artist as seed for stable images.
  static String songCover(String title, String artist, {int w = 200, int h = 200}) {
    final seed = '${title}_$artist'.replaceAll(' ', '_');
    return '$_base/seed/${Uri.encodeComponent(seed)}/$w/$h';
  }

  /// Get an artist image URL.
  static String artistImage(String name, {int w = 200, int h = 200}) {
    final seed = 'artist_$name'.replaceAll(' ', '_');
    return '$_base/seed/${Uri.encodeComponent(seed)}/$w/$h';
  }

  /// Get an album cover URL.
  static String albumCover(String name, {int w = 300, int h = 300}) {
    final seed = 'album_$name'.replaceAll(' ', '_');
    return '$_base/seed/${Uri.encodeComponent(seed)}/$w/$h';
  }

  /// Get a generic music-themed random cover.
  static String generic(String seed, {int w = 200, int h = 200}) {
    return '$_base/seed/${Uri.encodeComponent(seed)}/$w/$h';
  }

  /// Get a random image with specific ID.
  static String byId(int id, {int w = 200, int h = 200}) {
    return '$_base/id/$id/$w/$h';
  }

  /// Get a completely random image (different each time).
  static String random({int w = 200, int h = 200}) {
    return '$_base/$w/$h?random=${DateTime.now().millisecondsSinceEpoch}';
  }
}
