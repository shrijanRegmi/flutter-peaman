import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/comment_model.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';

class FeedProvider {
  final AppUser appUser;
  final Feed feed;
  FeedProvider({this.appUser, this.feed});

  final _ref = Firestore.instance;

  // create post
  Future<Feed> createPost() async {
    try {
      final _postref = _ref.collection('posts').document();
      Feed _feed = feed;
      _feed = _feed.copyWith(id: _postref.documentID, feedRef: _postref);
      await _postref.setData(_feed.toJson());
      print('Success: Creating post');

      await _addPhotosCount(feed.photos.length);

      if (feed.isFeatured) {
        await _saveFeatured(_feed);
      }

      return _feed;
    } catch (e) {
      print(e);
      print('Error!!!: Creating post');
      return null;
    }
  }

  // send feed to friends timeline
  Future sendToTimelines() async {
    try {
      final _userRef = appUser.appUserRef;
      final _followersRef = _userRef.collection('followers');
      final _followersSnap = await _followersRef.getDocuments();
      if (_followersSnap.documents.isNotEmpty) {
        for (final _docSnap in _followersSnap.documents) {
          if (_docSnap.exists) {
            final _data = _docSnap.data;
            final _uid = _data['id'];
            final _timelineRef = _ref
                .collection('users')
                .document(_uid)
                .collection('timeline')
                .document(feed.id);

            await _timelineRef.setData({
              'id': feed.id,
              'post_ref': feed.feedRef,
              'updated_at': DateTime.now().millisecondsSinceEpoch,
            });
            print('Success: Posting to $_uid timeline');
          }
        }
      }
      print('Success: Saving to followers timeline');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Saving to followers timeline');
      return null;
    }
  }

  // save featured post to users collection too
  Future _saveFeatured(final Feed _feed) async {
    try {
      final _userRef = appUser.appUserRef;
      final _featuredPostsRef =
          _userRef.collection('featured_posts').document(_feed.id);

      await _featuredPostsRef.setData({
        'post_ref': _feed.feedRef,
      });

      print('Success: Saving featured post ${feed.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Success: Saving featured post ${feed.id}');
      return null;
    }
  }

  // react to post
  Future reactPost() async {
    try {
      final _postRef = _ref.collection('posts').document(feed.id);
      final _reactionsRef =
          _postRef.collection('reactions').document(appUser.uid);

      final _reactionSnap = await _reactionsRef.get();

      final _reactionData = {
        'uid': appUser.uid,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      };

      await _reactionsRef.setData(_reactionData);

      final _postSnap = await _postRef.get();
      final _postData = _postSnap.data;
      final _thisFeed = Feed.fromJson(_postData, null);

      if (!_reactionSnap.exists) {
        final _data = {
          'reaction_count': FieldValue.increment(1),
          'init_reactor': appUser.name,
          'reactors_photo': FieldValue.arrayUnion([appUser.photoUrl]),
        };

        if (_thisFeed.initialReactor != '') {
          _data.removeWhere((key, value) => key == 'init_reactor');
        }

        if (_thisFeed.reactorsPhoto.length >= 3) {
          _data.removeWhere((key, value) => key == 'reactors_photo');
        }

        await _postRef.updateData(_data);
      }

      print('Success: Reacting to post ${feed.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Reacting to post ${feed.id}');
      return null;
    }
  }

  // unreact to post
  Future unReactPost() async {
    try {
      final _postRef = _ref.collection('posts').document(feed.id);
      final _reactionsRef =
          _postRef.collection('reactions').document(appUser.uid);

      await _reactionsRef.delete();

      Map<String, dynamic> _data = {
        'reaction_count': FieldValue.increment(-1),
        'init_reactor': appUser.name,
        'reactors_photo': FieldValue.arrayRemove([appUser.photoUrl]),
      };

      final _postSnap = await _postRef.get();
      final _postData = _postSnap.data;
      final _thisFeed = Feed.fromJson(_postData, null);

      if (_thisFeed.initialReactor == appUser.name &&
          _thisFeed.reactorsPhoto.contains(appUser.photoUrl)) {
        _data['init_reactor'] = '';
      } else {
        _data.removeWhere((key, value) => key == 'init_reactor');
      }

      await _postRef.updateData(_data);
      print('Success: Unreacting to post ${feed.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Unreacting to post ${feed.id}');
      return null;
    }
  }

  // comment in a post
  Future commentPost(final Comment comment) async {
    try {
      final _feedRef = _ref.collection('posts').document(feed.id);
      final _commentRef = _feedRef.collection('comments').document();
      final _comment = comment.copyWith(id: _commentRef.documentID);

      await _commentRef.setData(_comment.toJson());
      print('Success: Commenting in post ${feed.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Commenting in post ${feed.id}');
      return null;
    }
  }

  // update photos count
  Future _addPhotosCount(final int count) async {
    try {
      final _userRef = appUser.appUserRef;

      await _userRef.updateData({
        'photos': FieldValue.increment(count),
      });

      print('Success: Increasing photos count');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Increasing photos count');
    }
  }

