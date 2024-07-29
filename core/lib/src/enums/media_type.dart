enum MediaType {
  image,
  imageFile,
  video,
  videoFile,
}

MediaType mapStringToMediaType(String mediaType) {
  switch (mediaType) {
    case 'image':
      return MediaType.image;
    case 'image_file':
      return MediaType.imageFile;
    case 'video':
      return MediaType.video;
    case 'video_file':
      return MediaType.videoFile;
    default:
      throw Exception('${'unknown_media'}: $mediaType');
  }
}

extension MediaTypeExtension on MediaType {
  String toDatabaseString() {
    switch (this) {
      case MediaType.image:
        return 'image';
      case MediaType.imageFile:
        return 'image_file';
      case MediaType.video:
        return 'video';
      case MediaType.videoFile:
        return 'video_file';
    }
  }
}
