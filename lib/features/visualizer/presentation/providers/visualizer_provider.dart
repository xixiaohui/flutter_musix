import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/visualizer/fft_analyzer.dart';

/// Enum for visualization modes.
enum VisualizerMode { bars, circular, waveform, particles, ripple, glow }

/// Current visualization frame data.
class VisualizerFrame {
  final List<double> bands;          // Normalized 0-1 per band
  final List<double> waveform;       // Raw waveform samples
  final double amplitude;            // Overall amplitude 0-1
  final double peak;                 // Peak magnitude
  final double rms;                  // RMS energy
  final bool isBeat;                 // Beat detection flag
  final double beatIntensity;        // 0-1 beat pulse intensity

  const VisualizerFrame({
    this.bands = const [],
    this.waveform = const [],
    this.amplitude = 0,
    this.peak = 0,
    this.rms = 0,
    this.isBeat = false,
    this.beatIntensity = 0,
  });
}

/// Visualizer state.
class VisualizerState {
  final VisualizerMode mode;
  final VisualizerFrame frame;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isActive;
  final int tick;

  const VisualizerState({
    this.mode = VisualizerMode.bars,
    this.frame = const VisualizerFrame(),
    this.primaryColor = Colors.deepPurple,
    this.secondaryColor = Colors.purpleAccent,
    this.isActive = false,
    this.tick = 0,
  });

  VisualizerState copyWith({
    VisualizerMode? mode,
    VisualizerFrame? frame,
    Color? primaryColor,
    Color? secondaryColor,
    bool? isActive,
    int? tick,
  }) {
    return VisualizerState(
      mode: mode ?? this.mode,
      frame: frame ?? this.frame,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      isActive: isActive ?? this.isActive,
      tick: tick ?? this.tick,
    );
  }
}

/// Provider managing the audio visualizer state.
class VisualizerNotifier extends StateNotifier<VisualizerState> {
  final FftAnalyzer _analyzer;
  Timer? _timer;
  double _time = 0;
  double _bassIntensity = 0.5;
  double _beatPulse = 0;

  VisualizerNotifier()
      : _analyzer = FftAnalyzer(numBars: 64),
        super(const VisualizerState()) {
    _start();
  }

  void _start() {
    state = state.copyWith(isActive: true);
    _timer = Timer.periodic(const Duration(milliseconds: 33), (_) {
      // ~30 FPS for smooth visualization
      _tick();
    });
  }

  void _tick() {
    _time += 0.033;

    // Vary bass intensity over time for demo dynamics
    _bassIntensity = 0.3 +
        0.7 * (0.5 + 0.5 * math.sin(_time * 0.3));

    // Generate demo samples
    final samples = FftAnalyzer.generateDemoSamples(
      _analyzer.fftSize,
      _time,
      _bassIntensity,
    );

    _analyzer.processSamples(samples);
    final bands = _analyzer.getBands();
    final waveform = _analyzer.getWaveform(downsample: 128);

    // Beat pulse animation
    if (_analyzer.isBeat) {
      _beatPulse = 1.0;
    } else {
      _beatPulse *= 0.9; // Decay
    }

    state = state.copyWith(
      tick: state.tick + 1,
      frame: VisualizerFrame(
        bands: bands,
        waveform: waveform,
        amplitude: _analyzer.rms,
        peak: _analyzer.peak,
        rms: _analyzer.rms,
        isBeat: _analyzer.isBeat,
        beatIntensity: _beatPulse,
      ),
    );
  }

  void setMode(VisualizerMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setColors(Color primary, Color secondary) {
    state = state.copyWith(primaryColor: primary, secondaryColor: secondary);
  }

  void setActive(bool active) {
    if (active && !state.isActive) _start();
    if (!active) _stop();
  }

  void _stop() {
    _timer?.cancel();
    state = state.copyWith(isActive: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final visualizerProvider =
    StateNotifierProvider<VisualizerNotifier, VisualizerState>((ref) {
  return VisualizerNotifier();
});
