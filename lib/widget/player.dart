import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:marvel_what_if/widget/background_cover.dart';
import 'package:video_player/video_player.dart';


class Player extends StatefulWidget {
  const Player({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.networkUrl(
      Uri.parse("https://d3eppa16o5gzed.cloudfront.net/s1/What.If.2021.${widget.videoUrl}.(NKIRI.COM).mkv"),
    );
    
    await Future.wait([
      _videoPlayerController1.initialize(),
    ]);

    _createChewieController();

    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 1),

    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BackgroundCover(
        child: Expanded(
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: _chewieController != null &&
                    _chewieController!
                        .videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController!)
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading'),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}