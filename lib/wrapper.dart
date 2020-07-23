import 'package:flutter/material.dart';
import 'package:peaman/views/screens/auth/login_screen.dart';
import 'package:peaman/views/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'models/app_models/user_model.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return _appUser == null ? LoginScreen() : HomeScreen();
  }
}
