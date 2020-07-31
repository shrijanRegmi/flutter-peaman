import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:provider/provider.dart';

class SearchVm extends ChangeNotifier {
  final BuildContext context;
  SearchVm({@required this.context});

  List<AppUser> get allUsers => Provider.of<List<AppUser>>(context);
  AppUser get appUser => Provider.of<AppUser>(context);
}
