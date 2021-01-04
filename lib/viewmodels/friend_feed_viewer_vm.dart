import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';

class FriendFeedViewerVm extends ChangeNotifier {
  ScrollController _scrollController;
  List<Feed> _thisFeeds = [];

  ScrollController get scrollController => _scrollController;
  List<Feed> get thisFeeds => _thisFeeds;

  // init function
  onInit(AppVm appVm, AppUser appUser, final List<Feed> feeds,
      final AppUser user) {
    _scrollController = ScrollController();
    _updateThisFeeds(feeds);

    _getOldFeeds(appVm, appUser, user);
  }

  // dispose function
  onDispose() {
    _scrollController?.dispose();
  }

  // fetch old feeds
  _getOldFeeds(AppVm appVm, AppUser appUser, AppUser user) {
    _scrollController.addListener(
      () async {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 50.0) {
          if (!appVm.isLoadingOldFeeds) {
            appVm.updateIsLoadingOldFeeds(true);
            final _oldFeeds = await FeedProvider(
                    appUser: appUser, user: user, feed: _thisFeeds.last)
                .getOldPostsById();

            if (_oldFeeds != null) {
              _updateThisFeeds([..._thisFeeds, ..._oldFeeds]);
              appVm.updateIsLoadingOldFeeds(false);
            }
          }
        }
      },
    );
  }

  // update value of thisfeeds
  _updateThisFeeds(final List<Feed> newFeeds) {
    _thisFeeds = newFeeds;
    notifyListeners();
  }
}
