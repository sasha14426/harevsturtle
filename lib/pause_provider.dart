
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pauseProvider = StateNotifierProvider<PauseNotifier, bool>((ref) {
  return PauseNotifier(false);
});

class PauseNotifier extends StateNotifier<bool> {
  PauseNotifier(super.state);

  void toggle() {
    state = !state;
  }

  void setState(bool state) {
    this.state = state;
  }
}
