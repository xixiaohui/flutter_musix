// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyric_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LyricLineImpl _$$LyricLineImplFromJson(Map<String, dynamic> json) =>
    _$LyricLineImpl(
      timestamp: Duration(microseconds: (json['timestamp'] as num).toInt()),
      text: json['text'] as String,
      translatedText: json['translatedText'] as String?,
      words:
          (json['words'] as List<dynamic>?)
              ?.map((e) => LyricWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$LyricLineImplToJson(_$LyricLineImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.inMicroseconds,
      'text': instance.text,
      'translatedText': instance.translatedText,
      'words': instance.words,
    };

_$LyricWordImpl _$$LyricWordImplFromJson(Map<String, dynamic> json) =>
    _$LyricWordImpl(
      startTime: Duration(microseconds: (json['startTime'] as num).toInt()),
      endTime: Duration(microseconds: (json['endTime'] as num).toInt()),
      text: json['text'] as String,
    );

Map<String, dynamic> _$$LyricWordImplToJson(_$LyricWordImpl instance) =>
    <String, dynamic>{
      'startTime': instance.startTime.inMicroseconds,
      'endTime': instance.endTime.inMicroseconds,
      'text': instance.text,
    };
