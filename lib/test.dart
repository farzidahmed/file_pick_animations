import 'package:flutter/material.dart';
import 'basketball_file_picker.dart';

// Re-export the library elements for backward compatibility
export 'basketball_file_picker.dart';
export 'file_pick_animation.dart';

/// Backward-compatible widget class for [Test].
/// Delegates directly to [BasketballFilePicker].
class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasketballFilePicker();
  }
}
