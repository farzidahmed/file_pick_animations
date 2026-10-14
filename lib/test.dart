import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// Models & Utilities
import 'models/shot_state.dart';
import 'utils/trajectory_physics.dart';

// Modular Subwidgets
import 'widgets/aiming_hint_badge.dart';
import 'widgets/draggable_pdf_launcher.dart';
import 'widgets/flying_pdf_document.dart';
import 'widgets/hoop_rim.dart';
import 'widgets/pdf_picker_bottom_sheet.dart';
import 'widgets/top_drop_zone.dart';
import 'widgets/trajectory_arc.dart';
import 'widgets/upload_status_card.dart';

// Export models and widgets so external files importing test.dart continue working seamlessly
export 'models/shot_state.dart';
export 'widgets/pdf_document_widget.dart';
export 'widgets/upload_status_card.dart';

/// Main interactive screen for the Basketball Drop & Shoot PDF upload animation.
class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> with TickerProviderStateMixin {
  // ---------------------------------------------------------------------------
  // Animation Controllers
  // ---------------------------------------------------------------------------
  late final AnimationController _flightController;
  late final AnimationController _netController;
  late final AnimationController _uploadController;
  late final AnimationController _pulseController;

  // ---------------------------------------------------------------------------
  // Timers (Explicitly managed to prevent memory leaks on unmount)
  // ---------------------------------------------------------------------------
  Timer? _uploadDelayTimer;
  Timer? _missedResetTimer;

  // ---------------------------------------------------------------------------
  // State Variables
  // ---------------------------------------------------------------------------
  ShotState _shotState = ShotState.aiming;
  bool _isDragging = false;

  String _fileName = "final_final_v7.pdf";
  String _fileSize = "2.4 MB";

  // Coordinates calculated dynamically in LayoutBuilder
  Offset _startPos = Offset.zero;
  Offset _targetPos = Offset.zero;
  Offset _basketPos = Offset.zero;

  // Hoop Dimensions
  static const double _hoopWidth = 100.0;
  static const double _hoopHeight = 22.0;

  @override
  void initState() {
    super.initState();
    _initAnimationControllers();
  }

  /// Initialize all animation controllers with bounded lifecycles.
  void _initAnimationControllers() {
    // 1. Flight Controller
    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _flightController.addListener(_onFlightTick);
    _flightController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onFlightCompleted();
      }
    });

    // 2. Net Swish Controller
    _netController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // 3. Upload Progress Bar Controller
    _uploadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _uploadController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _shotState = ShotState.completed;
        });
      }
    });

    // 4. Subtle pulsing icon indicator
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  /// Cancels all active timers to prevent memory leaks or calling setState after dispose.
  void _cancelTimers() {
    _uploadDelayTimer?.cancel();
    _uploadDelayTimer = null;
    _missedResetTimer?.cancel();
    _missedResetTimer = null;
  }

  @override
  void dispose() {
    // 1. Cancel all background timers immediately
    _cancelTimers();

    // 2. Remove listeners to prevent lingering references
    _flightController.removeListener(_onFlightTick);

    // 3. Dispose all controllers to free Ticker and GPU resources
    _flightController.dispose();
    _netController.dispose();
    _uploadController.dispose();
    _pulseController.dispose();

    super.dispose();
  }

  /// Calculates positions based on the available screen layout.
  void _initPositions(Size size) {
    if (_startPos == Offset.zero) {
      _startPos = Offset(70, size.height - 230);
      _basketPos = Offset(size.width / 2, 235);
      _targetPos = _basketPos;
    }
  }

  /// Trigger net wiggle if the flying ball/document passes close to the hoop.
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

  /// Evaluates shot score or miss when flight trajectory completes.
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
        _resetShot();
      });
    }
  }

  /// Starts the launch sequence.
  void _launchShot() {
    if (_shotState != ShotState.aiming) return;
    setState(() {
      _shotState = ShotState.flying;
    });
    _flightController.forward(from: 0);
  }

  /// Resets shot state and controllers back to ready/aiming phase.
  void _resetShot() {
    _cancelTimers();
    _flightController.reset();
    _uploadController.reset();
    _netController.reset();

    if (!mounted) return;
    setState(() {
      _shotState = ShotState.aiming;
    });
  }

  /// Perfect shot demonstration button handler.
  void _snapToBasket() {
    setState(() {
      _targetPos = _basketPos;
    });
    _launchShot();
  }

  /// Updates current document details when a new PDF is selected.
  void _onPdfSelected(String name, String size) {
    if (!mounted) return;
    setState(() {
      _fileName = name;
      _fileSize = size;
      _resetShot();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("📄 Selected: $name ($size) — Ready to shoot! 🏀"),
        backgroundColor: const Color(0xFFEE5A24),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Opens the PDF selection bottom sheet.
  Future<void> _pickPdfFile() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => PdfPickerBottomSheet(
        currentFileName: _fileName,
        onPdfSelected: (name, size) {
          Navigator.pop(sheetContext);
          _onPdfSelected(name, size);
        },
        onBrowseDevice: () async {
          Navigator.pop(sheetContext);
          try {
            final files = await FilePicker.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );
            if (files.isNotEmpty && mounted) {
              final file = files.first;
              int? sizeInBytes = file.lengthSync();
              sizeInBytes ??= await file.length();
              final double sizeKb = (sizeInBytes ?? 2048) / 1024.0;
              final String formattedSize = sizeKb >= 1024
                  ? '${(sizeKb / 1024.0).toStringAsFixed(1)} MB'
                  : '${sizeKb.toStringAsFixed(1)} KB';
              _onPdfSelected(file.name, formattedSize);
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

  // ---------------------------------------------------------------------------
  // Build Method
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: _buildAppBar(),
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
                  onPickPdf: _pickPdfFile,
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
                  ),
                ),

              // 3. Basket Front Rim (layered over trajectory for 3D depth)
              Positioned(
                top: _basketPos.dy - (_hoopHeight / 2),
                left: _basketPos.dx - (_hoopWidth / 2),
                child: const IgnorePointer(
                  child: HoopRim(
                    width: _hoopWidth,
                    height: _hoopHeight,
                    frontOnly: true,
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
                      _launchShot();
                    },
                    onTap: _launchShot,
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
                  child: AimingHintBadge(isAimedAtBasket: isAimedAtBasket),
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
                    onPickNewFile: _pickPdfFile,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Drop & Shoot Upload",
        style: TextStyle(
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
          tooltip: "Choose PDF File",
          icon: const Icon(Icons.file_open_rounded, color: Color(0xFFEE5A24)),
          onPressed: _pickPdfFile,
        ),
        IconButton(
          tooltip: "Reset Shot",
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFF5A6679)),
          onPressed: _resetShot,
        ),
        IconButton(
          tooltip: "Perfect Shot Demo",
          icon: const Icon(Icons.sports_basketball, color: Color(0xFFEE5A24)),
          onPressed: _snapToBasket,
        ),
      ],
    );
  }
}
