import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/wrapper.dart';
import 'package:peaman/wrapper_builder.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(PeamanApp());
}

class PeamanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      value: AuthProvider().user,
      child: WrapperBuilder(
        builder: (BuildContext context, AppUser appUser) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Upgram",
            theme: ThemeData(fontFamily: 'Nunito'),
            home: Material(child: Wrapper(appUser: appUser,)),
          );
        },
      ),
    );
  }
}
