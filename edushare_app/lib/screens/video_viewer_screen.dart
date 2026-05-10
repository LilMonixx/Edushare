import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoViewerScreen extends StatefulWidget {

  final String videoUrl;

  const VideoViewerScreen({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoViewerScreen> createState() => _VideoViewerScreenState();
}

class _VideoViewerScreenState extends State<VideoViewerScreen> {

  late VideoPlayerController videoController;
  ChewieController? chewieController;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  Future<void> initVideo() async {

    videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    await videoController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
    );

    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
      ),

      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Chewie(controller: chewieController!),
      ),
    );
  }
}