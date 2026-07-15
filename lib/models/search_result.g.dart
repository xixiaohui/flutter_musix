// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchResultImpl _$$SearchResultImplFromJson(Map<String, dynamic> json) =>
    _$SearchResultImpl(
      type: $enumDecode(_$SearchResultTypeEnumMap, json['type']),
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['imageUrl'] as String?,
      route: json['route'] as String?,
    );

Map<String, dynamic> _$$SearchResultImplToJson(_$SearchResultImpl instance) =>
    <String, dynamic>{
      'type': _$SearchResultTypeEnumMap[instance.type]!,
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'imageUrl': instance.imageUrl,
      'route': instance.route,
    };

const _$SearchResultTypeEnumMap = {
  SearchResultType.song: 'song',
  SearchResultType.album: 'album',
  SearchResultType.artist: 'artist',
  SearchResultType.playlist: 'playlist',
};
