import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Data source that reads music data from the bundled JSON file.
///
/// Loads [json/musics.json] and parses it into a list of raw music entries.
/// Each entry contains: title, author, time, url, type.
class MusicJsonDataSource {
  /// Loads and parses the bundled JSON music data.
  Future<List<MusicJsonEntry>> loadMusicData() async {
    final jsonString = await rootBundle.loadString('json/musics.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => MusicJsonEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

/// Raw music entry from the JSON file.
class MusicJsonEntry {
  final String title;
  final String author;
  final String time;
  final String url;
  final String type;

  const MusicJsonEntry({
    required this.title,
    required this.author,
    required this.time,
    required this.url,
    required this.type,
  });

  factory MusicJsonEntry.fromJson(Map<String, dynamic> json) {
    return MusicJsonEntry(
      title: json['title'] as String? ?? 'Unknown',
      author: json['author'] as String? ?? 'Unknown',
      time: json['time'] as String? ?? '',
      url: json['url'] as String? ?? '',
      type: json['type'] as String? ?? 'audio/mpeg',
    );
  }

  /// Generates a unique ID from the URL hash.
  int get id => url.hashCode.abs();

  /// Tries to parse the date string into a DateTime.
  DateTime? get parsedDate {
    try {
      return DateTime.parse(time);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'time': time,
        'url': url,
        'type': type,
      };
}
