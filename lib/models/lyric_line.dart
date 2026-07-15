import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyric_line.freezed.dart';
part 'lyric_line.g.dart';

@freezed
class LyricLine with _$LyricLine {
  const factory LyricLine({
    required Duration timestamp,
    required String text,
    String? translatedText,
    @Default([]) List<LyricWord> words,
  }) = _LyricLine;

  factory LyricLine.fromJson(Map<String, dynamic> json) =>
      _$LyricLineFromJson(json);
}

@freezed
class LyricWord with _$LyricWord {
  const factory LyricWord({
    required Duration startTime,
    required Duration endTime,
    required String text,
  }) = _LyricWord;

  factory LyricWord.fromJson(Map<String, dynamic> json) =>
      _$LyricWordFromJson(json);
}
