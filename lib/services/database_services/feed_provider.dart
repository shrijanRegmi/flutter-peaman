import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/models/app_models/user_model.dart';

class FeedProvider {
  final String uid;
  FeedProvider({this.uid});

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
          .where('owner_id', isEqualTo: uid)
          .orderBy('updated_at', descending: true)
          .limit(10);

      final _postSnap = await _postsRef.getDocuments();

      if (_postSnap.documents.isNotEmpty) {
        for (final doc in _postSnap.documents) {
          final _data = doc.data;
          final _owner = await AppUser().fromRef(_data['owner_ref']);
          final _feed = Feed.fromJson(doc.data, _owner);
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
}
