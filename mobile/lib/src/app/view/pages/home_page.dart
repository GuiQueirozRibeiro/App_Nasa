// External packages
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

// Mobile application imports
import 'package:mobile/src/app/viewmodel/bloc/media_bloc.dart';
import 'package:mobile/src/app/viewmodel/controllers/media_state_controller.dart';
import 'package:mobile/src/app/view/widgets/media_item.dart';
import 'package:mobile/src/app/view/widgets/search_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with DialogMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Media> _mediaList = [];

  @override
  void initState() {
    super.initState();
    _inithMediaData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home_page'.i18n())),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchAppBar(
                controller: _searchController,
                onChanged: _searchMedia,
              ),
              const SizedBox(height: 16),
              _buildInternetStatus(),
              _buildMediaList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInternetStatus() {
    final controller = Provider.of<MediaStateController>(context);
    return !controller.hasInternet
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'outdated_data'.i18n(),
              style: const TextStyle(color: Colors.red),
            ),
          )
        : const SizedBox();
  }

  Widget _buildMediaList() {
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {
        if (state is MediaFailure) {
          showSnackBar(state.error.i18n());
        } else if (state is MediaDisplayState && !state.hasMoreData) {
          showSnackBar('no_more_data'.i18n());
        }
      },
      builder: (context, state) {
        if (state is MediaLoading) {
          return const Expanded(child: Loader());
        }
        if (state is MediaDisplayState) {
          _mediaList = state.mediaList;
          return Expanded(
            child: _mediaList.isEmpty
                ? showNoItemsMessage(
                    'no_media'.i18n(),
                    'no_media_content'.i18n(),
                    _onRefresh,
                  )
                : _buildMediaListView(state),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildMediaListView(MediaDisplayState state) {
    final controller = Provider.of<MediaStateController>(context);
    return ListView.builder(
      controller: _scrollController,
      itemCount: _mediaList.length + (controller.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _mediaList.length) {
          final media = _mediaList[index];
          return MediaItem(media: media);
        } else if (state.hasMoreData) {
          return const Loader();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void _inithMediaData() {
    BlocProvider.of<MediaBloc>(context).add(GetMediaEvent());
    Provider.of<MediaStateController>(context, listen: false).checkInternet();
  }

  void _onScroll() {
    final controller =
        Provider.of<MediaStateController>(context, listen: false);
    if (_isBottom && !controller.isLoading) {
      controller.updateLoadingStatus();
      BlocProvider.of<MediaBloc>(context).add(
        GetMoreMediaEvent(
          updateLoadingMoreStatus: controller.updateLoadingStatus,
        ),
      );
    }
  }

  void _searchMedia(String query) {
    BlocProvider.of<MediaBloc>(context).add(SearchMediaEvent(query: query));
    Provider.of<MediaStateController>(context, listen: false).checkInternet();
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<MediaBloc>(context).add(GetMediaEvent());
    Provider.of<MediaStateController>(context, listen: false).checkInternet();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= maxScroll;
  }
}