  // get posts by id
  Future<List<Feed>> getPostsById() async {
    try {
      List<Feed> _feeds = [];

      final _postsRef = _ref
          .collection('posts')
          .where('owner_id', isEqualTo: appUser.uid)
          .orderBy('updated_at', descending: true)
          .limit(6);

      final _postSnap = await _postsRef.getDocuments();

      if (_postSnap.documents.isNotEmpty) {
        for (final doc in _postSnap.documents) {
          final _data = doc.data;
          final _owner = await AppUser().fromRef(_data['owner_ref']);
          Feed _feed = Feed.fromJson(doc.data, _owner);

          final _reactionsRef = _ref
              .collection('posts')
              .document(_feed.id)
              .collection('reactions')
              .document(appUser.uid);

          final _reactionSnap = await _reactionsRef.get();
          if (_reactionSnap.exists) {
            _feed = _feed.copyWith(isReacted: true);
          } else {
            _feed = _feed.copyWith(isReacted: false);
          }

          if (_feed.initialReactor == appUser.name &&
              _feed.reactorsPhoto.contains(appUser.photoUrl)) {
            _feed = _feed.copyWith(initialReactor: 'You');
          }

          _feeds.add(_feed);
          print('Success: Getting single post ${_feed.toJson()}');
        }
      }
      print('Success: Getting my posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting my posts');
      return null;
    }
  }

  // get featured posts by id
  Future<List<Feed>> getFeaturedPostsById() async {
    try {
      List<Feed> _feeds = [];

      final _featuredPosts =
          appUser.appUserRef.collection('featured_posts').limit(6);

      final _featuredPostsSnap = await _featuredPosts.getDocuments();

      if (_featuredPostsSnap.documents.isNotEmpty) {
        for (final doc in _featuredPostsSnap.documents) {
          final DocumentReference _postRef = doc.data['post_ref'];
          final _postSnap = await _postRef.get();
          final _data = _postSnap.data;
          final _owner = await AppUser().fromRef(_data['owner_ref']);
          Feed _feed = Feed.fromJson(_data, _owner);

          final _reactionsRef = _ref
              .collection('posts')
              .document(_feed.id)
              .collection('reactions')
              .document(appUser.uid);

          final _reactionSnap = await _reactionsRef.get();
          if (_reactionSnap.exists) {
            _feed = _feed.copyWith(isReacted: true);
          } else {
            _feed = _feed.copyWith(isReacted: false);
          }

          if (_feed.initialReactor == appUser.name &&
              _feed.reactorsPhoto.contains(appUser.photoUrl)) {
            _feed = _feed.copyWith(initialReactor: 'You');
          }

          _feeds.add(_feed);
          print('Success: Getting single featured post ${_feed.toJson()}');
        }
      }
      print('Success: Getting featured posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting featured posts');
      return null;
    }
  }

  // get my timeline
  Future<List<Feed>> getTimeline() async {
    try {
      List<Feed> _feeds = [];

      final _userRef = appUser.appUserRef;
      final _timelineRef = _userRef
          .collection('timeline')
          .orderBy('updated_at', descending: true)
          .limit(6);

      final _timelineSnap = await _timelineRef.getDocuments();

      if (_timelineSnap.documents.isNotEmpty) {
        for (final doc in _timelineSnap.documents) {
          final _data = doc.data;
          final DocumentReference _postRef = _data['post_ref'];
          final _postSnap = await _postRef.get();

          if (_postSnap.exists) {
            final _postData = _postSnap.data;
            final _owner = await AppUser().fromRef(_postData['owner_ref']);

            Feed _feed = Feed.fromJson(_postData, _owner);

            final _reactionsRef = _ref
                .collection('posts')
                .document(_feed.id)
                .collection('reactions')
                .document(appUser.uid);

            final _reactionSnap = await _reactionsRef.get();
            if (_reactionSnap.exists) {
              _feed = _feed.copyWith(isReacted: true);
            } else {
              _feed = _feed.copyWith(isReacted: false);
            }

            if (_feed.initialReactor == appUser.name &&
                _feed.reactorsPhoto.contains(appUser.photoUrl)) {
              _feed = _feed.copyWith(initialReactor: 'You');
            }

            _feeds.add(_feed);
            print('Success: Getting single post ${_feed.toJson()}');
          }
        }
      }
      print('Success: Getting my posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting my posts');
      return null;
    }
  }

