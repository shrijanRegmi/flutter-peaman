import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/comment_model.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/models/app_models/user_model.dart';

class FeedProvider {
  final AppUser appUser;
  final Feed feed;
  FeedProvider({this.appUser, this.feed});

  final _ref = Firestore.instance;

  // create post
  Future createPost(final Feed feed) async {
    try {
      final _postref = _ref.collection('posts').document();
      feed.id = _postref.documentID;
      await _postref.setData(feed.toJson());
      print('Success: Creating post');

      _addPhotosCount(feed.photos.length);

      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Creating post');
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

  // get my posts
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

  // get my old posts
  Future<List<Feed>> getMyOldPosts() async {
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
