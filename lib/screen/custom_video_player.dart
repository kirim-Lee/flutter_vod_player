import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:vod_player/components/custom_icon_button.dart';

const second3 = Duration(seconds: 3);

class CustomVideoPlayer extends StatefulWidget{
  final XFile video;
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key
  }): super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayer();
}

class _CustomVideoPlayer extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  bool showControls = false;

  @override
  void initState() {
    super.initState();

    initializeController(); // 컨트롤러 초기화
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return const Center(child: CircularProgressIndicator(),);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child:  AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(
                videoController!
            ),
            if(showControls)
              Container(color: Colors.black.withOpacity(0.5)),
            Positioned(
              bottom:0,
              right:0,
              left:0,
              child: Slider(
                  onChanged: (double val) {
                    videoController!.seekTo(Duration(seconds: val.toInt()));
                  },
                  value: videoController!.value.position.inSeconds.toDouble(),
                  min: 0,
                  max: videoController!.value.duration.inSeconds.toDouble()
              ),
            ),
            if (showControls)
              Align(
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  onPressed: widget.onNewVideoPressed,
                  iconData: Icons.photo_camera_back,
                ),
              ),
            if (showControls)
              Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomIconButton(onPressed: onReversePressed, iconData: Icons.rotate_left),
                      CustomIconButton(onPressed: onPlayPressed, iconData: videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow),
                      CustomIconButton(onPressed: onForwardPressed, iconData: Icons.rotate_right),
                    ],
                  )
              )
          ],
        ),
      ),
    );
  }

  initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize();

    videoController.addListener(videoControllerListener);

    setState(() {
      this.videoController = videoController;
    });
  }

  void videoControllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    videoController!.removeListener(videoControllerListener);
    super.dispose();
  }

  void onReversePressed () {
    final currentPosition = videoController!.value.position;

    Duration position = const Duration();

    if(currentPosition.inSeconds > 3) { // 3초보다 길때만
      position = currentPosition - second3;
    }

    videoController!.seekTo(position);
  }

  void onForwardPressed () {
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;

    Duration position = maxPosition;

    if ((maxPosition - second3).inSeconds > currentPosition.inSeconds ) {
      position = currentPosition + second3;
    }

    videoController!.seekTo(position);
  }

  void onPlayPressed () {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}