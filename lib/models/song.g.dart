// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongImpl _$$SongImplFromJson(Map<String, dynamic> json) => _$SongImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  artistId: (json['artistId'] as num?)?.toInt(),
  artistName: json['artistName'] as String?,
  albumId: (json['albumId'] as num?)?.toInt(),
  albumName: json['albumName'] as String?,
  url: json['url'] as String?,
  localPath: json['localPath'] as String?,
  cover: json['cover'] as String?,
  format: json['format'] as String? ?? 'mp3',
  duration: (json['duration'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  trackNumber: (json['trackNumber'] as num?)?.toInt(),
  isFavorite: json['isFavorite'] as bool? ?? false,
  isLocal: json['isLocal'] as bool? ?? false,
  isDownloaded: json['isDownloaded'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$SongImplToJson(_$SongImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artistId': instance.artistId,
      'artistName': instance.artistName,
      'albumId': instance.albumId,
      'albumName': instance.albumName,
      'url': instance.url,
      'localPath': instance.localPath,
      'cover': instance.cover,
      'format': instance.format,
      'duration': instance.duration,
      'size': instance.size,
      'trackNumber': instance.trackNumber,
      'isFavorite': instance.isFavorite,
      'isLocal': instance.isLocal,
      'isDownloaded': instance.isDownloaded,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
