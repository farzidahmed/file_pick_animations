/// Represents a preset sample file option presented in the bottom sheet.
class SampleFile {
  /// Display name of the document.
  final String name;

  /// Approximate or displayed file size.
  final String size;

  /// Optional asset or local path.
  final String? path;

  const SampleFile({
    required this.name,
    required this.size,
    this.path,
  });
}
