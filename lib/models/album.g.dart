// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlbumImpl _$$AlbumImplFromJson(Map<String, dynamic> json) => _$AlbumImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  artistId: (json['artistId'] as num?)?.toInt(),
  artistName: json['artistName'] as String?,
  cover: json['cover'] as String?,
  year: (json['year'] as num?)?.toInt(),
  genre: json['genre'] as String?,
  songCount: (json['songCount'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$AlbumImplToJson(_$AlbumImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artistId': instance.artistId,
      'artistName': instance.artistName,
      'cover': instance.cover,
      'year': instance.year,
      'genre': instance.genre,
      'songCount': instance.songCount,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
