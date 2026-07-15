import 'package:freezed_annotation/freezed_annotation.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song with _$Song {
  const factory Song({
    required int id,
    required String title,
    int? artistId,
    String? artistName,
    int? albumId,
    String? albumName,
    String? url,
    String? localPath,
    String? cover,
    @Default('mp3') String format,
    int? duration,
    int? size,
    int? trackNumber,
    @Default(false) bool isFavorite,
    @Default(false) bool isLocal,
    @Default(false) bool isDownloaded,
    DateTime? createdAt,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}
