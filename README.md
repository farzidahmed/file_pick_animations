# file_pick_animation 🏀

[![pub package](https://img.shields.io/pub/v/file_pick_animation.svg)](https://pub.dev/packages/file_pick_animation)
[![License: MIT](https://img.shields.io/badge/License-MIT-orange.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-All%20Platforms-blue.svg)](https://flutter.dev)

A delightful, gamified **Basketball Shoot & Drop** file upload animation for Flutter applications. Turn dull file uploading into an engaging, interactive basketball experience that users will love!

---

## 🎯 How It Works (At a Glance)

```text
 ┌────────────────┐          ┌──────────────────────┐          ┌───────────────────┐
 │ 1. AIM & DRAG  │  ─────>  │  2. SHOOT & SWISH    │  ─────>  │ 3. UPLOAD PROGRESS│
 │ Drag document  │          │ Bezier curve flight  │          │ Smooth bar fills  │
 │ along the arc  │          │ + mesh net swish     │          │ + done indicator  │
 └────────────────┘          └──────────────────────┘          └───────────────────┘
```

1. **Aim & Drag**: The user drags the document or taps to line up the dotted trajectory toward the basket rim.
2. **Shoot & Swish**: The document flies in a realistic parabolic arc, tilts along the tangent vector, and swishes the animated mesh net as it scores.
3. **Upload Progress**: A polished card animates the upload progress from 0% to 100%, completing with a checkmark and replay option.

---

## ✨ Features

- 🏀 **Interactive Aim & Shoot**: Drag the document to aim at the hoop, release to shoot, or tap for an instant shot.
- 🎯 **Realistic Quadratic Bezier Curve**: Smooth mathematical flight path with 3D rotation and perspective scaling.
- 🕸️ **Net Swish Physics**: Animated criss-cross net with dynamic sinusoidal wiggle upon scoring.
- 📁 **Device File Picker & Preset Samples**: Built-in integration with `file_picker` plus custom sample documents.
- 📊 **Progress Bar & Completion Card**: Clean card displaying file name, size, progress percentage, and success badge.
- 🛡️ **Zero Memory Leaks**: Scoped `AnimatedBuilder` repaints, auto-canceling background timers, and safe controller lifecycle disposal.
- 🎨 **100% Developer Customizable**: Easily customize colors, text prompts, file extensions, durations, or provide your own AppBars and widgets.

---

## 🚀 Getting Started

Add `file_pick_animation` to your `pubspec.yaml`:

```bash
flutter pub add file_pick_animation
```

Or add it directly under `dependencies` in your `pubspec.yaml`:

```yaml
dependencies:
  file_pick_animation: ^0.0.1
```

Import it in your Dart code:

```dart
import 'package:file_pick_animation/file_pick_animation.dart';
```

---

## 💡 Usage Examples

### 1. Minimal (Drop-in Ready)

```dart
import 'package:file_pick_animation/file_pick_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BasketballFilePicker(),
  ));
}
```

---

### 2. Real-World Integration with Backend Upload

```dart
import 'package:file_pick_animation/file_pick_animation.dart';
import 'package:flutter/material.dart';

class ResumeUploadScreen extends StatelessWidget {
  const ResumeUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasketballFilePicker(
      // Theming & Colors
      primaryColor: const Color(0xFFEE5A24),
      trajectoryDotColor: const Color(0xFFFA8B60),
      backgroundColor: const Color(0xFFF1F4F9),

      // Custom Header Text
      title: "Upload Your Resume",
      subtitle: "Drag & take the shot to apply",
      badgeText: "PDF Only",

      // Allowed File Types
      allowedExtensions: const ['pdf'],

      // Preset Sample Documents
      sampleFiles: const [
        SampleFile(name: "Senior_Dev_Resume.pdf", size: "1.4 MB"),
        SampleFile(name: "Portfolio_2026.pdf", size: "3.2 MB"),
      ],

      // Callbacks
      onFileSelected: (SelectedFileData file) {
        debugPrint("File selected: ${file.name} (${file.size})");
      },
      onUploadCompleted: (SelectedFileData file) async {
        debugPrint("Shot scored! Uploading ${file.name} to server...");
        // Call your backend API here:
        // await myApiService.upload(file.path ?? file.bytes);
      },
    );
  }
}
```

---

### 3. Embed Inside an Existing Screen (No AppBar)

If you already have your own `Scaffold` or custom header:

```dart
BasketballFilePicker(
  showAppBar: false, // Disables the default top AppBar
  onUploadCompleted: (file) {
    Navigator.of(context).pushNamed('/success');
  },
)
```

---

## ⚙️ Customization Options

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `primaryColor` | `Color` | `Color(0xFFEE5A24)` | Primary hoop and accent color. |
| `trajectoryDotColor` | `Color` | `Color(0xFFFA8B60)` | Color of the aiming arc dots. |
| `backgroundColor` | `Color` | `Color(0xFFF1F4F9)` | Overall background color. |
| `title` | `String` | `"Drop files here"` | Drop zone header title. |
| `subtitle` | `String` | `"or take the shot"` | Subtitle below the header. |
| `badgeText` | `String` | `"Tap to Pick"` | Text on the header chip. |
| `aimPrompt` | `String` | `"Drag the document..."` | Bottom hint when aiming. |
| `lockedPrompt` | `String` | `"Target locked!..."` | Bottom hint when aligned with hoop. |
| `uploadingText` | `String` | `"Uploading..."` | Label during upload progress. |
| `completedText` | `String` | `"Completed"` | Label when progress reaches 100%. |
| `allowedExtensions` | `List<String>` | `['pdf']` | Allowed file formats for device picker. |
| `sampleFiles` | `List<SampleFile>?` | `Default Samples` | Sample files list (pass `[]` to hide). |
| `flightDuration` | `Duration` | `1000ms` | Duration of the projectile arc flight. |
| `uploadDuration` | `Duration` | `2200ms` | Duration of upload progress animation. |
| `showAppBar` | `bool` | `true` | Show or hide the default AppBar. |
| `appBarTitle` | `String` | `"Drop & Shoot Upload"` | Title for the default AppBar. |
| `customAppBar` | `PreferredSizeWidget?` | `null` | Optional custom AppBar widget. |
| `showDemoButton` | `bool` | `true` | Shows basketball icon button for demo shot. |
| `onFileSelected` | `ValueChanged<SelectedFileData>?` | `null` | Called when a file is picked. |
| `onUploadCompleted` | `ValueChanged<SelectedFileData>?` | `null` | Called when upload completes. |

---

## 💡 Common Use Cases

- 💼 **Job Portals**: Engaging resume, CV, and portfolio upload.
- 🎓 **EdTech Platforms**: Fun homework, assignment, and thesis submission.
- 🧾 **Finance & Invoicing**: Receipt and bill submission.
- 🎮 **Gamified Apps**: Any application looking to replace boring file pickers with a delightful UX moment.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
