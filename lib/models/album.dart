import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';
part 'album.g.dart';

@freezed
class Album with _$Album {
  const factory Album({
    required int id,
    required String name,
    int? artistId,
    String? artistName,
    String? cover,
    int? year,
    String? genre,
    @Default(0) int songCount,
    DateTime? createdAt,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}
