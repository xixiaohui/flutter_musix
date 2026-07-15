import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Service for setting audio files as ringtones/notifications/alarms.
class RingtoneService {
  static const _channel = MethodChannel('com.xxh.melodify/ringtone');
  final Dio _dio;

  RingtoneService(this._dio);

  /// Downloads the audio file to local storage and sets it as the default ringtone.
  Future<RingtoneResult> setAsRingtone({
    required String url,
    required String title,
    required String artist,
  }) async {
    try {
      // Download the file
      final dir = await getApplicationDocumentsDirectory();
      final ringtoneDir = Directory('${dir.path}/ringtones');
      if (!await ringtoneDir.exists()) {
        await ringtoneDir.create(recursive: true);
      }

      final fileName =
          '${title}_$artist.mp3'.replaceAll(RegExp(r'[^\w\s.-]'), '').replaceAll(' ', '_');
      final filePath = '${ringtoneDir.path}/$fileName';
      final file = File(filePath);

      if (!await file.exists()) {
        await _dio.download(url, filePath);
      }

      // Try native method first, fallback to file path
      try {
        final result = await _channel.invokeMethod<String>(
          'setRingtone',
          {'filePath': filePath, 'title': title},
        );
        return RingtoneResult(success: true, message: result ?? 'Set as ringtone');
      } on MissingPluginException {
        // Native method not available — file is saved, show path
        return RingtoneResult(
          success: true,
          message: 'Saved to $filePath',
          filePath: filePath,
        );
      }
    } catch (e) {
      return RingtoneResult(success: false, message: e.toString());
    }
  }
}

class RingtoneResult {
  final bool success;
  final String message;
  final String? filePath;

  const RingtoneResult({required this.success, required this.message, this.filePath});
}
