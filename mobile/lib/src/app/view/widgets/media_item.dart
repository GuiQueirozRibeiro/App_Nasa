// Dart native imports
import 'dart:io';

// External packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

// Mobile application imports
import 'package:mobile/src/common/widgets/video_placeholder.dart';

class MediaItem extends StatelessWidget {
  final Media media;
  const MediaItem({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    return GestureDetector(
      onTap: () => Modular.to.pushNamed('detail', arguments: media),
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
                  child: buildImage(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle(),
                  const SizedBox(height: 4),
                  buildDate(currentLocale),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      media.title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  Widget buildDate(Locale currentLocale) {
    return Text(
      TimeUtil.formatDate(currentLocale, media.date),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  Widget buildImage() {
    switch (media.mediaType) {
      case MediaType.image:
        return buildNetworkImage();
      case MediaType.imageFile:
        return buildLocalImage();
      case MediaType.video:
      case MediaType.videoFile:
        return const VideoPlaceholder();
    }
  }

  Widget buildNetworkImage() {
    return Container(
      color: Colors.grey,
      height: 220,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: media.url,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildLocalImage() {
    return Image.file(
      File(media.url),
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
