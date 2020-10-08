import 'package:cloud_firestore/cloud_firestore.dart';
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
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Creating post');
      return null;
    }
  }

  // get my posts
  Future<List<Feed>> getMyPosts() async {
    try {
      List<Feed> _feeds = [];

      final _postsRef = _ref
          .collection('posts')
          .where('owner_id', isEqualTo: appUser.uid)
          .orderBy('updated_at', descending: true)
          .limit(10);

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
}
