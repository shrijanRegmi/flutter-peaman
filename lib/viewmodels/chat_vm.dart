import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peaman/helpers/chat_helper.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:provider/provider.dart';

class ChatVm extends ChangeNotifier {
  final BuildContext context;
  ChatVm({this.context});

  List<Chat> get chats => Provider.of<List<Chat>>(context);
  AppUser get appUser => Provider.of<AppUser>(context);

  final _ref = Firestore.instance;

  List<Chat> get otherChats {
    final _appUserRef = _ref.collection('users').document(appUser.uid);
    return chats.where((chat) {
      if (_appUserRef?.path == chat.firstUserRef?.path) {
        return !chat.firstUserPinnedSecondUser;
      } else {
        return !chat.secondUserPinnedFirstUser;
      }
    }).toList();
  }

  List<Chat> get pinnedChats {
    final _appUserRef = _ref.collection('users').document(appUser.uid);
    return chats.where((chat) {
      if (_appUserRef?.path == chat.firstUserRef?.path) {
        return chat.firstUserPinnedSecondUser;
      } else {
        return chat.secondUserPinnedFirstUser;
      }
    }).toList();
  }
}