  // get posts by id
  Future<List<Feed>> getPosts() async {
    try {
      List<Feed> _feeds = [];

      final _postsRef = _ref
          .collection('posts')
          .where('owner_id', isEqualTo: appUser.uid)
          .orderBy('updated_at', descending: true)
          .limit(6);

      final _postSnap = await _postsRef.getDocuments();

      if (_postSnap.documents.isNotEmpty) {
        for (final doc in _postSnap.documents) {
          final _data = doc.data;
          final _owner = await AppUser().fromRef(_data['owner_ref']);
          Feed _feed = Feed.fromJson(doc.data, _owner);

          final _reactionsRef = _ref
              .collection('posts')
              .document(_feed.id)
              .collection('reactions')
              .document(appUser.uid);

          final _reactionSnap = await _reactionsRef.get();
          if (_reactionSnap.exists) {
            _feed = _feed.copyWith(isReacted: true);
          } else {
            _feed = _feed.copyWith(isReacted: false);
          }

          if (_feed.initialReactor == appUser.name &&
              _feed.reactorsPhoto.contains(appUser.photoUrl)) {
            _feed = _feed.copyWith(initialReactor: 'You');
          }

          _feeds.add(_feed);
          print('Success: Getting single post ${_feed.toJson()}');
        }
      }
      print('Success: Getting my posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting my posts');
      return null;
    }
  }

  // get old posts by id
  Future<List<Feed>> getOldPostsById() async {
    try {
      List<Feed> _feeds = [];

      final _postsRef = _ref
          .collection('posts')
          .where('owner_id', isEqualTo: appUser.uid)
          .orderBy('updated_at', descending: true)
          .startAfter([feed.updatedAt]).limit(5);

      final _postSnap = await _postsRef.getDocuments();

      if (_postSnap.documents.isNotEmpty) {
        for (final doc in _postSnap.documents) {
          final _data = doc.data;
          final _owner = await AppUser().fromRef(_data['owner_ref']);
          Feed _feed = Feed.fromJson(doc.data, _owner);

          final _reactionsRef = _ref
              .collection('posts')
              .document(_feed.id)
              .collection('reactions')
              .document(appUser.uid);

          final _reactionSnap = await _reactionsRef.get();
          if (_reactionSnap.exists) {
            _feed = _feed.copyWith(isReacted: true);
          } else {
            _feed = _feed.copyWith(isReacted: false);
          }

          if (_feed.initialReactor == appUser.name &&
              _feed.reactorsPhoto.contains(appUser.photoUrl)) {
            _feed = _feed.copyWith(initialReactor: 'You');
          }

          _feeds.add(_feed);
          print('Success: Getting single old post ${_feed.toJson()}');
        }
      }
      print('Success: Getting my old posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting my old posts');
      return null;
    }
  }

  // get old posts of timeline
  Future<List<Feed>> getOldTimelinePosts() async {
    try {
      List<Feed> _feeds = [];

      final _userRef = appUser.appUserRef;

      final _timelineRef = _userRef
          .collection('timeline')
          .orderBy('updated_at', descending: true)
          .startAfter([feed.updatedAt]).limit(5);

      final _timelineSnap = await _timelineRef.getDocuments();

      if (_timelineSnap.documents.isNotEmpty) {
        for (final doc in _timelineSnap.documents) {
          final _data = doc.data;
          final DocumentReference _postRef = _data['post_ref'];
          final _postSnap = await _postRef.get();

          if (_postSnap.exists) {
            final _postData = _postSnap.data;
            final _owner = await AppUser().fromRef(_postData['owner_ref']);

            Feed _feed = Feed.fromJson(_postData, _owner);

            final _reactionsRef = _ref
                .collection('posts')
                .document(_feed.id)
                .collection('reactions')
                .document(appUser.uid);

            final _reactionSnap = await _reactionsRef.get();
            if (_reactionSnap.exists) {
              _feed = _feed.copyWith(isReacted: true);
            } else {
              _feed = _feed.copyWith(isReacted: false);
            }

            if (_feed.initialReactor == appUser.name &&
                _feed.reactorsPhoto.contains(appUser.photoUrl)) {
              _feed = _feed.copyWith(initialReactor: 'You');
            }

            _feeds.add(_feed);
            print('Success: Getting single post ${_feed.toJson()}');
          }
        }
      }
      print('Success: Getting old timeline posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting old timeline posts');
      return null;
    }
  }

  // get comment
  Future<List<Comment>> getComments() async {
    try {
      List<Comment> _comments = [];

      final _commentRef = feed.feedRef
          .collection('comments')
          .orderBy('updated_at', descending: true)
          .limit(10);
      final _commentSnap = await _commentRef.getDocuments();

      if (_commentSnap.documents.isNotEmpty) {
        for (final commentDoc in _commentSnap.documents) {
          final _commentData = commentDoc.data;
          final DocumentReference _userRef = _commentData['user_ref'];
          final _userSnap = await _userRef.get();
          if (_userSnap.exists) {
            final _userData = _userSnap.data;
            final _user = AppUser.fromJson(_userData);
            final _comment = Comment.fromJson(_commentData, _user);

            _comments.add(_comment);
          }
        }
      }

      print('Success: Getting all comments');
      return _comments;
    } catch (e) {
      print(e);
      print('Error!!!: Getting all comments');
      return null;
    }
  }
}
