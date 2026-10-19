import 'dart:async';
import 'package:file_pick_animation/basketball_file_picker.dart';
import 'package:file_pick_animation/main.dart';
import 'package:file_pick_animation/models/selected_file_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test loads Drop & Shoot screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Drop & Shoot Upload'), findsOneWidget);
    expect(find.text('Drop files here'), findsOneWidget);
  });

  testWidgets('BasketballFilePicker autoShootOnSelect triggers automatic shot on file selection', (WidgetTester tester) async {
    final GlobalKey<BasketballFilePickerState> pickerKey = GlobalKey<BasketballFilePickerState>();
    SelectedFileData? selectedFile;

    await tester.pumpWidget(
      MaterialApp(
        home: BasketballFilePicker(
          key: pickerKey,
          autoShootOnSelect: true,
          flightDuration: const Duration(milliseconds: 100),
          onFileSelected: (data) => selectedFile = data,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Verify initial state shows Pick File placeholder instead of a fake pre-selected file
    expect(find.text('Pick File'), findsOneWidget);

    // Update selected file programmatically
    pickerKey.currentState?.updateSelectedFile(
      name: 'invoice_march_2026.pdf',
      size: '1.8 MB',
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(selectedFile?.name, 'invoice_march_2026.pdf');
    expect(find.textContaining('invoice_march_2026.pdf'), findsOneWidget);
  });

  testWidgets('BasketballFilePicker supports custom uploadProgressStream', (WidgetTester tester) async {
    final StreamController<double> progressController = StreamController<double>.broadcast();
    final GlobalKey<BasketballFilePickerState> pickerKey = GlobalKey<BasketballFilePickerState>();
    bool completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BasketballFilePicker(
          key: pickerKey,
          uploadProgressStream: progressController.stream,
          flightDuration: const Duration(milliseconds: 100),
          onUploadCompleted: (data) {
            completed = true;
          },
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Trigger perfect shot
    pickerKey.currentState?.snapToBasketAndShoot();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 400));

    // Emit progress to stream
    progressController.add(0.45);
    await tester.pump();
    expect(find.text('Uploading... 45%'), findsOneWidget);

    // Complete progress
    progressController.add(1.0);
    await tester.pump();
    expect(completed, isTrue);

    await progressController.close();
  });

  testWidgets('BasketballFilePicker fits on small mobile screens (320px) without overflow', (WidgetTester tester) async {
    // Set small screen size (320x568 iPhone SE 1st gen / compact Android)
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final GlobalKey<BasketballFilePickerState> pickerKey = GlobalKey<BasketballFilePickerState>();

    await tester.pumpWidget(
      MaterialApp(
        home: BasketballFilePicker(
          key: pickerKey,
          initialFileName: "my_long_resume_document_name_2026.pdf",
          initialFileSize: "3.2 MB",
          flightDuration: const Duration(milliseconds: 100),
          uploadDuration: const Duration(milliseconds: 200),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Aiming state renders without overflow
    expect(find.byType(BasketballFilePicker), findsOneWidget);

    // Snap to basket and shoot to test flight, upload card, and completion
    pickerKey.currentState?.snapToBasketAndShoot();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 300));

    // Upload status card renders completed on 320px screen without any RenderFlex overflow
    expect(find.text('Completed'), findsOneWidget);
  });
}
