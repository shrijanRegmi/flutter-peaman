import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/moment_model.dart';
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
                    .getOldTimelinePosts();

            if (_oldFeeds != null) {
              appVm.updateFeedsList([...appVm.feeds, ..._oldFeeds]);
              appVm.updateIsLoadingOldFeeds(false);
            }
          }
        }
      },
    );
  }

  // post moments
  createMoment(final AppUser appUser, final AppVm appVm) async {
    final _moment = Moment(
      photo:
          'https://lh3.googleusercontent.com/proxy/Ygf_jIE9ShY0IdkQZ99UMSeaag_KJQzRiNDvBkFg4t-BBsqHY0jcSgP0b6oIO1vO5fMK9rJ1vn6_G9CvR-qpvAfMVJbEyLC-HqlFxuHWGVn8FoXiey0y53TeL_nsbw',
      ownerId: appUser.uid,
      owner: appUser,
      ownerRef: appUser.appUserRef,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    final _result = await FeedProvider(moment: _moment).createMoment();

    final _existingMoments = appVm.moments;
    _existingMoments.insert(0, _result);
    appVm.updateMomentsList(_existingMoments);
  }
}
