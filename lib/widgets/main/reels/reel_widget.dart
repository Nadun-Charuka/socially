import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/models/reel_model.dart';
import 'package:socially/services/auth/auth_services.dart';
import 'package:socially/services/reels/reels_service.dart';
import 'package:socially/widgets/main/reels/video_player_widget.dart';

class ReelWidget extends ConsumerStatefulWidget {
  final ReelModel reel;
  const ReelWidget({super.key, required this.reel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReelWidgetState();
}

class _ReelWidgetState extends ConsumerState<ReelWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    width: 40,
                    height: 40,
                    imageUrl: widget.reel.userProfileImg,
                    errorWidget: (context, url, error) => Icon(Icons.person),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  widget.reel.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Text(
              widget.reel.caption,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayerWidget(
                videoUrl: widget.reel.videoUrl,
                reel: widget.reel,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {
                    // Handle like functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
