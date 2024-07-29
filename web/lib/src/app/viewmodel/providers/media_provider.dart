// External packages
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class MediaProvider with ChangeNotifier {
  final GetMedia _getMedia;
  final GetMoreMedia _getMoreMedia;
  final SearchMedia _searchMedia;
  MediaProvider({
    required GetMedia getMedia,
    required GetMoreMedia getMoreMedia,
    required SearchMedia searchMedia,
  })  : _getMedia = getMedia,
        _getMoreMedia = getMoreMedia,
        _searchMedia = searchMedia;

  List<Media> _baseMediaList = [];
  List<Media> get baseMediaList => _baseMediaList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> getMedia() async {
    _isLoading = true;
    notifyListeners();

    final result = await _getMedia(const NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (mediaList) {
        _baseMediaList = mediaList;
        _errorMessage = '';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> getMoreMedia() async {
    _isLoading = true;
    notifyListeners();

    final date = baseMediaList.last.date.subtract(const Duration(days: 1));
    final result = await _getMoreMedia(GetMoreMediaParams(date: date));

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (mediaList) {
        _baseMediaList.addAll(mediaList);
        _hasMoreData = mediaList.isNotEmpty;
        _errorMessage = '';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> searchMedia(String query) async {
    _isLoading = true;
    notifyListeners();

    final result = await _searchMedia(
      SearchMediaParams(
        mediaList: baseMediaList,
        query: query,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (mediaList) {
        _baseMediaList = mediaList;
        _errorMessage = '';
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
