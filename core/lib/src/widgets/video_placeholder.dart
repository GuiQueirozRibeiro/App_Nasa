// External packages
import 'package:flutter/material.dart';

class VideoPlaceholder extends StatelessWidget {
  const VideoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/video_placeholder.png',
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
