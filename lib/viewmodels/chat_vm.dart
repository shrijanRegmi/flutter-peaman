import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:provider/provider.dart';

class ChatVm extends ChangeNotifier{
  final BuildContext context;
  ChatVm({this.context});
  
  List<Chat> get chats => Provider.of<List<Chat>>(context);
  AppUser get appUser => Provider.of<AppUser>(context);
}