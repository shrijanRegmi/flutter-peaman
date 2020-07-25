import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/message_model.dart';

class MessageProvider {
  final String chatId;
  MessageProvider({this.chatId});

  final _ref = Firestore.instance;

  // send message
  Future sendMessage({@required final Message message}) async {
    try {
      final _message = Message.toJson(message);
      final _messagesRef =
          _ref.collection('chats').document(chatId).collection('messages');
      return await _messagesRef.add(_message);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // message from firebase
  List<Message> _messageFromFirebase(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return Message.fromJson(doc.data);
    }).toList();
  }

  // stream of messages;
  Stream<List<Message>> get messagesList {
    return _ref
        .collection('chats')
        .document(chatId)
        .collection('messages')
        .orderBy('milliseconds', descending: true)
        .snapshots()
        .map(_messageFromFirebase);
  }
}
