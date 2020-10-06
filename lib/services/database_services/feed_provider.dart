import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/feed.dart';

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
}
