import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'models/sample_file.dart';
import 'models/selected_file_data.dart';
import 'models/shot_state.dart';
import 'utils/trajectory_physics.dart';
import 'widgets/aiming_hint_badge.dart';
import 'widgets/draggable_pdf_launcher.dart';
import 'widgets/flying_pdf_document.dart';
import 'widgets/hoop_rim.dart';
import 'widgets/pdf_picker_bottom_sheet.dart';
import 'widgets/top_drop_zone.dart';
import 'widgets/trajectory_arc.dart';
import 'widgets/upload_status_card.dart';

/// Highly customizable Basketball Shoot & Drop File Upload Animation widget.
class BasketballFilePicker extends StatefulWidget {
  /// Callback triggered when a file is selected from device or preset samples.
  final ValueChanged<SelectedFileData>? onFileSelected;

  /// Callback triggered when the upload progress animation finishes.
  final ValueChanged<SelectedFileData>? onUploadCompleted;

  /// Allowed file extensions when selecting files from the device (e.g. `['pdf']`).
  final List<String> allowedExtensions;

  /// Primary accent color (default: `#EE5A24` basketball orange).
  final Color primaryColor;

  /// Color used for the trajectory flight dots.
  final Color trajectoryDotColor;

  /// Background color of the entire screen / widget body.
  final Color backgroundColor;

  /// Main title shown at the top of the drop zone.
  final String title;

  /// Subtitle shown under the drop zone title.
  final String subtitle;

  /// Text on the small badge in the header.
  final String badgeText;

  /// Aiming hint text when document is not aimed at the hoop.
  final String aimPrompt;

  /// Aiming hint text when document is aimed inside the hoop.
  final String lockedPrompt;

  /// Status text while upload progress is running.
  final String uploadingText;

  /// Status text when upload progress finishes.
  final String completedText;

  /// List of sample files to present in the selection sheet.
  /// Set to empty `[]` to hide the sample files section completely.
  final List<SampleFile>? sampleFiles;

  /// Initial placeholder document name.
  final String initialFileName;

  /// Initial placeholder document size.
  final String initialFileSize;

  /// Duration of the projectile arc flight animation.
  final Duration flightDuration;

  /// Duration of the upload progress bar animation.
  final Duration uploadDuration;

  /// Whether to display the default AppBar. Set to `false` if hosting inside a custom screen.
  final bool showAppBar;

  /// Title for the default AppBar.
  final String appBarTitle;

  /// Optional custom AppBar if developers want full control over the navigation bar.
  final PreferredSizeWidget? customAppBar;

  /// Whether to display the basketball icon button that triggers a perfect demo shot.
  final bool showDemoButton;

  /// Custom builder for the document widget. If null, the default folded PDF card is used.
  final Widget Function(BuildContext context, String fileName)? customDocumentBuilder;

  const BasketballFilePicker({
    super.key,
    this.onFileSelected,
    this.onUploadCompleted,
    this.allowedExtensions = const ['pdf'],
    this.primaryColor = const Color(0xFFEE5A24),
    this.trajectoryDotColor = const Color(0xFFFA8B60),
    this.backgroundColor = const Color(0xFFF1F4F9),
    this.title = "Drop files here",
    this.subtitle = "or take the shot",
    this.badgeText = "Tap to Pick",
    this.aimPrompt = "Drag the document to aim at the basket",
    this.lockedPrompt = "Target locked! Release or tap to shoot 🏀",
    this.uploadingText = "Uploading...",
    this.completedText = "Completed",
    this.sampleFiles,
    this.initialFileName = "final_final_v7.pdf",
    this.initialFileSize = "2.4 MB",
    this.flightDuration = const Duration(milliseconds: 1000),
    this.uploadDuration = const Duration(milliseconds: 2200),
    this.showAppBar = true,
    this.appBarTitle = "Drop & Shoot Upload",
    this.customAppBar,
    this.showDemoButton = true,
    this.customDocumentBuilder,
  });

  @override
  State<BasketballFilePicker> createState() => BasketballFilePickerState();
}

