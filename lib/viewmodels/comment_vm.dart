import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/comment_model.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';

class CommentVm extends ChangeNotifier {
  TextEditingController _commentController = TextEditingController();
  List<Comment> _comments;

  TextEditingController get commentController => _commentController;
  List<Comment> get comments => _comments;

  // init function
  onInit(final Feed feed) {
    _getCommentList(feed);
  }

  // send comment
  Future commentPost(final Feed feed, final AppUser appUser) async {
    if (_commentController.text.trim() != '') {
      final _commentText = _commentController.text.trim();
      _commentController.clear();

      final _comment = Comment(
        user: appUser,
        userRef: appUser.appUserRef,
        comment: _commentText,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      _addToCommentsList(_comment);

      return await FeedProvider(feed: feed, appUser: appUser)
          .commentPost(_comment);
    }
  }

  // get comments list
  Future _getCommentList(final Feed feed) async {
    final _result = await FeedProvider(feed: feed).getComments();
    if (_result != null) {
      _comments = _result;
    }
    notifyListeners();
  }

  // add to comments list
  _addToCommentsList(final Comment comment) {
    _comments.insert(0, comment);
    notifyListeners();
  }
}
