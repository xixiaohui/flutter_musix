import 'package:flutter/services.dart';

/// Real audio equalizer service using native Android EQ/iOS audio units.
class EqualizerService {
  static const _channel = MethodChannel('com.xxh.melodify/equalizer');

  bool _initialized = false;

  /// Initialize the native equalizer engine.
  Future<bool> init() async {
    if (_initialized) return true;
    try {
      final result = await _channel.invokeMethod<bool>('init');
      _initialized = result ?? false;
      return _initialized;
    } on MissingPluginException {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Apply band gains. [bandGains] is a list of 10 values from -12.0 to +12.0 dB.
  Future<void> setBandGains(List<double> bandGains) async {
    if (!_initialized) return;
    try {
      await _channel.invokeMethod('setBandGains', {
        'gains': bandGains.map((g) => (g * 100).round()).toList(), // Millibels
      });
    } catch (_) {}
  }

  /// Set bass boost level in dB (0, 3, 6, 9, 12).
  Future<void> setBassBoost(int db) async {
    if (!_initialized) return;
    try {
      await _channel.invokeMethod('setBassBoost', {'level': db});
    } catch (_) {}
  }

  /// Set stereo balance. -1.0 = full left, 0 = center, 1.0 = full right.
  Future<void> setBalance(double balance) async {
    if (!_initialized) return;
    try {
      await _channel.invokeMethod('setBalance', {'balance': balance});
    } catch (_) {}
  }

  /// Enable or disable the equalizer.
  Future<void> setEnabled(bool enabled) async {
    if (!_initialized) return;
    try {
      await _channel.invokeMethod('setEnabled', {'enabled': enabled});
    } catch (_) {}
  }

  /// Release native resources.
  Future<void> dispose() async {
    if (!_initialized) return;
    try {
      await _channel.invokeMethod('dispose');
      _initialized = false;
    } catch (_) {}
  }
}
