import 'package:flutter/material.dart';

import '../config/size_config.dart';

class VideoPlaceholder extends StatelessWidget {
  const VideoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/video_placeholder.png',
      height: 220,
      width: SizeConfig.screenWidth,
      fit: BoxFit.cover,
    );
  }
}
