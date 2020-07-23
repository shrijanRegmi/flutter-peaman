import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/user_model.dart';

class AppUserProvider {
  final String uid;
  AppUserProvider({this.uid});
  final _ref = Firestore.instance;

  // appuser from firebase;
  AppUser _appUserFromFirebase(DocumentSnapshot snap) {
    return AppUser.fromJson(snap.data);
  }

  // stream of appuser
  Stream<AppUser> get appUser {
    return _ref
        .collection('users')
        .document(uid)
        .snapshots()
        .map(_appUserFromFirebase);
  }
}
