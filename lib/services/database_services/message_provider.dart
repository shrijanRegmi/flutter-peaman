import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peaman/helpers/chat_helper.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/message_model.dart';

class MessageProvider {
  final String chatId;
  final DocumentReference messageRef;
  final String appUserId;
  MessageProvider({this.chatId, this.messageRef, this.appUserId});

  final _ref = Firestore.instance;

  // send message
  Future sendMessage({@required final Message message}) async {
    try {
      final _message = Message.toJson(message);
      final _messagesRef =
          _ref.collection('chats').document(chatId).collection('messages');
      final _chatRef = _ref.collection('chats').document(chatId);

      final _lastMsgRef = await _messagesRef.add(_message);

      final _messagesDocs = await _messagesRef.limit(2).getDocuments();

      if (_messagesDocs.documents.length == 1) {
        await _chatRef.setData({'last_updated': DateTime.now()});
        await _chatRef.updateData({'last_msg_ref': _lastMsgRef});
        _sendFirstUserSecondUser(
            myId: message.senderId, friendId: message.receiverId);
      } else {
        await _chatRef.updateData({'last_updated': DateTime.now()});
        await _chatRef.updateData({'last_msg_ref': _lastMsgRef});
      }
      print('Success: Sending message to ${message.receiverId}');
    } catch (e) {
      print(e);
      print('Error: Sending message to ${message.receiverId}');
      return null;
    }
  }

  // send additional properties with message
  Future _sendFirstUserSecondUser(
      {final String myId, final String friendId}) async {
    try {
      final _chatRef = _ref.collection('chats').document(chatId);

      final bool _isAppUserFirstUser =
          ChatHelper().isAppUserFirstUser(myId: myId, friendId: friendId);

      DocumentReference _firstUserRef;
      DocumentReference _secondUserRef;

      final _users = [myId, friendId];
      Map<String, dynamic> _userData = {
        'users': _users,
      };

      if (_isAppUserFirstUser) {
        _firstUserRef = _ref.collection('users').document(myId);
        _secondUserRef = _ref.collection('users').document(friendId);
      } else {
        _firstUserRef = _ref.collection('users').document(friendId);
        _secondUserRef = _ref.collection('users').document(myId);
      }
      await _chatRef.updateData(_userData);
      await _chatRef.updateData({'first_user_ref': _firstUserRef});
      await _chatRef.updateData({'second_user_ref': _secondUserRef});

      print('Success: Sending additonal fields in chats collection');
    } catch (e) {
      print(e);
      print('Error!!!: Sending additonal fields in chats collection');
    }
  }

  // message from firebase
  List<Message> _messageFromFirebase(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return Message.fromJson(doc.data);
    }).toList();
  }

  // message from firebase
  Message _singleMessageFrom(DocumentSnapshot snap) {
    return Message.fromJson(snap.data);
  }

  // chats from firebase
  List<Chat> _chatsFromFirebase(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return Chat.fromJson(doc.data);
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

  // stream of chats
  Stream<List<Chat>> get chatList {
    return _ref
        .collection('chats')
        .where('users', arrayContains: appUserId)
        .orderBy('last_updated', descending: true)
        .snapshots()
        .map(_chatsFromFirebase);
  }

  // stream of message from a particular reference
  Stream<Message> get messageFromRef {
    return messageRef.snapshots().map(_singleMessageFrom);
  }
}
