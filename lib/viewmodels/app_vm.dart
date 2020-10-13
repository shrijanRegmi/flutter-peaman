import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';

class AppVm extends ChangeNotifier {
  List<Feed> _feeds;
  List<Feed> _myFeeds;
  List<Feed> _myFeaturedFeeds;
  bool _isLoadingOldFeeds = false;

  List<Feed> get feeds => _feeds;
  List<Feed> get myFeeds => _myFeeds;
  List<Feed> get myFeaturedfeeds => _myFeaturedFeeds;
  bool get isLoadingOldFeeds => _isLoadingOldFeeds;

  // get posts
  Future getPostsById(final AppUser appUser) async {
    final _thisFeeds = await FeedProvider(appUser: appUser).getPostsById();

    updateFeedsList(_thisFeeds);
    updateMyFeedsList(_thisFeeds);

    final _thisFeaturedFeeds =
        await FeedProvider(appUser: appUser).getFeaturedPostsById();

    updateMyFeaturedFeedsList(_thisFeaturedFeeds);
  }

  // update value of feeds list
  updateFeedsList(final List<Feed> newFeedsList) {
    _feeds = newFeedsList;
    notifyListeners();
  }

  // update value of my feeds list
  updateMyFeedsList(final List<Feed> newFeedsList) {
    _myFeeds = newFeedsList;
    notifyListeners();
  }

  // update value of my featured feeds list
  updateMyFeaturedFeedsList(final List<Feed> newFeedsList) {
    _myFeaturedFeeds = newFeedsList;
    notifyListeners();
  }

  // update value of is loading old feeds
  updateIsLoadingOldFeeds(final bool newVal) {
    _isLoadingOldFeeds = newVal;
    notifyListeners();
  }
}
