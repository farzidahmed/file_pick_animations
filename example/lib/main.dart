import 'package:file_pick_animation/file_pick_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Basketball File Picker Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEE5A24)),
        useMaterial3: true,
      ),
      home: BasketballFilePicker(
        onFileSelected: (SelectedFileData file) {
          debugPrint('Selected file: ${file.name} (${file.size})');
        },
        onUploadCompleted: (SelectedFileData file) {
          debugPrint('Upload completed for: ${file.name}');
        },
      ),
    );
  }
}
