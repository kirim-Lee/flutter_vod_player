import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:vod_player/components/custom_icon_button.dart';

class CustomVideoPlayer extends StatefulWidget{
  final XFile video;

  const CustomVideoPlayer({required this.video, Key? key}): super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayer();
}

class _CustomVideoPlayer extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();

    initializeController(); // 컨트롤러 초기화
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return const Center(child: CircularProgressIndicator(),);
    }

    return AspectRatio(
      aspectRatio: videoController!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(
              videoController!
          ),
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
          Align(
            alignment: Alignment.topRight,
            child: CustomIconButton(
              onPressed: (){},
              iconData: Icons.photo_camera_back,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomIconButton(onPressed: () {}, iconData: Icons.rotate_left),
                CustomIconButton(onPressed: (){}, iconData: videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow),
                CustomIconButton(onPressed: (){}, iconData: Icons.rotate_right),
              ],
            )
          )
        ],
      ),
    );
  }

  initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize();

    setState(() {
      this.videoController = videoController;
    });
  }
}