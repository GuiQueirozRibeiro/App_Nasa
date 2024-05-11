part of 'media_bloc.dart';

@immutable
sealed class MediaState {}

final class MediaInitial extends MediaState {}

final class MediaLoading extends MediaState {}

final class MediaFailure extends MediaState {
  final String error;
  MediaFailure(this.error);
}

final class MediaDisplayState extends MediaState {
  final List<Media> mediaList;
  final bool hasMoreData;

  MediaDisplayState({required this.mediaList, this.hasMoreData = true});
}
