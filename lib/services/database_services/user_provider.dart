import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/user_model.dart';

class AppUserProvider {
  final String uid;
  final DocumentReference userRef;
  AppUserProvider({this.uid, this.userRef});
  final _ref = Firestore.instance;

  // set user active status
  Future setUserActiveStatus({@required OnlineStatus onlineStatus}) async {
    try {
      final _userRef = _ref.collection('users').document(uid);
      final _status = {
        'active_status': onlineStatus.index,
      };
      return await _userRef.updateData(_status);
    } catch (e) {
      print('Error setting activity status');
      print(e);
      return null;
    }
  }

  // appuser from firebase;
  AppUser _appUserFromFirebase(DocumentSnapshot snap) {
    return AppUser.fromJson(snap.data);
  }

  // list of users;
  List<AppUser> _usersFromFirebase(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return AppUser.fromJson(doc.data);
    }).toList();
  }

  // stream of appuser;
  Stream<AppUser> get appUser {
    print('Called');
    return _ref
        .collection('users')
        .document(uid)
        .snapshots()
        .map(_appUserFromFirebase);
  }

  Stream<AppUser> get appUserFromRef {
    return userRef.snapshots().map(_appUserFromFirebase);
  }

  // stream of list of users;
  Stream<List<AppUser>> get allUsers {
    return _ref.collection('users').snapshots().map(_usersFromFirebase);
  }
}
