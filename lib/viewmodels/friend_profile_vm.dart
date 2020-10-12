import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/services/database_services/friend_provider.dart';

class FriendProfileVm extends ChangeNotifier {
  List<Feed> _feeds;
  bool _isLoading = false;
  String _btnText = 'Follow';

  List<Feed> get feeds => _feeds;
  bool get isLoading => _isLoading;
  String get btnText => _btnText;

  // init function
  onInit(final AppUser appUser, final AppUser user) async {
    _updateIsLoading(true);
    await _getPosts(user);
    await _getInitialBtnText(appUser, user);
    _updateIsLoading(false);
  }

  // follow user
  Future followUser(final AppUser appUser, final AppUser user) async {
    _updateBtnText('Cancle Follow');
    await FriendProvider(appUser: appUser, user: user).follow();
  }

  // accept follow
  Future acceptFollow(final AppUser appUser, final AppUser user) async {
    _updateBtnText('Follow Back');
    await FriendProvider(appUser: appUser, user: user).acceptFollow();
  }

  // followback
  Future followBack(final AppUser appUser, final AppUser user) async {
    _updateBtnText('Following');
    await FriendProvider(appUser: appUser, user: user).followBack();
  }

  // cancle follow
  Future cancleFollow(final AppUser appUser, final AppUser user) async {
    _updateBtnText('Follow');
    await FriendProvider(appUser: appUser, user: user).cancleFollow();
  }

  // get posts
  Future _getPosts(final AppUser user) async {
    final _result = await FeedProvider(appUser: user).getPostsById();
    _updateFeeds(_result);
  }

  // get initial btn text
  Future _getInitialBtnText(final AppUser appUser, final AppUser user) async {
    try {
      final _friendRef = user.appUserRef;
      final _userRef = appUser.appUserRef;

      final _friendRequestsRef =
          _friendRef.collection('requests').document(appUser.uid);
      final _userRequestsRef =
          _userRef.collection('requests').document(user.uid);
      final _friendFollowersRef =
          _friendRef.collection('followers').document(appUser.uid);
      final _userFollowersRef =
          _userRef.collection('followers').document(user.uid);

      final _friendRequestsSnap = await _friendRequestsRef.get();
      final _userRequestsSnap = await _userRequestsRef.get();
      final _friendFollowersSnap = await _friendFollowersRef.get();
      final _userFollowersSnap = await _userFollowersRef.get();

      if (_friendRequestsSnap.exists) {
        _updateBtnText('Cancle Follow');
      }

      if (_userRequestsSnap.exists) {
        _updateBtnText('Accept Follow');
      }

      if (_userFollowersSnap.exists && !_friendFollowersSnap.exists) {
        _updateBtnText('Follow Back');
      }

      if (_friendFollowersSnap.exists) {
        _updateBtnText('Following');
      }

      print('Success: Getting initial btn text $_btnText');
    } catch (e) {
      print('Error!!!: Getting initial btn text');
    }
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

  // update value of btn text
  _updateBtnText(final String newBtnText) {
    _btnText = newBtnText;
    notifyListeners();
  }
}
