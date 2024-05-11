part of 'media_bloc.dart';

@immutable
sealed class MediaEvent {}

final class GetMediaEvent extends MediaEvent {}

final class GetMoreMediaEvent extends MediaEvent {
  final void Function() updateLoadingMoreStatus;
  GetMoreMediaEvent({required this.updateLoadingMoreStatus});
}

final class SearchMediaEvent extends MediaEvent {
  final String query;
  SearchMediaEvent({required this.query});
}
