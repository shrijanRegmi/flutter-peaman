import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';

class ExploreVm extends ChangeNotifier {
  BuildContext context;
  ExploreVm(this.context);

  ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  // init function
  onInit(AppVm appVm, AppUser appUser) {
    _getOldFeeds(appVm, appUser);
  }

  // fetch old feeds
  _getOldFeeds(AppVm appVm, AppUser appUser) {
    _scrollController.addListener(
      () async {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 50.0) {
          if (!appVm.isLoadingOldFeeds) {
            appVm.updateIsLoadingOldFeeds(true);
            final _oldFeeds =
                await FeedProvider(appUser: appUser, feed: appVm.feeds.last)
                    .getMyOldPosts();

            if (_oldFeeds != null) {
              appVm.updateFeedsList([...appVm.feeds, ..._oldFeeds]);
              appVm.updateIsLoadingOldFeeds(false);
            }
          }
        }
      },
    );
  }
}
