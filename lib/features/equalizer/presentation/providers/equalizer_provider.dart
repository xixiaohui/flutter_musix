import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/equalizer_service.dart';

enum EqPreset { normal, rock, pop, jazz, classical, hipHop, electronic, bassBoost, vocal, custom }

/// Holds equalizer state including 10-band gains, presets, and effects.
class EqualizerState {
  final List<double> gains;
  final EqPreset selectedPreset;
  final int bassBoost;
  final double balance;
  final bool isActive;

  const EqualizerState({
    this.gains = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    this.selectedPreset = EqPreset.normal,
    this.bassBoost = 0,
    this.balance = 0,
    this.isActive = false,
  });

  EqualizerState copyWith({
    List<double>? gains, EqPreset? selectedPreset, int? bassBoost, double? balance, bool? isActive,
  }) {
    return EqualizerState(
      gains: gains ?? this.gains,
      selectedPreset: selectedPreset ?? this.selectedPreset,
      bassBoost: bassBoost ?? this.bassBoost,
      balance: balance ?? this.balance,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Preset EQ configurations (dB values).
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
  final EqualizerService _service;

  EqualizerNotifier(this._service) : super(const EqualizerState()) {
    _init();
  }

  Future<void> _init() async {
    final ok = await _service.init();
    if (ok) state = state.copyWith(isActive: true);
    await _service.setBandGains(state.gains);
  }

  void setBand(int index, double value) {
    final gains = List<double>.from(state.gains);
    gains[index] = (value * 2).roundToDouble() / 2;
    state = state.copyWith(gains: gains, selectedPreset: EqPreset.custom);
    _service.setBandGains(gains);
  }

  void selectPreset(EqPreset preset) {
    final gains = _presets[preset] ?? List.filled(10, 0.0);
    state = state.copyWith(gains: gains, selectedPreset: preset);
    _service.setBandGains(gains);
  }

  void setBassBoost(int db) {
    state = state.copyWith(bassBoost: db);
    _service.setBassBoost(db);
  }

  void setBalance(double balance) {
    state = state.copyWith(balance: balance);
    _service.setBalance(balance);
  }

  void reset() {
    state = const EqualizerState();
    _service.setBandGains(state.gains);
    _service.setBassBoost(0);
    _service.setBalance(0);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}

final equalizerServiceProvider = Provider<EqualizerService>((ref) => EqualizerService());

final equalizerProvider = StateNotifierProvider<EqualizerNotifier, EqualizerState>((ref) {
  final svc = ref.watch(equalizerServiceProvider);
  return EqualizerNotifier(svc);
});
