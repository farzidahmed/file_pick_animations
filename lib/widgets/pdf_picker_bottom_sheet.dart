import 'package:flutter/material.dart';

/// Bottom Sheet for picking PDF from device or choosing sample files.
class PdfPickerBottomSheet extends StatelessWidget {
  final String currentFileName;
  final void Function(String name, String size) onPdfSelected;
  final VoidCallback onBrowseDevice;

  const PdfPickerBottomSheet({
    super.key,
    required this.currentFileName,
    required this.onPdfSelected,
    required this.onBrowseDevice,
  });

  @override
  Widget build(BuildContext context) {
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
            const Text(
              "Select PDF File",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E232A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Choose a PDF file from your device or pick a sample document",
              style: TextStyle(fontSize: 13, color: Color(0xFF8A94A6)),
            ),
            const SizedBox(height: 18),

            // Device Browse Tile
            InkWell(
              onTap: onBrowseDevice,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEE5A24).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFEE5A24).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFEE5A24),
                      child: Icon(Icons.folder_open_rounded, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Browse Files on Device",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E232A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Select any .pdf file from local storage",
                            style: TextStyle(fontSize: 12, color: Color(0xFF8A94A6)),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFEE5A24)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),
            const Text(
              "Or select sample PDF:",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A6679),
              ),
            ),
            const SizedBox(height: 8),

            SamplePdfTile(
              name: "final_final_v7.pdf",
              size: "2.4 MB",
              isSelected: currentFileName == "final_final_v7.pdf",
              onTap: () => onPdfSelected("final_final_v7.pdf", "2.4 MB"),
            ),
            SamplePdfTile(
              name: "Portfolio_Resume_2026.pdf",
              size: "1.8 MB",
              isSelected: currentFileName == "Portfolio_Resume_2026.pdf",
              onTap: () => onPdfSelected("Portfolio_Resume_2026.pdf", "1.8 MB"),
            ),
            SamplePdfTile(
              name: "Business_Contract_v3.pdf",
              size: "3.5 MB",
              isSelected: currentFileName == "Business_Contract_v3.pdf",
              onTap: () => onPdfSelected("Business_Contract_v3.pdf", "3.5 MB"),
            ),
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
  final VoidCallback onTap;

  const SamplePdfTile({
    super.key,
    required this.name,
    required this.size,
    required this.isSelected,
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
              ? const Color(0xFFEE5A24).withValues(alpha: 0.08)
              : const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFEE5A24)
                : const Color(0xFFE2E7EE),
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
              const Icon(Icons.check_circle_rounded, color: Color(0xFFEE5A24), size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
