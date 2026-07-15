// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lyric_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LyricLine _$LyricLineFromJson(Map<String, dynamic> json) {
  return _LyricLine.fromJson(json);
}

/// @nodoc
mixin _$LyricLine {
  Duration get timestamp => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String? get translatedText => throw _privateConstructorUsedError;
  List<LyricWord> get words => throw _privateConstructorUsedError;

  /// Serializes this LyricLine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LyricLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LyricLineCopyWith<LyricLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LyricLineCopyWith<$Res> {
  factory $LyricLineCopyWith(LyricLine value, $Res Function(LyricLine) then) =
      _$LyricLineCopyWithImpl<$Res, LyricLine>;
  @useResult
  $Res call({
    Duration timestamp,
    String text,
    String? translatedText,
    List<LyricWord> words,
  });
}

/// @nodoc
class _$LyricLineCopyWithImpl<$Res, $Val extends LyricLine>
    implements $LyricLineCopyWith<$Res> {
  _$LyricLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LyricLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? text = null,
    Object? translatedText = freezed,
    Object? words = null,
  }) {
    return _then(
      _value.copyWith(
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as Duration,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            translatedText: freezed == translatedText
                ? _value.translatedText
                : translatedText // ignore: cast_nullable_to_non_nullable
                      as String?,
            words: null == words
                ? _value.words
                : words // ignore: cast_nullable_to_non_nullable
                      as List<LyricWord>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LyricLineImplCopyWith<$Res>
    implements $LyricLineCopyWith<$Res> {
  factory _$$LyricLineImplCopyWith(
    _$LyricLineImpl value,
    $Res Function(_$LyricLineImpl) then,
  ) = __$$LyricLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Duration timestamp,
    String text,
    String? translatedText,
    List<LyricWord> words,
  });
}

/// @nodoc
class __$$LyricLineImplCopyWithImpl<$Res>
    extends _$LyricLineCopyWithImpl<$Res, _$LyricLineImpl>
    implements _$$LyricLineImplCopyWith<$Res> {
  __$$LyricLineImplCopyWithImpl(
    _$LyricLineImpl _value,
    $Res Function(_$LyricLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LyricLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? text = null,
    Object? translatedText = freezed,
    Object? words = null,
  }) {
    return _then(
      _$LyricLineImpl(
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as Duration,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        translatedText: freezed == translatedText
            ? _value.translatedText
            : translatedText // ignore: cast_nullable_to_non_nullable
                  as String?,
        words: null == words
            ? _value._words
            : words // ignore: cast_nullable_to_non_nullable
                  as List<LyricWord>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LyricLineImpl implements _LyricLine {
  const _$LyricLineImpl({
    required this.timestamp,
    required this.text,
    this.translatedText,
    final List<LyricWord> words = const [],
  }) : _words = words;

  factory _$LyricLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$LyricLineImplFromJson(json);

  @override
  final Duration timestamp;
  @override
  final String text;
  @override
  final String? translatedText;
  final List<LyricWord> _words;
  @override
  @JsonKey()
  List<LyricWord> get words {
    if (_words is EqualUnmodifiableListView) return _words;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_words);
  }

  @override
  String toString() {
    return 'LyricLine(timestamp: $timestamp, text: $text, translatedText: $translatedText, words: $words)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LyricLineImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.translatedText, translatedText) ||
                other.translatedText == translatedText) &&
            const DeepCollectionEquality().equals(other._words, _words));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    timestamp,
    text,
    translatedText,
    const DeepCollectionEquality().hash(_words),
  );

  /// Create a copy of LyricLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LyricLineImplCopyWith<_$LyricLineImpl> get copyWith =>
      __$$LyricLineImplCopyWithImpl<_$LyricLineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LyricLineImplToJson(this);
  }
}

abstract class _LyricLine implements LyricLine {
  const factory _LyricLine({
    required final Duration timestamp,
    required final String text,
    final String? translatedText,
    final List<LyricWord> words,
  }) = _$LyricLineImpl;

  factory _LyricLine.fromJson(Map<String, dynamic> json) =
      _$LyricLineImpl.fromJson;

  @override
  Duration get timestamp;
  @override
  String get text;
  @override
  String? get translatedText;
  @override
  List<LyricWord> get words;

  /// Create a copy of LyricLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LyricLineImplCopyWith<_$LyricLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LyricWord _$LyricWordFromJson(Map<String, dynamic> json) {
  return _LyricWord.fromJson(json);
}

/// @nodoc
mixin _$LyricWord {
  Duration get startTime => throw _privateConstructorUsedError;
  Duration get endTime => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  /// Serializes this LyricWord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LyricWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LyricWordCopyWith<LyricWord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LyricWordCopyWith<$Res> {
  factory $LyricWordCopyWith(LyricWord value, $Res Function(LyricWord) then) =
      _$LyricWordCopyWithImpl<$Res, LyricWord>;
  @useResult
  $Res call({Duration startTime, Duration endTime, String text});
}

/// @nodoc
class _$LyricWordCopyWithImpl<$Res, $Val extends LyricWord>
    implements $LyricWordCopyWith<$Res> {
  _$LyricWordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LyricWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? text = null,
  }) {
    return _then(
      _value.copyWith(
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as Duration,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as Duration,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LyricWordImplCopyWith<$Res>
    implements $LyricWordCopyWith<$Res> {
  factory _$$LyricWordImplCopyWith(
    _$LyricWordImpl value,
    $Res Function(_$LyricWordImpl) then,
  ) = __$$LyricWordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Duration startTime, Duration endTime, String text});
}

/// @nodoc
class __$$LyricWordImplCopyWithImpl<$Res>
    extends _$LyricWordCopyWithImpl<$Res, _$LyricWordImpl>
    implements _$$LyricWordImplCopyWith<$Res> {
  __$$LyricWordImplCopyWithImpl(
    _$LyricWordImpl _value,
    $Res Function(_$LyricWordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LyricWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? text = null,
  }) {
    return _then(
      _$LyricWordImpl(
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as Duration,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as Duration,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LyricWordImpl implements _LyricWord {
  const _$LyricWordImpl({
    required this.startTime,
    required this.endTime,
    required this.text,
  });

  factory _$LyricWordImpl.fromJson(Map<String, dynamic> json) =>
      _$$LyricWordImplFromJson(json);

  @override
  final Duration startTime;
  @override
  final Duration endTime;
  @override
  final String text;

  @override
  String toString() {
    return 'LyricWord(startTime: $startTime, endTime: $endTime, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LyricWordImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startTime, endTime, text);

  /// Create a copy of LyricWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LyricWordImplCopyWith<_$LyricWordImpl> get copyWith =>
      __$$LyricWordImplCopyWithImpl<_$LyricWordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LyricWordImplToJson(this);
  }
}

abstract class _LyricWord implements LyricWord {
  const factory _LyricWord({
    required final Duration startTime,
    required final Duration endTime,
    required final String text,
  }) = _$LyricWordImpl;

  factory _LyricWord.fromJson(Map<String, dynamic> json) =
      _$LyricWordImpl.fromJson;

  @override
  Duration get startTime;
  @override
  Duration get endTime;
  @override
  String get text;

  /// Create a copy of LyricWord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LyricWordImplCopyWith<_$LyricWordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
