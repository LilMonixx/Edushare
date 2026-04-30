import 'package:flutter/material.dart';

class MediaFile {
  final String title;
  final String size;
  final String time;
  final bool isVideo;
  final String? duration;

  MediaFile({
    required this.title,
    required this.size,
    required this.time,
    required this.isVideo,
    this.duration,
  });
}

class MediaItem extends StatelessWidget {
  final MediaFile media;

  const MediaItem({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Thumbnail giả lập
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                ),

                /// Label
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: media.isVideo
                          ? const Color(0xFF1ED760)
                          : const Color(0xFF2D8CFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      media.isVideo ? "VIDEO" : "IMAGE",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Icon(
                    media.isVideo ? Icons.videocam : Icons.image,
                    size: 40,
                    color: Colors.white70,
                  ),
                ),

                if (media.isVideo && media.duration != null)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        media.duration!,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  )
              ],
            ),
          ),

          /// Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  media.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${media.size} · ${media.time}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}