import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final DocumentReference firstUserRef;
  final DocumentReference secondUserRef;
  final DocumentReference lastMsgRef;
  final bool firstUserTyping;
  final bool secondUserTyping;

  Chat({
    this.firstUserRef,
    this.secondUserRef,
    this.firstUserTyping,
    this.secondUserTyping,
    this.lastMsgRef,
  });

  static Map<String, dynamic> toJson(Chat chat) {
    return {
      'first_user_ref': chat.firstUserRef,
      'second_user_ref': chat.secondUserRef,
      'first_user_typing': chat.firstUserTyping,
      'second_user_typing': chat.secondUserTyping,
      'last_msg_ref': chat.lastMsgRef,
    };
  }

  static Chat fromJson(Map<String, dynamic> data) {
    return Chat(
      firstUserRef: data['first_user_ref'],
      secondUserRef: data['second_user_ref'],
      firstUserTyping: data['first_user_typing'] ?? false,
      secondUserTyping: data['second_user_typing'] ?? false,
      lastMsgRef: data['last_msg_ref'],
    );
  }
}
