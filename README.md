# file_pick_animation 🏀

[![pub package](https://img.shields.io/pub/v/file_pick_animation.svg)](https://pub.dev/packages/file_pick_animation)
[![License: MIT](https://img.shields.io/badge/License-MIT-orange.svg)](https://opensource.org/licenses/MIT)

A delightful, interactive **Basketball Shoot & Drop** file upload animation for Flutter applications. Turn boring file uploading into an engaging gamified basketball shot experience!

---

## ✨ Features

- 🏀 **Interactive Aim & Shoot**: Drag the document to aim at the hoop, release to take the shot, or tap for a direct launch.
- 🎯 **Dotted Bezier Trajectory Arc**: Dynamic projectile curve with tangent-aligned document rotation and 3D depth.
- 🕸️ **Swishing Net Physics**: Realistic mesh wiggle animation when the document scores through the basket.
- 📁 **Device File Picker & Preset Samples**: Integrated device file picker (`file_picker`) along with customizable sample documents.
- 📊 **Animated Upload Progress Bar**: Smooth upload completion animation with progress feedback and replay options.
- 🛡️ **Zero Memory Leaks**: Scoped `AnimatedBuilder` repaints, auto-cancelling background timers, and safe controller lifecycle disposal.
- 🎨 **100% Customizable**: Tailor colors, titles, hints, allowed extensions, durations, or provide your own custom AppBars and builders.

---

## 🚀 Getting Started

Add `file_pick_animation` to your `pubspec.yaml`:

```bash
flutter pub add file_pick_animation
```

Or manually:

```yaml
dependencies:
  file_pick_animation: ^0.0.1
```

Import the package in your Dart code:

```dart
import 'package:file_pick_animation/file_pick_animation.dart';
```

---

## 💡 Quick Usage

### 1. Simple Drop-in

```dart
import 'package:flutter/material.dart';
import 'package:file_pick_animation/file_pick_animation.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BasketballFilePicker(),
  ));
}
```

---

### 2. Custom Configuration & Callbacks

```dart
BasketballFilePicker(
  // Theming & Colors
  primaryColor: const Color(0xFFEE5A24),
  backgroundColor: const Color(0xFFF1F4F9),
  trajectoryDotColor: const Color(0xFFFA8B60),

  // Titles & Labels
  title: "Upload Contract",
  subtitle: "Drag and shoot your PDF to submit",
  badgeText: "Browse",

  // Supported Extensions
  allowedExtensions: const ['pdf', 'doc', 'docx'],

  // Preset Sample Files
  sampleFiles: const [
    SampleFile(name: "invoice_2026.pdf", size: "1.2 MB"),
    SampleFile(name: "pitch_deck.pdf", size: "4.8 MB"),
  ],

  // Callbacks
  onFileSelected: (SelectedFileData file) {
    debugPrint("Selected file: ${file.name} (${file.size}) at ${file.path}");
  },
  onUploadCompleted: (SelectedFileData file) {
    debugPrint("File upload completed: ${file.name}");
    // Proceed to next screen or trigger backend upload
  },
)
```

---

## ⚙️ Customization Options

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `primaryColor` | `Color` | `Color(0xFFEE5A24)` | Primary basketball orange accent color. |
| `trajectoryDotColor` | `Color` | `Color(0xFFFA8B60)` | Color of the aiming trajectory arc dots. |
| `backgroundColor` | `Color` | `Color(0xFFF1F4F9)` | Background color of the upload screen. |
| `title` | `String` | `"Drop files here"` | Main header title inside the drop zone. |
| `subtitle` | `String` | `"or take the shot"` | Subtitle under the main drop zone title. |
| `badgeText` | `String` | `"Tap to Pick"` | Small tag badge in the drop header. |
| `aimPrompt` | `String` | `"Drag the document..."` | Bottom hint when aiming outside the hoop. |
| `lockedPrompt` | `String` | `"Target locked!..."` | Bottom hint when target aligns with the hoop. |
| `uploadingText` | `String` | `"Uploading..."` | Progress indicator label during upload. |
| `completedText` | `String` | `"Completed"` | Status label when upload reaches 100%. |
| `allowedExtensions` | `List<String>` | `['pdf']` | Allowed file formats for the device picker. |
| `sampleFiles` | `List<SampleFile>?` | `Default Samples` | Sample files list. Pass `[]` to hide samples. |
| `flightDuration` | `Duration` | `1000ms` | Duration of the projectile arc flight. |
| `uploadDuration` | `Duration` | `2200ms` | Duration of the upload progress bar. |
| `showAppBar` | `bool` | `true` | Whether to display the default AppBar. |
| `appBarTitle` | `String` | `"Drop & Shoot Upload"` | Title for the default AppBar. |
| `customAppBar` | `PreferredSizeWidget?` | `null` | Custom AppBar widget if desired. |
| `showDemoButton` | `bool` | `true` | Displays basketball button for demo shots. |
| `onFileSelected` | `ValueChanged<SelectedFileData>?` | `null` | Called when a file is chosen. |
| `onUploadCompleted` | `ValueChanged<SelectedFileData>?` | `null` | Called when upload completes. |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
