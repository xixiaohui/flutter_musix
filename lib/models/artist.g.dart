// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArtistImpl _$$ArtistImplFromJson(Map<String, dynamic> json) => _$ArtistImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  image: json['image'] as String?,
  bio: json['bio'] as String?,
  genre: json['genre'] as String?,
  albumCount: (json['albumCount'] as num?)?.toInt() ?? 0,
  songCount: (json['songCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ArtistImplToJson(_$ArtistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'bio': instance.bio,
      'genre': instance.genre,
      'albumCount': instance.albumCount,
      'songCount': instance.songCount,
    };
