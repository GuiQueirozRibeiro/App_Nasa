// Core module imports
import 'package:core/src/enums/media_type.dart';
import 'package:core/src/services/media/domain/entities/media.dart';

class MediaModel extends Media {
  const MediaModel({
    required super.url,
    required super.title,
    required super.explanation,
    required super.mediaType,
    required super.date,
  });

  Media toMedia() {
    return Media(
      url: url,
      title: title,
      explanation: explanation,
      mediaType: mediaType,
      date: date,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'url': url,
      'title': title,
      'explanation': explanation,
      'media_type': mediaType.toDatabaseString(),
      'date': date.toIso8601String(),
    };
  }

  factory MediaModel.fromJson(Map<String, dynamic> map) {
    return MediaModel(
      url: map['url'] as String,
      title: map['title'] as String,
      explanation: map['explanation'] as String,
      mediaType: mapStringToMediaType(map['media_type'] as String),
      date: map['date'] == null ? DateTime.now() : DateTime.parse(map['date']),
    );
  }

  MediaModel copyWith({
    String? url,
    String? title,
    String? explanation,
    MediaType? mediaType,
    DateTime? date,
  }) {
    return MediaModel(
      url: url ?? this.url,
      title: title ?? this.title,
      explanation: explanation ?? this.explanation,
      mediaType: mediaType ?? this.mediaType,
      date: date ?? this.date,
    );
  }
}
