import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/enums/media_type.dart';
import '../../../core/config/size_config.dart';
import '../../../core/utils/time_util.dart';
import '../../../core/widgets/video_placeholder.dart';
import '../../domain/entities/media.dart';
import '../pages/detail_page.dart';

class MediaItem extends StatelessWidget {
  final Media media;
  const MediaItem({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    return GestureDetector(
      onTap: () => Navigator.push(context, DetailPage.route(media)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Hero(
              tag: media.url,
              child: Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: _buildImage(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 4),
                  _buildDate(currentLocale),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      media.title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDate(Locale currentLocale) {
    return Text(
      TimeUtil.formatDate(currentLocale, media.date),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  Widget _buildImage() {
    switch (media.mediaType) {
      case MediaType.image:
        return _buildNetworkImage();
      case MediaType.imageFile:
        return _buildLocalImage();
      case MediaType.video:
      case MediaType.videoFile:
        return const VideoPlaceholder();
    }
  }

  Widget _buildNetworkImage() {
    return Container(
      color: Colors.grey,
      height: 220,
      width: SizeConfig.screenWidth,
      child: CachedNetworkImage(
        imageUrl: media.url,
        height: 220,
        width: SizeConfig.screenWidth,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildLocalImage() {
    return Image.file(
      File(media.url),
      height: 220,
      width: SizeConfig.screenWidth,
      fit: BoxFit.cover,
    );
  }
}
