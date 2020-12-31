import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/models/app_models/user_model.dart';

class FriendProvider {
  final AppUser appUser;
  final AppUser user;
  final Notifications notification;
  FriendProvider({this.appUser, this.user, this.notification});

  // follow friend
  Future follow() async {
    try {
      final _friendRef = user.appUserRef;
      final _requestRef =
          _friendRef.collection('requests').document(appUser.uid);

      final _data = {
        'id': appUser.uid,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      };

      await _requestRef.setData(_data);
      print('Success: Following ${user.uid}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Following ${user.uid}');
    }
  }

  // accept follow request
  Future acceptFollow() async {
    try {
      final _userRef = appUser.appUserRef;
      final _requestRef = _userRef.collection('requests').document(user.uid);
      final _notifRef =
          _userRef.collection('notifications').document(notification.id);

      await _notifRef.updateData({
        'is_accepted': true,
      });
      await _requestRef.delete();
      print('Success: Deleting request doc with id ${user.uid}');

      _addFollower();

      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Deleting request doc with id ${user.uid}');
      return null;
    }
  }

  // follow back
  Future followBack() async {
    try {
      final _friendRef = user.appUserRef;
      final _userRef = appUser.appUserRef;
      final _notifRef = appUser.appUserRef
          .collection('notifications')
          .document(notification.id);

      final _friendFollowersRef =
          _friendRef.collection('followers').document(appUser.uid);
      final _userFollowingRef =
          _userRef.collection('following').document(user.uid);

      final _milli = DateTime.now().millisecondsSinceEpoch;

      await _friendFollowersRef.setData({
        'id': appUser.uid,
        'updated_at': _milli,
      });
      await _userFollowingRef.setData({
        'id': appUser.uid,
        'updated_at': _milli,
      });

      await _friendRef.updateData({
        'followers': FieldValue.increment(1),
      });
      await _userRef.updateData({
        'following': FieldValue.increment(1),
      });

      await _notifRef.delete();

      print('Success: Following back ${user.uid}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Following back ${user.uid}');
      return null;
    }
  }

  // cancle follow
  Future cancleFollow() async {
    try {
      final _userRef = appUser.appUserRef;
      final _requestRef = _userRef.collection('requests').document(user.uid);
      final _notifRef =
          _userRef.collection('notifications').document(notification.id);

      await _requestRef.delete();
      await _notifRef.delete();
      print('Success: Deleting request doc with id ${user.uid}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Deleting request doc with id ${user.uid}');
      return null;
    }
  }

  // add follower
  Future _addFollower() async {
    try {
      final _userRef = appUser.appUserRef;
      final _friendRef = user.appUserRef;

      final _userFollowersRef =
          _userRef.collection('followers').document(user.uid);
      final _friendFollowingRef =
          _friendRef.collection('following').document(appUser.uid);

      final _milli = DateTime.now().millisecondsSinceEpoch;

      await _userFollowersRef.setData({
        'id': user.uid,
        'updated_at': _milli,
      });
      await _friendFollowingRef.setData({
        'id': appUser.uid,
        'updated_at': _milli,
      });

      await _userRef.updateData({
        'followers': FieldValue.increment(1),
      });
      await _friendRef.updateData({
        'following': FieldValue.increment(1),
      });

      print('Success: Adding follower ${user.uid}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Adding follower ${user.uid}');
      return null;
    }
  }
}
