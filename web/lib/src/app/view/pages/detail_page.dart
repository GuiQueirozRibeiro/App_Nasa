// Dart native imports
import 'dart:io';

// External packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Web application imports
import 'package:web/src/common/widgets/video_placeholder.dart';

class DetailPage extends StatefulWidget {
  final Media media;

  const DetailPage({super.key, required this.media});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late YoutubePlayerController youtubeController;

  @override
  void initState() {
    super.initState();
    if (widget.media.mediaType == MediaType.video) initializeYoutubePlayer();
  }

  @override
  void dispose() {
    if (widget.media.mediaType == MediaType.video) youtubeController.dispose();
    super.dispose();
  }

  void initializeYoutubePlayer() {
    youtubeController = YoutubePlayerController(
      initialVideoId: extractVideoId(widget.media.url),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  String extractVideoId(String url) {
    RegExp regExp = RegExp(
      r'^.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    Match? match = regExp.firstMatch(url);
    return (match != null && match.groupCount >= 1) ? match.group(1)! : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('detail_page'.i18n())),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: widget.media.url,
              child: Center(
                child: buildImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInternetStatus(),
                  buildTitle(),
                  const SizedBox(height: 8),
                  buildDate(),
                  const SizedBox(height: 24),
                  buildExplanation(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInternetStatus() {
    if (widget.media.mediaType == MediaType.videoFile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          'need_internet'.i18n(),
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget buildTitle() {
    return Text(
      widget.media.title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget buildDate() {
    return Text(
      TimeUtil.formatDate(
        Localizations.localeOf(context),
        widget.media.date,
      ),
      style: Theme.of(context).textTheme.labelSmall,
    );
  }

  Widget buildExplanation() {
    return Text(
      widget.media.explanation,
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget buildImage() {
    switch (widget.media.mediaType) {
      case MediaType.image:
        return CachedNetworkImage(
          imageUrl: widget.media.url,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      case MediaType.imageFile:
        return Image.file(
          File(widget.media.url),
          width: double.infinity,
          fit: BoxFit.cover,
        );
      case MediaType.video:
        return YoutubePlayer(
          controller: youtubeController,
          showVideoProgressIndicator: true,
        );
      case MediaType.videoFile:
        return const VideoPlaceholder();
    }
  }
}
