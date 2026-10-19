import 'package:flutter/material.dart';
import '../models/shot_state.dart';
import 'mini_pdf_icon.dart';

/// Upload Progress / Completed Card.
class UploadStatusCard extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final ShotState shotState;
  final Animation<double>? uploadAnimation;
  final double? progress;
  final VoidCallback onPickNewFile;
  final Color primaryColor;
  final Color completedColor;
  final String uploadingText;
  final String completedText;

  const UploadStatusCard({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.shotState,
    this.uploadAnimation,
    this.progress,
    required this.onPickNewFile,
    this.primaryColor = const Color(0xFFEE5A24),
    this.completedColor = const Color(0xFF2E7D32),
    this.uploadingText = "Uploading...",
    this.completedText = "Completed",
  });

  @override
  Widget build(BuildContext context) {
    final isDone = shotState == ShotState.completed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          const SizedBox(width: 10),

          // File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E232A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  fileSize,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8A94A6),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Progress Bar with fine-grained animation builder
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 90, maxWidth: 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: uploadAnimation ?? const AlwaysStoppedAnimation(0.0),
                  builder: (context, _) {
                    final currentProgress = isDone
                        ? 1.0
                        : (progress ?? uploadAnimation?.value ?? 0.0);
                    final pct = (currentProgress.clamp(0.0, 1.0) * 100).toInt();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isDone) ...[
                              Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: completedColor,
                              ),
                              const SizedBox(width: 3),
                            ],
                            Flexible(
                              child: Text(
                                isDone
                                    ? completedText
                                    : (progress != null
                                        ? '$uploadingText $pct%'
                                        : uploadingText),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDone
                                      ? completedColor
                                      : const Color(0xFF8A94A6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: currentProgress.clamp(0.0, 1.0),
                            minHeight: 5,
                            backgroundColor: const Color(0xFFEDF1F7),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDone ? completedColor : primaryColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // Replay button when finished
          if (isDone)
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: const Icon(Icons.replay_rounded, color: Color(0xFF5A6679), size: 20),
                tooltip: "Upload another file",
                onPressed: onPickNewFile,
              ),
            ),
        ],
      ),
    );
  }
}
