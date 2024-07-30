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
  final queryController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeFunctions();
  }

  @override
  void dispose() {
    queryController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    return currentScroll >= maxScroll;
  }

  void initializeFunctions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
      mediaProvider.getMedia();
      mediaViewController.checkInternet();
      scrollController.addListener(onScroll);
    });
  }

  Future<void> onRefresh() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    mediaViewController.checkInternet();
    await mediaProvider.getMedia();
  }

  void onScroll() {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    if (_isBottom && !mediaProvider.isLoading) {
      mediaProvider.getMoreMedia();
      mediaViewController.checkInternet();
    }
  }

  void searchMedia(String query) {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    mediaProvider.searchMedia(query);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('home_page'.i18n()),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Image.asset('lib/assets/images/logo.png'),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<MediaProvider>(
              builder: (context, mediaProvider, child) {
                return Column(
                  children: [
                    SearchAppBar(
                      controller: queryController,
                      onChanged: searchMedia,
                    ),
                    const SizedBox(height: 16),
                    buildInternetStatus(),
                    Expanded(
                      child: mediaProvider.mediaList.isEmpty
                          ? mediaProvider.isLoading
                              ? const Loader()
                              : showNoItemsMessage(
                                  'no_media'.i18n(),
                                  'no_media_content'.i18n(),
                                  onRefresh,
                                )
                          : buildMediaList(mediaProvider),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInternetStatus() {
    return Watch((_) {
      return !mediaViewController.hasInternet
          ? Text(
              'outdated_data'.i18n(),
              style: const TextStyle(color: Colors.red),
            )
          : const SizedBox.shrink();
    });
  }

  Widget buildMediaList(MediaProvider provider) {
    return ListView.builder(
      controller: scrollController,
      itemCount: provider.mediaList.length + (provider.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < provider.mediaList.length) {
          final media = provider.mediaList[index];
          return MediaItem(media: media);
        } else if (provider.hasMoreData) {
          return const Loader();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
