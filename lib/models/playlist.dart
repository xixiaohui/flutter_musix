import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist.freezed.dart';
part 'playlist.g.dart';

@freezed
class Playlist with _$Playlist {
  const factory Playlist({
    required int id,
    required String name,
    String? cover,
    String? description,
    @Default(0) int sortOrder,
    @Default(0) int songCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Playlist;

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
}
