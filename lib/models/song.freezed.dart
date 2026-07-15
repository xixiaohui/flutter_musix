// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Song _$SongFromJson(Map<String, dynamic> json) {
  return _Song.fromJson(json);
}

/// @nodoc
mixin _$Song {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int? get artistId => throw _privateConstructorUsedError;
  String? get artistName => throw _privateConstructorUsedError;
  int? get albumId => throw _privateConstructorUsedError;
  String? get albumName => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get localPath => throw _privateConstructorUsedError;
  String? get cover => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  int? get size => throw _privateConstructorUsedError;
  int? get trackNumber => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isLocal => throw _privateConstructorUsedError;
  bool get isDownloaded => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Song to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Song
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SongCopyWith<Song> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongCopyWith<$Res> {
  factory $SongCopyWith(Song value, $Res Function(Song) then) =
      _$SongCopyWithImpl<$Res, Song>;
  @useResult
  $Res call({
    int id,
    String title,
    int? artistId,
    String? artistName,
    int? albumId,
    String? albumName,
    String? url,
    String? localPath,
    String? cover,
    String format,
    int? duration,
    int? size,
    int? trackNumber,
    bool isFavorite,
    bool isLocal,
    bool isDownloaded,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$SongCopyWithImpl<$Res, $Val extends Song>
    implements $SongCopyWith<$Res> {
  _$SongCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Song
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artistId = freezed,
    Object? artistName = freezed,
    Object? albumId = freezed,
    Object? albumName = freezed,
    Object? url = freezed,
    Object? localPath = freezed,
    Object? cover = freezed,
    Object? format = null,
    Object? duration = freezed,
    Object? size = freezed,
    Object? trackNumber = freezed,
    Object? isFavorite = null,
    Object? isLocal = null,
    Object? isDownloaded = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            artistId: freezed == artistId
                ? _value.artistId
                : artistId // ignore: cast_nullable_to_non_nullable
                      as int?,
            artistName: freezed == artistName
                ? _value.artistName
                : artistName // ignore: cast_nullable_to_non_nullable
                      as String?,
            albumId: freezed == albumId
                ? _value.albumId
                : albumId // ignore: cast_nullable_to_non_nullable
                      as int?,
            albumName: freezed == albumName
                ? _value.albumName
                : albumName // ignore: cast_nullable_to_non_nullable
                      as String?,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            localPath: freezed == localPath
                ? _value.localPath
                : localPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            cover: freezed == cover
                ? _value.cover
                : cover // ignore: cast_nullable_to_non_nullable
                      as String?,
            format: null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int?,
            size: freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int?,
            trackNumber: freezed == trackNumber
                ? _value.trackNumber
                : trackNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLocal: null == isLocal
                ? _value.isLocal
                : isLocal // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDownloaded: null == isDownloaded
                ? _value.isDownloaded
                : isDownloaded // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SongImplCopyWith<$Res> implements $SongCopyWith<$Res> {
  factory _$$SongImplCopyWith(
    _$SongImpl value,
    $Res Function(_$SongImpl) then,
  ) = __$$SongImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    int? artistId,
    String? artistName,
    int? albumId,
    String? albumName,
    String? url,
    String? localPath,
    String? cover,
    String format,
    int? duration,
    int? size,
    int? trackNumber,
    bool isFavorite,
    bool isLocal,
    bool isDownloaded,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$SongImplCopyWithImpl<$Res>
    extends _$SongCopyWithImpl<$Res, _$SongImpl>
    implements _$$SongImplCopyWith<$Res> {
  __$$SongImplCopyWithImpl(_$SongImpl _value, $Res Function(_$SongImpl) _then)
    : super(_value, _then);

  /// Create a copy of Song
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artistId = freezed,
    Object? artistName = freezed,
    Object? albumId = freezed,
    Object? albumName = freezed,
    Object? url = freezed,
    Object? localPath = freezed,
    Object? cover = freezed,
    Object? format = null,
    Object? duration = freezed,
    Object? size = freezed,
    Object? trackNumber = freezed,
    Object? isFavorite = null,
    Object? isLocal = null,
    Object? isDownloaded = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SongImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        artistId: freezed == artistId
            ? _value.artistId
            : artistId // ignore: cast_nullable_to_non_nullable
                  as int?,
        artistName: freezed == artistName
            ? _value.artistName
            : artistName // ignore: cast_nullable_to_non_nullable
                  as String?,
        albumId: freezed == albumId
            ? _value.albumId
            : albumId // ignore: cast_nullable_to_non_nullable
                  as int?,
        albumName: freezed == albumName
            ? _value.albumName
            : albumName // ignore: cast_nullable_to_non_nullable
                  as String?,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        localPath: freezed == localPath
            ? _value.localPath
            : localPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        cover: freezed == cover
            ? _value.cover
            : cover // ignore: cast_nullable_to_non_nullable
                  as String?,
        format: null == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        size: freezed == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int?,
        trackNumber: freezed == trackNumber
            ? _value.trackNumber
            : trackNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLocal: null == isLocal
            ? _value.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDownloaded: null == isDownloaded
            ? _value.isDownloaded
            : isDownloaded // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SongImpl implements _Song {
  const _$SongImpl({
    required this.id,
    required this.title,
    this.artistId,
    this.artistName,
    this.albumId,
    this.albumName,
    this.url,
    this.localPath,
    this.cover,
    this.format = 'mp3',
    this.duration,
    this.size,
    this.trackNumber,
    this.isFavorite = false,
    this.isLocal = false,
    this.isDownloaded = false,
    this.createdAt,
  });

  factory _$SongImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final int? artistId;
  @override
  final String? artistName;
  @override
  final int? albumId;
  @override
  final String? albumName;
  @override
  final String? url;
  @override
  final String? localPath;
  @override
  final String? cover;
  @override
  @JsonKey()
  final String format;
  @override
  final int? duration;
  @override
  final int? size;
  @override
  final int? trackNumber;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final bool isLocal;
  @override
  @JsonKey()
  final bool isDownloaded;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artistId: $artistId, artistName: $artistName, albumId: $albumId, albumName: $albumName, url: $url, localPath: $localPath, cover: $cover, format: $format, duration: $duration, size: $size, trackNumber: $trackNumber, isFavorite: $isFavorite, isLocal: $isLocal, isDownloaded: $isDownloaded, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artistId, artistId) ||
                other.artistId == artistId) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.albumName, albumName) ||
                other.albumName == albumName) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.trackNumber, trackNumber) ||
                other.trackNumber == trackNumber) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal) &&
            (identical(other.isDownloaded, isDownloaded) ||
                other.isDownloaded == isDownloaded) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    artistId,
    artistName,
    albumId,
    albumName,
    url,
    localPath,
    cover,
    format,
    duration,
    size,
    trackNumber,
    isFavorite,
    isLocal,
    isDownloaded,
    createdAt,
  );

  /// Create a copy of Song
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SongImplCopyWith<_$SongImpl> get copyWith =>
      __$$SongImplCopyWithImpl<_$SongImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongImplToJson(this);
  }
}

abstract class _Song implements Song {
  const factory _Song({
    required final int id,
    required final String title,
    final int? artistId,
    final String? artistName,
    final int? albumId,
    final String? albumName,
    final String? url,
    final String? localPath,
    final String? cover,
    final String format,
    final int? duration,
    final int? size,
    final int? trackNumber,
    final bool isFavorite,
    final bool isLocal,
    final bool isDownloaded,
    final DateTime? createdAt,
  }) = _$SongImpl;

  factory _Song.fromJson(Map<String, dynamic> json) = _$SongImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  int? get artistId;
  @override
  String? get artistName;
  @override
  int? get albumId;
  @override
  String? get albumName;
  @override
  String? get url;
  @override
  String? get localPath;
  @override
  String? get cover;
  @override
  String get format;
  @override
  int? get duration;
  @override
  int? get size;
  @override
  int? get trackNumber;
  @override
  bool get isFavorite;
  @override
  bool get isLocal;
  @override
  bool get isDownloaded;
  @override
  DateTime? get createdAt;

  /// Create a copy of Song
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SongImplCopyWith<_$SongImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
