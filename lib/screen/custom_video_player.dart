import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomVideoPlayer extends StatefulWidget{
  final XFile video;

  const CustomVideoPlayer({required this.video, Key? key}): super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayer();
}

class _CustomVideoPlayer extends State<CustomVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child:  Text(
        'CustomVideoPlayer',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}