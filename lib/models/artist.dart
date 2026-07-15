import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist.freezed.dart';
part 'artist.g.dart';

@freezed
class Artist with _$Artist {
  const factory Artist({
    required int id,
    required String name,
    String? image,
    String? bio,
    String? genre,
    @Default(0) int albumCount,
    @Default(0) int songCount,
  }) = _Artist;

  factory Artist.fromJson(Map<String, dynamic> json) =>
      _$ArtistFromJson(json);
}
