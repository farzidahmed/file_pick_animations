import 'package:flutter/material.dart';
import '../models/sample_file.dart';

/// Bottom Sheet for picking files from device or choosing from preset samples.
class PdfPickerBottomSheet extends StatelessWidget {
  final String currentFileName;
  final void Function(String name, String size) onPdfSelected;
  final VoidCallback onBrowseDevice;
  final Color primaryColor;
  final List<SampleFile>? sampleFiles;
  final String sheetTitle;
  final String sheetSubtitle;
  final String browseDeviceText;
  final String browseDeviceSubtitle;
  final String sampleSectionTitle;

  const PdfPickerBottomSheet({
    super.key,
    required this.currentFileName,
    required this.onPdfSelected,
    required this.onBrowseDevice,
    this.primaryColor = const Color(0xFFEE5A24),
    this.sampleFiles,
    this.sheetTitle = "Select File",
    this.sheetSubtitle = "Choose a file from your device to upload",
    this.browseDeviceText = "Browse Files on Device",
    this.browseDeviceSubtitle = "Select any supported file from local storage",
    this.sampleSectionTitle = "Or select sample document:",
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSamples = sampleFiles ?? const [];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E5EC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              sheetTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E232A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sheetSubtitle,
              style: const TextStyle(fontSize: 13, color: Color(0xFF8A94A6)),
            ),
            const SizedBox(height: 18),

            // Device Browse Tile
            InkWell(
              onTap: onBrowseDevice,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.folder_open_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            browseDeviceText,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E232A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            browseDeviceSubtitle,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF8A94A6)),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: primaryColor),
                  ],
                ),
              ),
            ),

            if (effectiveSamples.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                sampleSectionTitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5A6679),
                ),
              ),
              const SizedBox(height: 8),

              ...effectiveSamples.map(
                (sample) => SamplePdfTile(
                  name: sample.name,
                  size: sample.size,
                  isSelected: currentFileName == sample.name,
                  primaryColor: primaryColor,
                  onTap: () => onPdfSelected(sample.name, sample.size),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Reusable sample PDF document tile.
class SamplePdfTile extends StatelessWidget {
  final String name;
  final String size;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const SamplePdfTile({
    super.key,
    required this.name,
    required this.size,
    required this.isSelected,
    this.primaryColor = const Color(0xFFEE5A24),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.08)
              : const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFE2E7EE),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFE53935), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: const Color(0xFF1E232A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              size,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8A94A6)),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check_circle_rounded, color: primaryColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
