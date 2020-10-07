import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/services/database_services/feed_provider.dart';

class ExploreVm extends ChangeNotifier {
  List<Feed> _myFeeds = [];
  List<Feed> get myFeeds => _myFeeds;

  // init function
  onInit(final String uid) {
    _getMyPosts(uid);
  }

  // get my posts
  Future _getMyPosts(final String uid) async {
    final _feeds = await FeedProvider(uid: uid).getMyPosts();

    if (_feeds != null) {
      _myFeeds = _feeds;
    }

    notifyListeners();
  }
}
