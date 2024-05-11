import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/config/size_config.dart';
import '../../../core/enums/media_type.dart';
import '../../../core/utils/time_util.dart';
import '../../../core/widgets/video_placeholder.dart';
import '../../domain/entities/media.dart';

class DetailPage extends StatefulWidget {
  static Route route(Media media) {
    return MaterialPageRoute(
      builder: (context) => DetailPage(media: media),
    );
  }

  final Media media;
  const DetailPage({super.key, required this.media});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.media.mediaType == MediaType.video) _initializeYoutubePlayer();
  }

  @override
  void dispose() {
    if (widget.media.mediaType == MediaType.video) _controller.dispose();
    super.dispose();
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
                child: _buildImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInternetStatus(),
                  _buildTitle(),
                  const SizedBox(height: 8),
                  _buildDate(),
                  const SizedBox(height: 24),
                  _buildExplanation(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInternetStatus() {
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

  Widget _buildTitle() {
    return Text(
      widget.media.title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDate() {
    return Text(
      TimeUtil.formatDate(
        Localizations.localeOf(context),
        widget.media.date,
      ),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildExplanation() {
    return Text(
      widget.media.explanation,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 12,
      ),
    );
  }

  Widget _buildImage() {
    switch (widget.media.mediaType) {
      case MediaType.image:
        return CachedNetworkImage(
          imageUrl: widget.media.url,
          width: SizeConfig.screenWidth,
          fit: BoxFit.cover,
        );
      case MediaType.imageFile:
        return Image.file(
          File(widget.media.url),
          width: SizeConfig.screenWidth,
          fit: BoxFit.cover,
        );
      case MediaType.video:
        return YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        );
      case MediaType.videoFile:
        return const VideoPlaceholder();
    }
  }

  void _initializeYoutubePlayer() {
    _controller = YoutubePlayerController(
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
}
