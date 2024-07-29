// External packages
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';

// Mobile application imports
import 'package:mobile/src/app/viewmodel/controllers/media_view_controller.dart';
import 'package:mobile/src/app/view/widgets/media_item.dart';
import 'package:mobile/src/app/view/widgets/search_app_bar.dart';
import 'package:mobile/src/app/viewmodel/providers/media_provider.dart';
import 'package:mobile/src/common/utils/dialog_mixin.dart';
import 'package:mobile/src/common/widgets/loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with DialogMixin {
  final mediaViewController = Modular.get<MediaViewController>();

  final searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    inicializeFunctions();
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

  void inicializeFunctions() {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    mediaProvider.getMedia();
    mediaViewController.checkInternet();
    scrollController.addListener(onScroll);
  }

  Future<void> onRefresh() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    await mediaProvider.getMedia();
  }

  void onScroll() {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    if (_isBottom && !mediaProvider.isLoading) {
      mediaProvider.getMoreMedia();
    }
  }

  void searchMedia(String query) {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    mediaProvider.searchMedia(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home_page'.i18n())),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<MediaProvider>(
            builder: (context, mediaProvider, child) {
              return Column(
                children: [
                  SearchAppBar(
                    controller: searchController,
                    onChanged: searchMedia,
                  ),
                  const SizedBox(height: 16),
                  noInternetMensage(),
                  if (mediaProvider.isLoading) const Expanded(child: Loader()),
                  if (mediaProvider.baseMediaList.isEmpty &&
                      !mediaProvider.isLoading)
                    Expanded(child: Center(child: Text('no_media'.i18n()))),
                  if (mediaProvider.baseMediaList.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: mediaProvider.baseMediaList.length +
                            (mediaProvider.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < mediaProvider.baseMediaList.length) {
                            final media = mediaProvider.baseMediaList[index];
                            return MediaItem(media: media);
                          } else if (mediaProvider.hasMoreData) {
                            return const Loader();
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget noInternetMensage() {
    return Watch((_) {
      return !mediaViewController.hasInternet
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'outdated_data'.i18n(),
                style: const TextStyle(color: Colors.red),
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
