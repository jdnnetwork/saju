import 'package:flutter/services.dart';

void playClickSound() {
  HapticFeedback.lightImpact();
  SystemSound.play(SystemSoundType.click);
}
