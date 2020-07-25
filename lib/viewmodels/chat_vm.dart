import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:provider/provider.dart';

class ChatVm extends ChangeNotifier{
  final BuildContext context;
  ChatVm({this.context});
  
  List<AppUser> get allUsers => Provider.of<List<AppUser>>(context);
}