import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/models/app_models/user_model.dart';

class NotificationProvider {
  final AppUser appUser;
  NotificationProvider({this.appUser});

  final _ref = FirebaseFirestore.instance;

  // get notification from firebase
  List<Notifications> notificationFromFirebase(QuerySnapshot colSnap) {
    return colSnap.docs
        .map((doc) => Notifications.fromJson(doc.data(), doc.id))
        .toList();
  }

  // stream of notifications
  Stream<List<Notifications>> get notificationsList {
    return _ref
        .collection('users')
        .doc(appUser.uid)
        .collection('notifications')
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map(notificationFromFirebase);
  }
}
