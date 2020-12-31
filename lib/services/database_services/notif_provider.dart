import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/models/app_models/user_model.dart';

class NotificationProvider {
  final AppUser appUser;
  NotificationProvider({this.appUser});

  final _ref = Firestore.instance;

  // get notification from firebase
  List<Notifications> notificationFromFirebase(QuerySnapshot colSnap) {
    return colSnap.documents
        .map((doc) => Notifications.fromJson(doc.data, doc.documentID))
        .toList();
  }

  // stream of notifications
  Stream<List<Notifications>> get notificationsList {
    return _ref
        .collection('users')
        .document(appUser.uid)
        .collection('notifications')
        .snapshots()
        .map(notificationFromFirebase);
  }
}
