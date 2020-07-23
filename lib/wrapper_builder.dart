import 'package:flutter/material.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:provider/provider.dart';

import 'models/app_models/user_model.dart';

class WrapperBuilder extends StatelessWidget {
  final Function(BuildContext context) builder;
  WrapperBuilder({@required this.builder});

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    if (_user != null) {
      return MultiProvider(
        providers: [
          StreamProvider<AppUser>.value(
            value: AppUserProvider(uid: _user.uid).appUser,
          ),
        ],
        child: builder(context),
      );
    }
    return builder(context);
  }
}
