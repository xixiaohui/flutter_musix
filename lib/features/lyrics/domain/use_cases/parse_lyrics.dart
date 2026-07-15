import '../../../../models/lyric_line.dart';

/// Parses LRC formatted lyrics into structured [LyricLine] objects.
class ParseLyricsUseCase {
  /// Parses LRC text into a list of timed lyric lines.
  ///
  /// Supports:
  /// - Standard LRC: `[mm:ss.xx]text`
  /// - Multiple timestamps per line: `[mm:ss.xx][mm:ss.xx]text`
  /// - Word-level timing: `[mm:ss.xx]<mm:ss.xx>word`
  List<LyricLine> call(String lrcText) {
    final lines = <LyricLine>[];
    final regex = RegExp(r'\[(\d{2}):(\d{2})\.(\d{2,3})\]');
    final wordRegex = RegExp(r'<(\d{2}):(\d{2})\.(\d{2,3})>');

    for (final rawLine in lrcText.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;

      // Extract all timestamps
      final timestampMatches = regex.allMatches(line).toList();
      if (timestampMatches.isEmpty) continue;

      // Extract text after the last timestamp
      var text = line;
      for (final m in timestampMatches) {
        text = text.replaceFirst(m.group(0)!, '');
      }
      text = text.trim();

      // Skip metadata tags
      if (text.isEmpty || text.startsWith('[')) continue;

      // Parse word-level timings if present
      final words = <LyricWord>[];
      final wordMatches = wordRegex.allMatches(text);
      var cleanText = text;
      Duration lastEnd = Duration.zero;

      for (final wm in wordMatches) {
        final wordStart = _parseTimestampFromMatch(wm);
        final wordText = wm.group(0)!;
        cleanText = cleanText.replaceFirst(wordText, '');
        words.add(LyricWord(startTime: wordStart, endTime: wordStart, text: wordText));
      }

      // Use the first timestamp as the line timestamp
      final timestamp = _parseTimestampFromMatch(timestampMatches.first);
      lines.add(LyricLine(
        timestamp: timestamp,
        text: cleanText.isNotEmpty ? cleanText : text,
        words: words,
      ));
    }

    // Sort by timestamp
    lines.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return lines;
  }

  Duration _parseTimestampFromMatch(Match match) {
    final minutes = int.parse(match.group(1)!);
    final seconds = int.parse(match.group(2)!);
    final centis = match.group(3)!;
    final milliseconds = centis.length == 2
        ? int.parse(centis) * 10
        : int.parse(centis);

    return Duration(minutes: minutes, seconds: seconds, milliseconds: milliseconds);
  }
}
