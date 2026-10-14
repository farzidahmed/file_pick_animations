import 'package:flutter/material.dart';
import '../models/shot_state.dart';
import 'mini_pdf_icon.dart';

/// Upload Progress / Completed Card.
class UploadStatusCard extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final ShotState shotState;
  final Animation<double> uploadAnimation;
  final VoidCallback onPickNewFile;

  const UploadStatusCard({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.shotState,
    required this.uploadAnimation,
    required this.onPickNewFile,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = shotState == ShotState.completed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const MiniPdfIcon(),
          const SizedBox(width: 14),

          // File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E232A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  fileSize,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A94A6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Progress Bar with fine-grained animation builder
          SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isDone) ...[
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 15,
                        color: Color(0xFF2E7D32),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      isDone ? "Completed" : "Uploading...",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDone
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF8A94A6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: uploadAnimation,
                  builder: (context, _) {
                    final progress = isDone ? 1.0 : uploadAnimation.value;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: const Color(0xFFEDF1F7),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDone
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFEE5A24),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Replay button when finished
          if (isDone)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.replay_rounded, color: Color(0xFF5A6679)),
                tooltip: "Upload another file",
                onPressed: onPickNewFile,
              ),
            ),
        ],
      ),
    );
  }
}
