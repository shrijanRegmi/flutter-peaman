import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';

class AppVm extends ChangeNotifier {
  List<Feed> _feeds;
  List<Feed> _myFeeds;
  List<Feed> _myFeaturedFeeds;
  bool _isLoadingOldFeeds = false;
  List<Moment> _moments = [];

  List<Feed> get feeds => _feeds;
  List<Feed> get myFeeds => _myFeeds;
  List<Feed> get myFeaturedfeeds => _myFeaturedFeeds;
  bool get isLoadingOldFeeds => _isLoadingOldFeeds;
  List<Moment> get moments => _moments;

  // get posts
  Future getPostsById(final AppUser appUser) async {
    final _thisFeeds = await FeedProvider(appUser: appUser).getPostsById();

    updateMyFeedsList(_thisFeeds);

    final _thisFeaturedFeeds =
        await FeedProvider(appUser: appUser).getFeaturedPostsById();

    updateMyFeaturedFeedsList(_thisFeaturedFeeds);
  }

  // get timeline
  Future getTimeline(final AppUser appUser) async {
    final _thisFeeds = await FeedProvider(appUser: appUser).getTimeline();

    updateFeedsList(_thisFeeds);

    final _thisFeaturedFeeds =
        await FeedProvider(appUser: appUser).getFeaturedPostsById();

    updateMyFeaturedFeedsList(_thisFeaturedFeeds);
  }

  // get moments
  Future getMoments(final AppUser appUser) async {
    final _thisMoments = await FeedProvider(appUser: appUser).getMoments();
    _moments = _thisMoments;
    notifyListeners();
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

  // update value of moments list
  updateMomentsList(final List<Moment> newMoments) {
    _moments = newMoments;
    notifyListeners();
  }
}
