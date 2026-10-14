import 'dart:typed_data';

/// Details of the file selected or uploaded through the animation.
class SelectedFileData {
  /// The file name including its extension (e.g. "report.pdf").
  final String name;

  /// The human-readable formatted file size (e.g. "2.4 MB").
  final String size;

  /// The local file system path, if available.
  final String? path;

  /// Raw byte contents of the file, if read into memory.
  final Uint8List? bytes;

  const SelectedFileData({
    required this.name,
    required this.size,
    this.path,
    this.bytes,
  });

  @override
  String toString() => 'SelectedFileData(name: $name, size: $size, path: $path)';
}
