import 'package:flutter/material.dart';
import 'package:socially/models/reel_model.dart';
import 'package:socially/services/auth/auth_services.dart';
import 'package:socially/services/reels/reels_service.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final ReelModel reel;
  final String videoUrl;
  const VideoPlayerWidget(
      {super.key, required this.videoUrl, required this.reel});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    await _videoPlayerController!.initialize();
    _videoPlayerController!.setLooping(true);
    _videoPlayerController!.play();

    setState(() {
      _isPlaying = true;
    });
  }

  void togglePlayPause() {
    if (_videoPlayerController == null) return;

    if (_isPlaying) {
      _videoPlayerController!.pause();
    } else {
      _videoPlayerController!.play();
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _videoPlayerController;

    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
        Positioned(
          bottom: 16,
          child: IconButton(
            iconSize: 40,
            color: Colors.white,
            onPressed: togglePlayPause,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          ),
        ),
        if (widget.reel.userId == AuthService().currentUser!.uid)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              iconSize: 40,
              color: Colors.red,
              onPressed: () async {
                await ReelsService()
                    .deletReel(widget.reel.reelId, widget.reel.videoUrl);
              },
              icon: Icon(Icons.delete),
            ),
          )
      ],
    );
  }
}
