import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:provider/provider.dart';

class FeedVm extends ChangeNotifier {
  final BuildContext context;
  FeedVm({this.context});

  Feed _thisFeed;

  Feed get thisFeed => _thisFeed;

  // init function
  onInit(final Feed _feed) {
    _initializeFeed(_feed);
  }

  // react to post
  Future reactPost(final AppUser appUser) async {
    if (!_thisFeed.isReacted) {
      _updateFeed(
        isReacted: true,
        initReactor:
            _thisFeed.initialReactor == '' || _thisFeed.initialReactor == null
                ? 'You'
                : null,
        reactionCount: (_thisFeed.reactionCount ?? 0) + 1,
        reactorsPhoto: _thisFeed.reactorsPhoto.length < 3
            ? [..._thisFeed.reactorsPhoto, appUser.photoUrl]
            : null,
      );
      return await FeedProvider(appUser: appUser, feed: _thisFeed).reactPost();
    }
  }

  // unreact post
  Future unReactPost(final AppUser appUser) async {
    if (_thisFeed.isReacted) {
      _updateFeed(
        isReacted: false,
        initReactor: _thisFeed.initialReactor == appUser.name &&
                _thisFeed.reactorsPhoto.contains(appUser.photoUrl)
            ? ''
            : null,
        reactionCount: _thisFeed.reactionCount - 1,
        reactorsPhoto: _thisFeed.reactorsPhoto
            .where((photo) => photo != appUser.photoUrl)
            .toList(),
      );
      return await FeedProvider(appUser: appUser, feed: _thisFeed)
          .unReactPost();
    }
  }

  // save post
  Future savePost(final AppUser appUser) async {
    _updateFeed(isSaved: !_thisFeed.isSaved);

    if (!_thisFeed.isSaved) {
      await FeedProvider(appUser: appUser, feed: _thisFeed).removeSavedPost();
    } else {
      await FeedProvider(appUser: appUser, feed: _thisFeed).savePost();
    }
  }

  // initialize feed
  _initializeFeed(final Feed feed) {
    _thisFeed = feed;
    notifyListeners();
  }

  // update value of feed
  _updateFeed({
    bool isReacted,
    String initReactor,
    int reactionCount,
    List<String> reactorsPhoto,
    bool isSaved,
  }) {
    final _appVm = Provider.of<AppVm>(context, listen: false);

    _thisFeed = _thisFeed.copyWith(
      isReacted: isReacted,
      initialReactor: initReactor,
      reactionCount: reactionCount,
      reactorsPhoto: reactorsPhoto,
      isSaved: isSaved,
    );

    _appVm.updateSingleFeed(_thisFeed);
    notifyListeners();
  }

  // delete my feed
  deleteMyFeed(final Feed feed, final AppVm vm, final AppUser appUser) async {
    final _myFeeds = vm.myFeeds ?? [];
    final _myFeaturedFeeds = vm.myFeaturedfeeds ?? [];

    if (_myFeeds.contains(feed)) {
      _myFeeds.remove(feed);

      vm.updateMyFeedsList(_myFeeds);
    }

    if (_myFeaturedFeeds.contains(feed)) {
      _myFeaturedFeeds.remove(feed);

      vm.updateMyFeaturedFeedsList(_myFeaturedFeeds);
    }

    final _result =
        await FeedProvider(feed: feed, appUser: appUser).deletePost();
    if (_result != null) {
      Navigator.pop(context);
    }
  }
}
