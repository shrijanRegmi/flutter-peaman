import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/user_model.dart';

class AppUserProvider {
  final String uid;
  final String searchKey;
  final DocumentReference userRef;
  final AppUser user;
  AppUserProvider({
    this.uid,
    this.userRef,
    this.searchKey,
    this.user,
  });
  final _ref = FirebaseFirestore.instance;

  // set user active status
  Future setUserActiveStatus({@required OnlineStatus onlineStatus}) async {
    try {
      final _userRef = _ref.collection('users').doc(uid);
      final _status = {
        'active_status': onlineStatus.index,
      };
      if (onlineStatus == OnlineStatus.away) {
        _status['last_active'] = DateTime.now().millisecondsSinceEpoch;
      }
      await _userRef.update(_status);
      print(
          'Success: Setting activity status of user $uid to ${onlineStatus.index}');
      return 'Success';
    } catch (e) {
      print(
          'Error!!!: Setting activity status of user $uid to ${onlineStatus.index}');
      print(e);
      return null;
    }
  }

  // update user details
  Future updateUserDetail({@required final Map<String, dynamic> data}) async {
    try {
      final _userRef = _ref.collection('users').doc(uid);
      await _userRef.update(data);

      print('Success: Updating personal info of user $uid');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating personal info of user $uid');
      return null;
    }
  }

  // appuser from firebase;
  AppUser _appUserFromFirebase(DocumentSnapshot snap) {
    return AppUser.fromJson(snap.data());
  }

  // get appuser by id
  Future<AppUser> getUserById() async {
    AppUser _appUser;

    try {
      final _appUserRef = _ref.collection('users').doc(uid);
      final _appUserSnap = await _appUserRef.get();
      if (_appUserSnap.exists) {
        final _appUserData = _appUserSnap.data();
        _appUser = AppUser.fromJson(_appUserData);
      }
    } catch (e) {
      print(e);
      print('Error!!!: Getting user from id $uid');
    }

    return _appUser;
  }

  // list of users;
  List<AppUser> _usersFromFirebase(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      return AppUser.fromJson(doc.data());
    }).toList();
  }

  // get old search results
  Future<List<AppUser>> getOldSearchResults() async {
    List<AppUser> _searchResults = [];

    try {
      final _searchRef = _ref
          .collection('users')
          .where('search_key', arrayContains: searchKey)
          .orderBy('name')
          .startAfter([user.name]).limit(10);
      final _searchSnap = await _searchRef.get();
      if (_searchSnap.docs.isNotEmpty) {
        for (final doc in _searchSnap.docs) {
          final _userData = doc.data();
          final _appUser = AppUser.fromJson(_userData);

          _searchResults.add(_appUser);
        }
      }
      print('Success: Getting old search results with key $searchKey');
    } catch (e) {
      print(e);
      print('Error!!!: Getting old search results with key $searchKey');
    }

    return _searchResults;
  }

  // stream of appuser;
  Stream<AppUser> get appUser {
    return _ref
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(_appUserFromFirebase);
  }

  // stream of app user from ref
  Stream<AppUser> get appUserFromRef {
    return userRef?.snapshots()?.map(_appUserFromFirebase);
  }

  // stream of users from search key
  Stream<List<AppUser>> get appUserFromKey {
    return _ref
        .collection('users')
        .where('search_keys', arrayContains: searchKey)
        .limit(10)
        .snapshots()
        .map(_usersFromFirebase);
  }

  // stream of list of users;
  Stream<List<AppUser>> get allUsers {
    return _ref
        .collection('users')
        .limit(10)
        .snapshots()
        .map(_usersFromFirebase);
  }
}