class BasketballFilePickerState extends State<BasketballFilePicker>
    with TickerProviderStateMixin {
  // ---------------------------------------------------------------------------
  // Animation Controllers
  // ---------------------------------------------------------------------------
  late final AnimationController _flightController;
  late final AnimationController _netController;
  late final AnimationController _uploadController;
  late final AnimationController _pulseController;

  // ---------------------------------------------------------------------------
  // Timers (Safely managed to prevent memory leaks on unmount)
  // ---------------------------------------------------------------------------
  Timer? _uploadDelayTimer;
  Timer? _missedResetTimer;

  // ---------------------------------------------------------------------------
  // State Variables
  // ---------------------------------------------------------------------------
  ShotState _shotState = ShotState.aiming;
  bool _isDragging = false;

  late String _fileName;
  late String _fileSize;
  String? _filePath;

  // Dynamic layout coordinates
  Offset _startPos = Offset.zero;
  Offset _targetPos = Offset.zero;
  Offset _basketPos = Offset.zero;

  static const double _hoopWidth = 100.0;
  static const double _hoopHeight = 22.0;

  @override
  void initState() {
    super.initState();
    _fileName = widget.initialFileName;
    _fileSize = widget.initialFileSize;
    _initAnimationControllers();
  }

  void _initAnimationControllers() {
    _flightController = AnimationController(
      vsync: this,
      duration: widget.flightDuration,
    );
    _flightController.addListener(_onFlightTick);
    _flightController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onFlightCompleted();
      }
    });

    _netController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _uploadController = AnimationController(
      vsync: this,
      duration: widget.uploadDuration,
    );
    _uploadController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _shotState = ShotState.completed;
        });
        widget.onUploadCompleted?.call(
          SelectedFileData(
            name: _fileName,
            size: _fileSize,
            path: _filePath,
          ),
        );
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  void _cancelTimers() {
    _uploadDelayTimer?.cancel();
    _uploadDelayTimer = null;
    _missedResetTimer?.cancel();
    _missedResetTimer = null;
  }

  @override
  void dispose() {
    _cancelTimers();
    _flightController.removeListener(_onFlightTick);
    _flightController.dispose();
    _netController.dispose();
    _uploadController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _initPositions(Size size) {
    if (_startPos == Offset.zero) {
      _startPos = Offset(70, size.height - 230);
      _basketPos = Offset(size.width / 2, 235);
      _targetPos = _basketPos;
    }
  }

  void _onFlightTick() {
    final t = _flightController.value;
    if (t > 0.8 && !_netController.isAnimating) {
      final p1 = TrajectoryPhysics.getControlPoint(_startPos, _targetPos);
      final currentPos = TrajectoryPhysics.evaluateBezier(_startPos, p1, _targetPos, t);
      if ((currentPos - _basketPos).distance < 35) {
        _netController.forward(from: 0);
      }
    }
  }

  void _onFlightCompleted() {
    if (!mounted) return;

    final distance = (_targetPos - _basketPos).distance;
    final isScore = distance < 45.0;

    if (isScore) {
      setState(() {
        _shotState = ShotState.scored;
      });

      _cancelTimers();
      _uploadDelayTimer = Timer(const Duration(milliseconds: 350), () {
        if (!mounted) return;
        setState(() {
          _shotState = ShotState.uploading;
        });
        _uploadController.forward(from: 0);
      });
    } else {
      setState(() {
        _shotState = ShotState.missed;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Missed! Aim near the basket rim and try again 🏀"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );

      _cancelTimers();
      _missedResetTimer = Timer(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        resetShot();
      });
    }
  }

  /// Launch the projectile flight sequence along the aimed trajectory.
  void launchShot() {
    if (_shotState != ShotState.aiming) return;
    setState(() {
      _shotState = ShotState.flying;
    });
    _flightController.forward(from: 0);
  }

  /// Resets the shot state and animations back to the aiming phase.
  void resetShot() {
    _cancelTimers();
    _flightController.reset();
    _uploadController.reset();
    _netController.reset();

    if (!mounted) return;
    setState(() {
      _shotState = ShotState.aiming;
    });
  }

  /// Demonstration helper that snaps the target position directly to the basket and shoots.
  void snapToBasketAndShoot() {
    setState(() {
      _targetPos = _basketPos;
    });
    launchShot();
  }

  /// Updates current document details and notifies developer callbacks.
  void updateSelectedFile({
    required String name,
    required String size,
    String? path,
  }) {
    if (!mounted) return;
    setState(() {
      _fileName = name;
      _fileSize = size;
      _filePath = path;
      resetShot();
    });

    final fileData = SelectedFileData(
      name: name,
      size: size,
      path: path,
    );

    widget.onFileSelected?.call(fileData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("📄 Selected: $name ($size) — Ready to shoot! 🏀"),
        backgroundColor: widget.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Opens the PDF selection bottom sheet modal.
  Future<void> pickFile() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => PdfPickerBottomSheet(
        currentFileName: _fileName,
        primaryColor: widget.primaryColor,
        sampleFiles: widget.sampleFiles,
        onPdfSelected: (name, size) {
          Navigator.pop(sheetContext);
          updateSelectedFile(name: name, size: size);
        },
        onBrowseDevice: () async {
          Navigator.pop(sheetContext);
          try {
            final files = await FilePicker.pickFiles(
              type: FileType.custom,
              allowedExtensions: widget.allowedExtensions,
            );
            if (files.isNotEmpty && mounted) {
              final file = files.first;
              int? sizeInBytes = file.lengthSync();
              sizeInBytes ??= await file.length();
              final double sizeKb = (sizeInBytes ?? 2048) / 1024.0;
              final String formattedSize = sizeKb >= 1024
                  ? '${(sizeKb / 1024.0).toStringAsFixed(1)} MB'
                  : '${sizeKb.toStringAsFixed(1)} KB';
              updateSelectedFile(
                name: file.name,
                size: formattedSize,
                path: file.path,
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Could not open file picker: $e"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? resolvedAppBar;
    if (widget.customAppBar != null) {
      resolvedAppBar = widget.customAppBar;
    } else if (widget.showAppBar) {
      resolvedAppBar = AppBar(
        title: Text(
          widget.appBarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF1E232A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Choose File",
            icon: Icon(Icons.file_open_rounded, color: widget.primaryColor),
            onPressed: pickFile,
          ),
          IconButton(
            tooltip: "Reset Shot",
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF5A6679)),
            onPressed: resetShot,
          ),
          if (widget.showDemoButton)
            IconButton(
              tooltip: "Perfect Shot Demo",
              icon: Icon(Icons.sports_basketball, color: widget.primaryColor),
              onPressed: snapToBasketAndShoot,
            ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: resolvedAppBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _initPositions(size);

          final isAimedAtBasket = (_targetPos - _basketPos).distance < 45.0;

          return Stack(
            children: [
              // 1. Top Drop Zone & Basketball Goal
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: TopDropZone(
                  isAimed: isAimedAtBasket,
                  netController: _netController,
                  hoopWidth: _hoopWidth,
                  hoopHeight: _hoopHeight,
                  onPickPdf: pickFile,
                  primaryColor: widget.primaryColor,
                  title: widget.title,
                  subtitle: widget.subtitle,
                  badgeText: widget.badgeText,
                ),
              ),

              // 2. Trajectory Dotted Arc
              if (_shotState == ShotState.aiming || _shotState == ShotState.flying)
                Positioned.fill(
                  child: TrajectoryArc(
                    startPos: _startPos,
                    targetPos: _targetPos,
                    flightAnimation: _flightController,
                    isFlying: _shotState == ShotState.flying,
                    dotColor: widget.trajectoryDotColor,
                  ),
                ),

              // 3. Basket Front Rim (layered over trajectory for 3D depth)
              Positioned(
                top: _basketPos.dy - (_hoopHeight / 2),
                left: _basketPos.dx - (_hoopWidth / 2),
                child: IgnorePointer(
                  child: HoopRim(
                    width: _hoopWidth,
                    height: _hoopHeight,
                    frontOnly: true,
                    rimColor: widget.primaryColor,
                  ),
                ),
              ),

              // 4. Interactive Draggable or Flying PDF Document
              if (_shotState == ShotState.aiming)
                Positioned(
                  left: _startPos.dx - 35,
                  top: _startPos.dy - 45,
                  child: DraggablePdfLauncher(
                    fileName: _fileName,
                    isDragging: _isDragging,
                    pulseAnimation: _pulseController,
                    onPanStart: (_) => setState(() => _isDragging = true),
                    onPanUpdate: (details) {
                      setState(() {
                        final newTarget = _targetPos + details.delta;
                        _targetPos = Offset(
                          newTarget.dx.clamp(40.0, size.width - 40.0),
                          newTarget.dy.clamp(120.0, size.height - 100.0),
                        );
                      });
                    },
                    onPanEnd: (_) {
                      setState(() => _isDragging = false);
                      launchShot();
                    },
                    onTap: launchShot,
                  ),
                )
              else if (_shotState == ShotState.flying || _shotState == ShotState.missed)
                FlyingPdfDocument(
                  fileName: _fileName,
                  startPos: _startPos,
                  targetPos: _targetPos,
                  flightAnimation: _flightController,
                  isMissed: _shotState == ShotState.missed,
                ),

              // 5. Aiming Hint Badge
              if (_shotState == ShotState.aiming)
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: AimingHintBadge(
                    isAimedAtBasket: isAimedAtBasket,
                    primaryColor: widget.primaryColor,
                    aimPrompt: widget.aimPrompt,
                    lockedPrompt: widget.lockedPrompt,
                  ),
                ),

              // 6. Upload Status Progress Card
              if (_shotState == ShotState.scored ||
                  _shotState == ShotState.uploading ||
                  _shotState == ShotState.completed)
                Positioned(
                  bottom: 24,
                  left: 20,
                  right: 20,
                  child: UploadStatusCard(
                    fileName: _fileName,
                    fileSize: _fileSize,
                    shotState: _shotState,
                    uploadAnimation: _uploadController,
                    onPickNewFile: pickFile,
                    primaryColor: widget.primaryColor,
                    uploadingText: widget.uploadingText,
                    completedText: widget.completedText,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
