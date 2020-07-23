import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peaman/enums/age.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/services/storage_services/user_storage_service.dart';

class AuthVm extends ChangeNotifier {
  // login user with email and password;
  Future loginUser({final String email, final String password}) {
    return AuthProvider().loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // signup user with email and password;
  Future signUpUser(
      {final File imgFile,
      final Age age,
      final String name,
      final String email,
      final String password}) async {
    final _imgPath = await UserStorage().uploadUserImage(imgFile: imgFile);

    if (_imgPath != null) {
      return AuthProvider().signUpWithEmailAndPassword(
        photoUrl: _imgPath,
        age: age,
        name: name,
        email: email,
        password: password,
      );
    }
    return null;
  }
}
