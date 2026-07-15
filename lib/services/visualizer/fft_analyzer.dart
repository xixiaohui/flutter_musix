import 'dart:math' as math;
import 'dart:typed_data';

/// FFT-based audio analyzer producing frequency spectrum data.
///
/// Used by visualizer widgets to render real-time audio-reactive graphics.
/// Runs synchronously on the main isolate with optimized math for 60FPS.
class FftAnalyzer {
  final int fftSize;
  final int sampleRate;
  final int numBars;

  final Float64List _window;
  final Float64List _real;
  final Float64List _imag;
  final Float64List _magnitudes;
  final Float64List _smoothedMagnitudes;
  final List<double> _rawSamples;

  double _smoothingFactor = 0.35;
  double _peak = 0;
  double _rms = 0;
  double _beatEnergy = 0;
  double _prevBeatEnergy = 0;
  int _beatTimer = 0;
  bool _isBeat = false;

  FftAnalyzer({
    this.fftSize = 1024,
    this.sampleRate = 44100,
    this.numBars = 64,
  })  : _window = Float64List(fftSize),
        _real = Float64List(fftSize),
        _imag = Float64List(fftSize),
        _magnitudes = Float64List(fftSize ~/ 2),
        _smoothedMagnitudes = Float64List(fftSize ~/ 2),
        _rawSamples = List.filled(fftSize, 0.0) {
    _initWindow();
  }

  /// Hann window function for spectral leakage reduction.
  void _initWindow() {
    for (var i = 0; i < fftSize; i++) {
      _window[i] = 0.5 * (1 - math.cos(2 * math.pi * i / (fftSize - 1)));
    }
  }

  /// Feed raw audio samples into the analyzer.
  void processSamples(Float64List samples) {
    final len = math.min(samples.length, fftSize);
    for (var i = 0; i < len; i++) {
      _rawSamples[i] = samples[i];
      _real[i] = samples[i] * _window[i];
      _imag[i] = 0;
    }
    for (var i = len; i < fftSize; i++) {
      _rawSamples[i] = 0;
      _real[i] = 0;
      _imag[i] = 0;
    }

    _fft(_real, _imag);
    _computeMagnitudes();
    _applySmoothing();
    _detectBeat();
    _computeMetrics();
    _beatTimer++;
  }

  /// Bit-reversal permutation for FFT.
  void _fft(Float64List re, Float64List im) {
    final n = fftSize;
    var j = 0;
    for (var i = 0; i < n; i++) {
      if (i < j) {
        final tr = re[i]; re[i] = re[j]; re[j] = tr;
        final ti = im[i]; im[i] = im[j]; im[j] = ti;
      }
      var m = n >> 1;
      while (m >= 1 && j >= m) { j -= m; m >>= 1; }
      j += m;
    }

    for (var s = 1; s <= (math.log(n) / math.log(2)).toInt(); s++) {
      final m = 1 << s;
      final m2 = m >> 1;
      final wm = math.cos(2 * math.pi / m);
      final ws = -math.sin(2 * math.pi / m);
      for (var k = 0; k < n; k += m) {
        var wr = 1.0, wi = 0.0;
        for (var j = 0; j < m2; j++) {
          final t = k + j + m2;
          final tr = wr * re[t] - wi * im[t];
          final ti = wr * im[t] + wi * re[t];
          re[t] = re[k + j] - tr;
          im[t] = im[k + j] - ti;
          re[k + j] += tr;
          im[k + j] += ti;
          final wTemp = wr;
          wr = wr * wm - wi * ws;
          wi = wTemp * ws + wi * wm;
        }
      }
    }
  }

  /// Compute magnitude spectrum.
  void _computeMagnitudes() {
    for (var i = 0; i < magnitudes.length; i++) {
      _magnitudes[i] = math.sqrt(_real[i] * _real[i] + _imag[i] * _imag[i]);
    }
  }

  /// Apply exponential smoothing for fluid animation.
  void _applySmoothing() {
    for (var i = 0; i < _magnitudes.length; i++) {
      _smoothedMagnitudes[i] = _smoothingFactor * _magnitudes[i] +
          (1 - _smoothingFactor) * _smoothedMagnitudes[i];
    }
  }

