import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';

class ExploreVm extends ChangeNotifier {
  BuildContext context;
  ExploreVm(this.context);

  bool _isShowingTopLoader = false;
  ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController get scrollController => _scrollController;
  bool get isShowingTopLoader => _isShowingTopLoader;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // init function
  onInit(AppVm appVm, AppUser appUser) {
    _getOldFeeds(appVm, appUser);
  }

  // fetch old feeds
  _getOldFeeds(AppVm appVm, AppUser appUser) {
    _scrollController.addListener(
      () async {
        if (_scrollController.offset > 200.0) {
          if (!_isShowingTopLoader) {
            _updateTopLoader(true);
          }
        } else {
          if (_isShowingTopLoader) {
            _updateTopLoader(false);
          }
        }

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

  // fetch old feeds
  getNewFeeds(AppVm appVm, AppUser appUser) async {
    if (!appVm.isLoadingOldFeeds) {
      _scrollController.jumpTo(0);
      AppUserProvider(uid: appUser.uid).updateUserDetail(data: {
        'new_posts': false,
      });
      appVm.updateIsLoadingNewFeeds(true);
      final _newFeeds = appVm.feeds.isEmpty
          ? await FeedProvider(appUser: appUser).getTimeline()
          : await FeedProvider(appUser: appUser, feed: appVm.feeds.first)
              .getNewTimelinePosts();
      if (_newFeeds != null) {
        if (_newFeeds.isNotEmpty) {
          _newFeeds.removeAt(_newFeeds.length - 1);
        }

        appVm.updateFeedsList([..._newFeeds, ...appVm.feeds]);
        appVm.updateIsLoadingNewFeeds(false);
      }
    }
  }

  // post moments
  createMoment(final AppUser appUser, final AppVm appVm) async {
    // final _moment = Moment(
    //   photo:
    //       'https://lh3.googleusercontent.com/proxy/Ygf_jIE9ShY0IdkQZ99UMSeaag_KJQzRiNDvBkFg4t-BBsqHY0jcSgP0b6oIO1vO5fMK9rJ1vn6_G9CvR-qpvAfMVJbEyLC-HqlFxuHWGVn8FoXiey0y53TeL_nsbw',
    //   ownerId: appUser.uid,
    //   owner: appUser,
    //   ownerRef: appUser.appUserRef,
    //   updatedAt: DateTime.now().millisecondsSinceEpoch,
    // );

    // final _result = await FeedProvider(moment: _moment).createMoment();

    // final _existingMoments = appVm.moments;
    // _existingMoments.insert(0, _result);
    // appVm.updateMomentsList(_existingMoments);
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('This feature is being developed')));
  }

  // update value of top loader
  _updateTopLoader(final bool newVal) {
    _isShowingTopLoader = newVal;

    notifyListeners();
  }
}
