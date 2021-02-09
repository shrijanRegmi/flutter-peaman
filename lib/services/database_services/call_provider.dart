import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/helpers/chat_helper.dart';
import 'package:peaman/models/app_models/call_model.dart';
import 'package:peaman/models/app_models/user_model.dart';

class CallProvider {
  final Call call;
  final AppUser appUser;
  final AppUser friend;

  CallProvider({
    this.appUser,
    this.friend,
    this.call,
  });

  final _ref = FirebaseFirestore.instance;

  // call friend
  Future callFriend() async {
    try {
      final _appUserRef = appUser.appUserRef;
      final _friendRef = friend.appUserRef;

      await _addToCollection();

      await _sendCalltoUsers(_appUserRef);
      await _sendCalltoUsers(_friendRef);

      print('Success: Calling user ${friend.uid}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Calling user ${friend.uid}');
      return null;
    }
  }

  // add call to collectoin
  Future _addToCollection() async {
    final _id = ChatHelper().getChatId(myId: appUser.uid, friendId: friend.uid);
    final _callRef = _ref.collection('calls').doc(_id);

    try {
      final _call = call.copyWith(
        id: _id,
      );
      await _callRef.set(_call.toJson());
      print('Success: Adding call to ${_callRef.path}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Adding call to ${_callRef.path}');
      return null;
    }
  }

  // send call to users
  Future _sendCalltoUsers(final DocumentReference userRef) async {
    try {
      final _id =
          ChatHelper().getChatId(myId: appUser.uid, friendId: friend.uid);
      final _callRef = userRef.collection('calls').doc(_id);
      await _callRef.set({
        'call_ref': _callRef,
      });
      print('Success: Sending Call data to user ${userRef.path}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Sending Call data to user ${userRef.path}');
      return null;
    }
  }

  // end call
  Future endCall() async {
    try {
      final _callRef = _ref.collection('calls').doc(call.id);
      final _appUserCallRef =
          appUser.appUserRef.collection('calls').doc(call.id);
      final _friendCallRef = friend.appUserRef.collection('calls').doc(call.id);

      await _callRef.update({
        'has_expired': true,
      });
      await _appUserCallRef.update({
        'has_expired': true,
      });
      await _friendCallRef.update({
        'has_expired': true,
      });

      print('Success: Ending call ${call.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Ending call ${call.id}');
    }
  }
}
