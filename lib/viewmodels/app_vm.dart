import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';

class AppVm extends ChangeNotifier {
  List<Feed> _feeds;
  List<Feed> get feeds => _feeds;

  // get my posts
  Future getMyPosts(final AppUser appUser) async {
    final _thisFeeds = await FeedProvider(appUser: appUser).getMyPosts();

    if (_thisFeeds != null) {
      _feeds = _thisFeeds;
    }

    notifyListeners();
  }

  // update value of feeds list
  updateFeedsList(final List<Feed> newFeedsList) {
    _feeds = newFeedsList;

    notifyListeners();
  }
}
