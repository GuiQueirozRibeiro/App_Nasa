// External packages
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';

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
  final mediaViewController = GetIt.instance<MediaViewController>();
  final mediaBloc = GetIt.instance<MediaBloc>();

  final searchController = TextEditingController();
  final scrollController = ScrollController();

  List<Media> mediaList = [];

  @override
  void initState() {
    super.initState();
    mediaBloc.add(GetMediaEvent());
    mediaViewController.checkInternet();
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    return currentScroll >= maxScroll;
  }

  void onScroll() {
    if (_isBottom && !mediaViewController.isLoading.value) {
      mediaViewController.updateLoadingStatus();
      mediaBloc.add(
        GetMoreMediaEvent(
          updateLoadingMoreStatus: mediaViewController.updateLoadingStatus,
        ),
      );
    }
  }

  void searchMedia(String query) {
    mediaBloc.add(SearchMediaEvent(query: query));
    mediaViewController.checkInternet();
  }

  Future<void> onRefresh() async {
    mediaBloc.add(GetMediaEvent());
    mediaViewController.checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home_page'.i18n())),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchAppBar(
                controller: searchController,
                onChanged: searchMedia,
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: mediaViewController.hasInternet,
                builder: (context, hasInternet, child) {
                  return !hasInternet
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'outdated_data'.i18n(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : const SizedBox();
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: mediaViewController.isLoading,
                builder: (context, isLoading, child) {
                  return BlocConsumer<MediaBloc, MediaState>(
                    bloc: mediaBloc,
                    listener: (context, state) {
                      if (state is MediaFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      } else if (state is MediaDisplayState &&
                          !state.hasMoreData) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('no_more_data'.i18n())),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is MediaLoading) {
                        return const Expanded(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is MediaDisplayState) {
                        mediaList = state.mediaList;
                        return Expanded(
                          child: mediaList.isEmpty
                              ? Center(child: Text('no_media'.i18n()))
                              : buildMediaListView(state),
                        );
                      }
                      return const SizedBox();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMediaListView(MediaDisplayState state) {
    return ListView.builder(
      controller: scrollController,
      itemCount:
          mediaList.length + (mediaViewController.isLoading.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < mediaList.length) {
          final media = mediaList[index];
          return MediaItem(media: media);
        } else if (state.hasMoreData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
