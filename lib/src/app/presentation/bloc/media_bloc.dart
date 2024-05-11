import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/usecase/usecase.dart';
import '../../domain/entities/media.dart';
import '../../domain/usecases/get_media.dart';
import '../../domain/usecases/get_more_media.dart';
import '../../domain/usecases/search_media.dart';

part 'media_event.dart';
part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final GetMedia _getMedia;
  final GetMoreMedia _getMoreMedia;
  final SearchMedia _searchMedia;
  MediaBloc({
    required GetMedia getMedia,
    required GetMoreMedia getMoreMedia,
    required SearchMedia searchMedia,
  })  : _getMedia = getMedia,
        _getMoreMedia = getMoreMedia,
        _searchMedia = searchMedia,
        super(MediaInitial()) {
    on<GetMediaEvent>(_onGetMedia);
    on<GetMoreMediaEvent>(_onGetMoreMedia);
    on<SearchMediaEvent>(_onSearchMedia);
  }

  List<Media> baseMediaList = [];

  void _onGetMedia(
    GetMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaLoading());
    final result = await _getMedia(NoParams());

    result.fold(
      (failure) => emit(MediaFailure(failure.message)),
      (mediaList) {
        baseMediaList = mediaList;
        emit(MediaDisplayState(mediaList: baseMediaList));
      },
    );
  }

  void _onGetMoreMedia(
    GetMoreMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    final result = await _getMoreMedia(
      GetMoreMediaParams(
        mediaList: baseMediaList,
      ),
    );

    result.fold(
      (failure) => emit(MediaFailure(failure.message)),
      (mediaList) {
        baseMediaList.addAll(mediaList);
        event.updateLoadingMoreStatus();
        final hasMoreData = mediaList.isNotEmpty;
        emit(
          MediaDisplayState(
            mediaList: baseMediaList,
            hasMoreData: hasMoreData,
          ),
        );
      },
    );
  }

  void _onSearchMedia(
    SearchMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(MediaDisplayState(mediaList: baseMediaList));
      return;
    }
    final result = await _searchMedia(
      SearchMediaParams(
        mediaList: baseMediaList,
        query: event.query,
      ),
    );

    result.fold(
      (failure) => emit(MediaFailure(failure.message)),
      (mediaList) => emit(MediaDisplayState(mediaList: mediaList)),
    );
  }
}