  /// Simple beat detection using energy comparison.
  void _detectBeat() {
    _prevBeatEnergy = _beatEnergy;
    _beatEnergy = 0;
    // Focus on bass frequencies (bins 0 to fftSize/8) for beat detection
    final bassBins = fftSize ~/ 8;
    for (var i = 0; i < bassBins; i++) {
      _beatEnergy += _smoothedMagnitudes[i];
    }
    _beatEnergy /= bassBins;

    // Beat detected if energy spikes above average
    const threshold = 1.4;
    _isBeat = _beatTimer > 8 &&
        _beatEnergy > _prevBeatEnergy * threshold;
    if (_isBeat) _beatTimer = 0;
  }

  void _computeMetrics() {
    _peak = _smoothedMagnitudes.reduce(math.max);
    _rms = 0;
    for (var i = 0; i < _smoothedMagnitudes.length; i++) {
      _rms += _smoothedMagnitudes[i] * _smoothedMagnitudes[i];
    }
    _rms = math.sqrt(_rms / _smoothedMagnitudes.length);
  }

  /// Get frequency bin data, grouped into [numBars] logarithmic bands.
  List<double> getBands() {
    final bands = List.filled(numBars, 0.0);
    final usableBins = _smoothedMagnitudes.length; // Nyquist limit

    for (var i = 0; i < numBars; i++) {
      // Logarithmic frequency scaling for more musical mapping
      final startFreq = 20 * math.pow(20000 / 20, i / numBars);
      final endFreq = 20 * math.pow(20000 / 20, (i + 1) / numBars);
      final startBin = (startFreq / (sampleRate / 2) * usableBins).round();
      final endBin = (endFreq / (sampleRate / 2) * usableBins).round();
      final clampedEnd = math.min(endBin, usableBins - 1);
      final clampedStart = math.min(startBin, clampedEnd);

      var sum = 0.0;
      var count = 0;
      for (var b = clampedStart; b <= clampedEnd; b++) {
        sum += _smoothedMagnitudes[b];
        count++;
      }
      bands[i] = count > 0 ? sum / count : 0.0;
    }

    // Normalize to 0-1
    final maxVal = bands.reduce(math.max);
    if (maxVal > 0.001) {
      for (var i = 0; i < bands.length; i++) {
        bands[i] = bands[i] / maxVal;
      }
    }

    return bands;
  }

  /// Get raw waveform samples for waveform display.
  List<double> getWaveform({int downsample = 256}) {
    final step = fftSize ~/ downsample;
    final result = <double>[];
    for (var i = 0; i < fftSize; i += step) {
      result.add(_rawSamples[i]);
    }
    // Normalize
    final maxAbs = result.fold(0.0, (m, v) => math.max(m, v.abs()));
    if (maxAbs > 0.001) {
      for (var i = 0; i < result.length; i++) {
        result[i] /= maxAbs;
      }
    }
    return result;
  }

  // ── Getters ──
  Float64List get magnitudes => _magnitudes;
  Float64List get smoothedMagnitudes => _smoothedMagnitudes;
  double get peak => _peak;
  double get rms => _rms;
  bool get isBeat => _isBeat;
  double get beatEnergy => _beatEnergy;

  set smoothingFactor(double v) {
    _smoothingFactor = v.clamp(0.1, 0.9);
  }

  /// Generate synthetic audio data for testing/demo.
  static Float64List generateDemoSamples(
      int size, double time, double bassIntensity) {
    final samples = Float64List(size);
    final rng = math.Random(42);
    for (var i = 0; i < size; i++) {
      final t = time + i / 44100.0;
      // Mix multiple sine waves for a rich spectrum
      final bass = math.sin(2 * math.pi * 50 * t) * bassIntensity * 0.8;
      final mid = math.sin(2 * math.pi * 440 * t) * 0.3;
      final high = math.sin(2 * math.pi * 3000 * t) * 0.1;
      final noise = (rng.nextDouble() - 0.5) * 0.05;
      final sub =
          math.sin(2 * math.pi * 30 * t) * bassIntensity * 0.4; // sub-bass
      samples[i] = (bass + mid + high + sub + noise).clamp(-1.0, 1.0);
    }
    return samples;
  }
}
