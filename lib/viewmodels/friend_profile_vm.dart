import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';

class FriendProfileVm extends ChangeNotifier {
  List<Feed> _feeds;
  bool _isLoading = false;

  List<Feed> get feeds => _feeds;
  bool get isLoading => _isLoading;

  // init function
  onInit(final AppUser user) {
    _getPosts(user);
  }

  // get posts
  Future _getPosts(final AppUser user) async {
    _updateIsLoading(true);
    final _result = await FeedProvider(appUser: user).getPosts();
    _updateFeeds(_result);
    _updateIsLoading(false);
  }

  // update value of feeds
  _updateFeeds(final List<Feed> newFeeds) {
    _feeds = newFeeds;
    notifyListeners();
  }

  // update value of is loading
  _updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }
}
