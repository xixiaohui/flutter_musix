import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required SearchResultType type,
    required String id,
    required String title,
    String? subtitle,
    String? imageUrl,
    String? route,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}

enum SearchResultType { song, album, artist, playlist }
