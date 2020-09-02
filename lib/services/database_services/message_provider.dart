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

      final _messagesDocs = await _messagesRef.limit(2).getDocuments();

      if (_messagesDocs.documents.length == 0) {
        await _chatRef.setData({'id': chatId});
      }
      final _lastMsgRef = await _messagesRef.add(_message);

      final bool _isAppUserFirstUser = ChatHelper().isAppUserFirstUser(
          myId: message.senderId, friendId: message.receiverId);

      final _chatSnap = await _chatRef.get();
      if (_isAppUserFirstUser) {
        final _secondUserUnreadMessagesCount = _chatSnap.data != null
            ? _chatSnap.data['second_user_unread_messages_count'] ?? 0
            : 0;

        _chatRef.updateData(
          {
            'second_user_unread_messages_count':
                _secondUserUnreadMessagesCount + 1
          },
        );
      } else {
        final _firstUserUnreadMessagesCount = _chatSnap.data != null
            ? _chatSnap.data['first_user_unread_messages_count'] ?? 0
            : 0;

        _chatRef.updateData(
          {
            'first_user_unread_messages_count':
                _firstUserUnreadMessagesCount + 1
          },
        );
      }

      _chatRef.updateData({'last_updated': DateTime.now()});
      _chatRef.updateData({'last_msg_ref': _lastMsgRef});

      if (_messagesDocs.documents.length == 0) {
        _sendAdditionalProperties(
          myId: message.senderId,
          friendId: message.receiverId,
        );
      }
      print('Success: Sending message to ${message.receiverId}');
    } catch (e) {
      print(e);
      print('Error: Sending message to ${message.receiverId}');
      return null;
    }
  }

  // send additional properties with message
  Future _sendAdditionalProperties(
      {final String myId, final String friendId, final lastMsgRef}) async {
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

  // set pinned status
  Future setPinnedStatus(
      {@required final bool isPinned,
      @required final String myId,
      @required final String friendId}) async {
    try {
      final _isAppUserFirstUser = ChatHelper().isAppUserFirstUser(
        myId: myId,
        friendId: friendId,
      );

      final _chatRef = _ref.collection('chats').document(chatId);

      Map<String, dynamic> _data;

      if (_isAppUserFirstUser) {
        _data = {
          'first_user_pinned_second_user': isPinned,
        };
      } else {
        _data = {
          'second_user_pinned_first_user': isPinned,
        };
      }

      await _chatRef.updateData(_data);
      print('Success: Pinned user with id $friendId');
      return 'Sucess';
    } catch (e) {
      print(e);
      print('Error!!!: Pinned user with id $friendId');
      return null;
    }
  }

  // update chat data
  Future updateChatData(final Map<String, dynamic> data) async {
    try {
      final _chatRef = _ref.collection('chats').document(chatId);
      await _chatRef.updateData(data);
      print('Success: Updating chat data having chatId $chatId');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating chat data having chatId $chatId');
      return null;
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
