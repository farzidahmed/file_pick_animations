import 'package:flutter/material.dart';
import 'basketball_file_picker.dart';

// Re-export the library elements for backward compatibility
export 'basketball_file_picker.dart';
export 'file_pick_animation.dart';

/// Backward-compatible widget class for [FilePickAnimation].
/// Delegates directly to [BasketballFilePicker].
class FilePickAnimation extends StatelessWidget {
  const FilePickAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasketballFilePicker(
      autoShootOnSelect: true,
      primaryColor: Color(0xFFEE5A24),
      trajectoryDotColor: Color(0xFFFA8B60),
    );
  }
}
