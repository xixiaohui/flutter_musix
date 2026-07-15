import 'package:flutter_riverpod/flutter_riverpod.dart';

enum EqPreset { normal, rock, pop, jazz, classical, hipHop, electronic, bassBoost, vocal, custom }

/// Holds equalizer state including 10-band gains, presets, and effects.
class EqualizerState {
  final List<double> gains;     // 10 bands, -12 to +12 dB
  final EqPreset selectedPreset;
  final int bassBoost;           // 0, 3, 6, 9, 12 dB
  final double balance;          // -1.0 (L) to 1.0 (R)

  const EqualizerState({
    this.gains = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    this.selectedPreset = EqPreset.normal,
    this.bassBoost = 0,
    this.balance = 0,
  });

  EqualizerState copyWith({
    List<double>? gains, EqPreset? selectedPreset, int? bassBoost, double? balance,
  }) {
    return EqualizerState(
      gains: gains ?? this.gains,
      selectedPreset: selectedPreset ?? this.selectedPreset,
      bassBoost: bassBoost ?? this.bassBoost,
      balance: balance ?? this.balance,
    );
  }
}

/// Preset EQ configurations.
const _presets = <EqPreset, List<double>>{
  EqPreset.normal:     [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  EqPreset.rock:       [5, 4, 0, -2, -1, 2, 4, 5, 5, 4],
  EqPreset.pop:        [-1, 1, 3, 2, -1, -1, 0, 1, 2, 2],
  EqPreset.jazz:       [3, 2, 0, 0, -1, -1, 0, 1, 2, 3],
  EqPreset.classical:  [4, 3, 1, 0, -1, -2, 0, 2, 3, 4],
  EqPreset.hipHop:     [6, 5, 2, 0, 0, 1, 2, 3, 3, 4],
  EqPreset.electronic: [5, 3, 0, -2, -3, 0, 3, 5, 5, 4],
  EqPreset.bassBoost:  [8, 6, 3, 1, 0, 0, 0, 1, 2, 3],
  EqPreset.vocal:      [-2, -1, 0, 2, 4, 3, 1, 0, -1, -2],
};

class EqualizerNotifier extends StateNotifier<EqualizerState> {
  EqualizerNotifier() : super(const EqualizerState());

  void setBand(int index, double value) {
    final gains = List<double>.from(state.gains);
    gains[index] = (value * 2).roundToDouble() / 2; // Snap to 0.5 steps
    state = state.copyWith(gains: gains, selectedPreset: EqPreset.custom);
  }

  void selectPreset(EqPreset preset) {
    final gains = _presets[preset] ?? List.filled(10, 0.0);
    state = state.copyWith(gains: gains, selectedPreset: preset);
  }

  void setBassBoost(int db) {
    state = state.copyWith(bassBoost: db);
  }

  void setBalance(double balance) {
    state = state.copyWith(balance: balance);
  }

  void reset() {
    state = const EqualizerState();
  }
}

final equalizerProvider = StateNotifierProvider<EqualizerNotifier, EqualizerState>((ref) {
  return EqualizerNotifier();
});
