import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final DocumentReference firstUserRef;
  final DocumentReference secondUserRef;
  Chat({this.firstUserRef, this.secondUserRef});

  static Map<String, dynamic> toJson(Chat chat) {
    return {
      'first_user_ref': chat.firstUserRef,
      'second_user_ref': chat.secondUserRef,
    };
  }
}
