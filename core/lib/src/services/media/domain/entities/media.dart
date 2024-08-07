// Core module imports
import 'package:core/src/enums/media_type.dart';

class Media {
  final String url;
  final String title;
  final String explanation;
  final MediaType mediaType;
  final DateTime date;

  const Media({
    required this.url,
    required this.title,
    required this.explanation,
    required this.mediaType,
    required this.date,
  });
}
