import 'package:file_pick_animation/file_pick_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Basketball Upload Animation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEE5A24)),
        useMaterial3: true,
      ),
      home: BasketballFilePicker(
        onFileSelected: (SelectedFileData file) {
          debugPrint("Selected file: ${file.name} (${file.size})");
        },
        onUploadCompleted: (SelectedFileData file) {
          debugPrint("Upload finished for: ${file.name}");
        },
      ),
    );
  }
}
