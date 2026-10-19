# Changelog

All notable changes to this project will be documented in this file.

## 0.0.2
* **Auto-Shoot (`autoShootOnSelect`)**: Added optional frictionless auto-shoot directly upon file selection without requiring manual dragging.
* **Real-Time Upload Progress Stream (`uploadProgressStream`)**: Added support for real backend upload progress streams (`0.0` to `1.0`), showing real-time percentages (`Uploading... 45%`).
* **Low-End Device GPU Optimization**: Isolated animated elements (`TrajectoryArc`, `HoopRim`, `FlyingPdfDocument`, `DraggablePdfLauncher`) inside `RepaintBoundary` to prevent full widget invalidation and ensure rock-solid 60 FPS on lower-tier hardware.
* **Cleaner Bottom Sheet**: Removed the 3 hardcoded default sample files from the file picker bottom sheet to eliminate user confusion, displaying only the clean "Browse Files on Device" action by default (custom sample files can still be passed via `sampleFiles`).
* **Clean Idle State (No Pre-selected Fake File)**: The picker now starts in a clean `idle` state with an interactive "Pick File" launcher rather than showing a hardcoded fake PDF (`final_final_v7.pdf`). Trajectory arc and aim physics only activate once a real file is chosen.
* **Layout Polish**: Improved `UploadStatusCard` layout flexibility to prevent RenderFlex overflow with custom fonts and labels.

## 0.0.1

* Initial release of `file_pick_animation`.
* Interactive basketball drop-and-shoot file upload animation.
* Realistic quadratic Bezier flight arc with dynamic projectile rotation and scaling.
* Animated swishing basketball net with mesh wiggle physics.
* Dotted aiming trajectory that reacts to drag-and-aim gestures.
* Support for local device file picking via `file_picker` with customizable file extensions.
* Built-in support for preset sample documents.
* Upload progress bar card with completed state and replay action.
* Comprehensive developer customizations: colors, titles, labels, durations, and callbacks (`onFileSelected`, `onUploadCompleted`).
* Zero memory leak architecture with managed controllers and timers.
